//
//  LLNavigator.m
//  LiuLianLib
//
//  Created by BlackDev on 12/16/14.
//  Copyright (c) 2014 SF. All rights reserved.
//

#import "LLNavigator.h"
#import "UserBiz.h"
#import "UserCacheManager.h"
#import "SFAPIGlobalConfig.h"
#import "NSURL+SSN.h"
#import "AccessorManager.h"
#import "SFFWebViewController.h"
#import "SFAppInfo.h"

BOOL openURL(NSString * url){
    BOOL handles = [[LLNavigator sharedInstance] openURL:url];
    
    return handles;
}

@implementation LLNavigator

IMP_SINGLETON

#pragma mark - open url
- (BOOL)openURL:(NSString *)url{
    BOOL handles = NO;
    
    if (url) {
        if ([url isEqualToString:[SFAppInfo updateAddress]]) {
            // APP升级URL 直接打开APPStore
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            return YES;
        }

        // 过滤错误参数
        NSDictionary *oldParams = [url sf_getURLParams];
        NSString *mainString = [url sf_getURLPathString];
        url = [mainString sf_stringByAddingURLParams:oldParams];
        
        NSURL * URL         = [NSURL URLWithString:url];
        
        NSString * scheme   = URL.scheme;
        NSString * host     = URL.host;
        NSString * query    = URL.query;
        NSString * fragment = URL.fragment;
        NSString * path     = URL.path;
        
        //去除path前的“/”字符
        if (path && path.length) {
            path                = [path substringFromIndex:1];
        }
        
#pragma unused(scheme)
#pragma unused(host)
#pragma unused(query)
#pragma unused(fragment)
#pragma unused(path)
        
//        if (!([LLURLHelper isAppURL:URL] || [LLURLHelper isWebURL:URL])) {
//            [[UIApplication sharedApplication] openURL:URL];
//            handles = YES;
//            return handles;
//        }
        
        // 黑名单判断
        if (![self isURLInWhiteList:url] && [self isURLInBlackList:url]) {
            handles = NO;
            return handles;
        }
        
        BOOL isNative = NO;
        BOOL isWeb = NO;
        
        LLViewDataModel * viewDataModel = nil;
        NSString * viewIdentifier       = [LLURLHelper isAppURL:URL]?path:[LLURLMap identifierWithInternalUrl:url];
        viewDataModel                   = viewIdentifier?[self viewDataModelForIdentifier:viewIdentifier]:nil;
        NSMutableDictionary * params    = nil;
        
        // 画面权限判断
        if (viewIdentifier) {
            if (viewDataModel.role == ViewRoleLogin && !kAppDelegate.isLogin) {
                [kAppDelegate showLoginWithNavigationController:nil onComplete:^{
                    openURL(url);
                }];
                return YES;
            }
            
            if (![NSString sf_isBlankString:viewDataModel.inTab]) {
                // 如果在主tab里， 跳到主tab
                [[LLNavigator sharedInstance] gotoViewWithIdentifier:APPURL_VIEW_IDENTIFIER_TAB queryForInit:nil queryForInstance:nil propertyDictionary:@{@"index":@(viewDataModel.inTab.integerValue)} retrospect:YES animated:NO];
                return YES;
            }
        }
        
        // 通过scheme跳转
        if ([LLURLHelper isAppURL:URL]) {
            isNative                    = YES;
            if ([host isEqualToString:APPURL_HOST_VIEW]) {
                viewIdentifier                      = path;
                viewDataModel = [self viewDataModelForIdentifier:viewIdentifier];
                params                              = [LLURLHelper getURLParamsWithURL:URL defaultKey:viewDataModel.paramKey];
                
                isNative = [LLURLMap shouldLoadViewViaNativeWithIdentifier:viewIdentifier];

            }else if ([host isEqualToString:APPURL_HOST_SERVICE]){
                NSString * function                 = path;
                params                              = [LLURLHelper getURLParamsWithURL:URL defaultKey:nil];
                
                SEL selector                        = NSSelectorFromString([NSString stringWithFormat:@"%@:",function]);
                
                [self processService:selector params:params];
                handles                             = YES;
                return handles;
            }
        }else if([LLURLHelper isWebURL:URL]){ // 通过链接跳转
            isNative                                = NO;
            
            // 截获URL，判断是否要走native，
            if (viewDataModel && viewDataModel.type == ViewTypeNative) {
                isNative = YES;
                
                params = [LLURLHelper getURLParamsWithURL:URL defaultKey:viewDataModel.paramKey];
            } else if (viewDataModel && viewDataModel.type == ViewTypeWeb) {
                isWeb = YES;
            } else if (!viewDataModel){
                isWeb = YES;
            }
        }else{
            // 这里处理打电话、发短信、邮件等系统scheme
            handles = [[UIApplication sharedApplication] openURL:URL];
            return handles;
        }
        
        if (isNative) {
            NSString * retrospect               = [params objectForKey:APPURL_PARAM_RETROSPECT];
            NSString * animated                 = [params objectForKey:APPURL_PARAM_ANIMATED];
            BOOL shouldRetrospect               = retrospect ? [retrospect boolValue] : NO;
            BOOL shouldAnaimate                 = animated ? [animated boolValue] : YES;
            
            viewDataModel.queryForInitMethod    = [NSMutableDictionary dictionaryWithDictionary:params];
            [viewDataModel.queryForInitMethod setValue:viewDataModel.identifier forKey:@"_identifier"];
            viewDataModel.viewInstanceMethod    = nil;
            viewDataModel.queryForInstanceMethod= nil;
            
            [self pushViewControllerWithViewDataModel:viewDataModel propertyDict:params retrospect:shouldRetrospect animated:shouldAnaimate];
            handles = YES;
        } else {
            if (!isWeb) {
                NSString *tempPath = [LLURLMap fileUrlWithFilePath:viewDataModel.filePath];
                if (tempPath) {
                    url = tempPath;
                }
            }

            params                        = [LLURLHelper getURLParamsWithURL:URL defaultKey:viewDataModel.paramKey];
            
            // query补参数
            if (params.count > 0
                && [url rangeOfString:@"?"].location == NSNotFound
                && [url rangeOfString:@"#!"].location == NSNotFound) {
                
                url = [url stringByAppendingString:@"?"];
                url = [url stringByAppendingString:[params ssn_toQueryString]];
            }
            
            params                        = [LLURLHelper appendCustomerParamsWithOriginal:params];

            NSString * openWith           = [params objectForKey:@"_openWith"];
            NSString * title              = [params objectForKey:@"_title"];
            NSString * needsNavigationBar = [params objectForKey:@"_needsNavigationBar"];
            NSNumber * useCache = [NSNumber numberWithBool:viewDataModel.useCache];

            // 白名单判断
            if (isWeb && ![self isURLInWhiteList:url]) {
                if ([self isURLInBrowseList:url]) {
                    openWith = @"browser";
                } else {
                    return NO;
                }
            }

            // 移除参数
            NSString * newUrlString       = url;
            newUrlString                  = [newUrlString stringByReplacingOccurrencesOfString:
                                                       [NSString stringWithFormat:@"%@=%@",@"_openWith",openWith]
                                                                                              withString:@""];
            newUrlString                  = [newUrlString stringByReplacingOccurrencesOfString:
                                                       [NSString stringWithFormat:@"%@=%@",@"_title",title]
                                                                                              withString:@""];
            newUrlString                  = [newUrlString stringByReplacingOccurrencesOfString:
                                                       [NSString stringWithFormat:@"%@=%@",@"_needsNavigationBar",needsNavigationBar]
                                                                                              withString:@""];


            // 拼接参数
            if (params && [url rangeOfString:@"#!"].location == NSNotFound) {
                NSRange range = [url rangeOfString:@"#"];
                if ([url rangeOfString:@"#"].location != NSNotFound) {
                    // 没有＃！但有＃的时候，过滤＃！
                    newUrlString = [url substringToIndex:range.location];
                }
                
                newUrlString = [newUrlString stringByAppendingString:@"#!"];
            }

            
            newUrlString = [newUrlString stringByAppendingString:@"&"];
            newUrlString = [newUrlString stringByAppendingString:[params ssn_toQueryString]];

            if (openWith && [openWith isEqualToString:@"browser"]) {
                // 使用浏览器打开
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:newUrlString]];
            }else{
                // 使用webview打开
                title                     = title ? title : @"";
                needsNavigationBar        = needsNavigationBar ? needsNavigationBar : @"true";
                NSDictionary * jumpParams = @{@"_title": title,
                                                @"_needsNavigationBar": needsNavigationBar,
                                                @"_url": newUrlString,
                                                @"_desc": viewDataModel.desc ? viewDataModel.desc : @"",
                                                @"_identifier":viewDataModel ? viewDataModel.identifier : @"",
                                                @"_useCache":useCache};
                NSString * viewIdentifier = APPURL_VIEW_IDENTIFIER_WEBVIEW;
                NSString * retrospect     = [params objectForKey:APPURL_PARAM_RETROSPECT];
                NSString * animated       = [params objectForKey:APPURL_PARAM_ANIMATED];
                BOOL shouldRetrospect     = retrospect ? [retrospect boolValue] : ((openWith && [openWith isEqualToString:@"webView_Keep"])?YES:NO);
                BOOL shouldAnaimate       = animated ? [animated boolValue] : YES;
                
                [self gotoViewWithIdentifier:viewIdentifier
                                queryForInit:jumpParams
                            queryForInstance:nil
                          propertyDictionary:@{@"urlString": newUrlString}
                                  retrospect:shouldRetrospect
                                    animated:shouldAnaimate];
            }
            
            handles = YES;
        }
    
        if (handles == YES) {
            [self handleParams:params viewData:viewDataModel];
        }
    }
    
    return handles;
}

- (void)handleParams:(NSDictionary *)params viewData:(LLViewDataModel *)viewDataModel
{
    NSString *spm = [params objectForKey:@"_spm"];
    
    if (![NSString sf_isBlankString:spm]) {
        NSArray *spmItems = [spm componentsSeparatedByString:@"."];
        NSString *itemId = [params objectForKey:@"itemId"];

        if (spmItems.count > 0) {
            if ([[spmItems objectAtIndex:0] sf_isLetters]) {
                // 第一位为字母的情况，Navtive自定的smp， 前面补充domain
                spm = [NSString stringWithFormat:@"4.%@", spm];
            } else {
                if ([APPURL_VIEW_IDENTIFIER_PRODUCTDETAIL isEqualToString:viewDataModel.identifier]
                    && spmItems.count == 4
                    && itemId != nil) {
                    // 如果是商品详情页，spm是4位的情况，itemId做为第5位补充进去
                    spm = [NSString stringWithFormat:@"%@.%@", spm, itemId];
                }
            }

            if (!self.spms) {
                self.spms = [[NSMutableArray alloc] init];
            }
            
            if ([self.spms containsObject:spm]) {
                [self.spms removeObject:spm];
            }
            
            [self.spms insertObject:spm atIndex:0];
            
            if (self.spms.count > 3) {
                [self.spms removeLastObject];
            }
        }
    }
}

- (BOOL)openViewWithIdentifier:(NSString *)identifier
                  queryForInit:(NSDictionary *)queryForInit
{
    return [self openViewWithIdentifier:identifier queryForInit:queryForInit propertyDictionary:nil];
}

- (BOOL)openViewWithIdentifier:(NSString *)identifier
                  queryForInit:(NSDictionary *)queryForInit
            propertyDictionary:(NSDictionary *)propertyDic
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:queryForInit];
    LLViewDataModel *viewDataModel = [self viewDataModelForIdentifier:identifier];
    
    if (viewDataModel.type == ViewTypeH5) {
        for (NSString *tempKey in params.allKeys) {
            NSObject *object = [params objectForKey:tempKey];
            if ([object isKindOfClass:[BaseModel class]]) {
                [params removeObjectForKey:tempKey];
            }
        }
        NSString *url = [LLURLMap urlForViewWithIdentifier:identifier params:params];
        return openURL(url);
    } else if(viewDataModel.type == ViewTypeWeb) {

        // format url
        for (NSString *tempKey in params.allKeys) {
            NSObject *object = [params objectForKey:tempKey];
            if ([object isKindOfClass:[BaseModel class]]) {
                [params removeObjectForKey:tempKey];
            }
        }
        
        NSString *url = [LLURLMap urlForWebWithIdentifier:identifier params:params];

        return openURL(url);
    }
    
    NSString * retrospect               = [queryForInit objectForKey:APPURL_PARAM_RETROSPECT];
    NSString * animated                 = [queryForInit objectForKey:APPURL_PARAM_ANIMATED];
    
    NSMutableDictionary *newParams = [NSMutableDictionary dictionaryWithDictionary:queryForInit];
    
    
    
    [newParams setValue:identifier forKey:@"_identifier"];
    [newParams setValue:viewDataModel.desc forKey:@"_title"];
    
    BOOL shouldRetrospect               = retrospect ? [retrospect boolValue]:NO;
    BOOL shouldAnaimate                 = animated ? [animated boolValue] : YES;

    [self handleParams:params viewData:viewDataModel];
    
    [self gotoViewWithIdentifier:identifier
                    queryForInit:newParams
                queryForInstance:nil
              propertyDictionary:propertyDic
                      retrospect:shouldRetrospect
                        animated:shouldAnaimate];
    
    return YES;
}

- (UIViewController *)viewControllerWithIdentifier:(NSString *)identifier {
    LLViewDataModel * viewDataModel = [self viewDataModelForIdentifier:identifier];
    if (viewDataModel == nil) {
        return nil;
    }
    
    Class viewClass = viewDataModel.viewClass;
    if (viewClass && viewDataModel.type == ViewTypeNative) {
        
        SEL initMethod = [viewDataModel.viewInitMethod pointerValue];
        
        NSObject * object = nil;
        
        if (viewClass && initMethod) {
            NSMutableDictionary *params = nil;
            
            if (viewDataModel.webUrl) {
                params = [LLURLHelper getURLParamsWithURL:[NSURL URLWithString:viewDataModel.webUrl] defaultKey:viewDataModel.paramKey];
            }
            viewDataModel.queryForInitMethod = params;
            [viewDataModel.queryForInitMethod setValue:viewDataModel.identifier forKey:@"_identifier"];
            object               = [viewClass alloc];
            [self configObject:object withViewDataModel:viewDataModel propertyDict:nil shouldCallInitMethod:YES];
        } else {
            object = [[viewClass alloc] init];
        }

        if ([object respondsToSelector:@selector(setDesc:)]) {
            [object performSelector:@selector(setDesc:) withObject:viewDataModel.desc];
        }
        
        if (object && [object isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)object;
        }
        
    } else {

        NSString *fielUrlString = [LLURLMap fileUrlWithFilePath:viewDataModel.filePath];
        if (viewDataModel.type == ViewTypeWeb) {
            fielUrlString = viewDataModel.webUrl;
        }

        // 添加自定义参数
        NSDictionary *params = [LLURLHelper appendCustomerParamsWithOriginal:nil];
        fielUrlString = [fielUrlString stringByAppendingString:@"#!&"];
        fielUrlString = [fielUrlString stringByAppendingString:[params ssn_toQueryString]];
        
        NSMutableDictionary *query = [NSMutableDictionary dictionary];
        [query setValue:fielUrlString forKey:@"_url"];
        [query setValue:viewDataModel.desc forKey:@"_desc"];
        [query setValue:viewDataModel.identifier forKey:@"_identifier"];
        
        SFFWebViewController *viewController = [[SFFWebViewController alloc] initWithQuery:query];
        return viewController;
    }
    
    if (viewDataModel.role == ViewRoleLogin && !kAppDelegate.isLogin) {
        [kAppDelegate showLoginWithNavigationController:nil onComplete:^{
            
        }];
    }

    return nil;
}

- (BOOL)hasIdentifier:(NSString *)identifier
{
    LLViewDataModel * viewDataModel = [self viewDataModelForIdentifier:identifier];
    return viewDataModel != nil;
}

#pragma mark - jump
- (void)gotoViewWithIdentifier:(NSString *)identifier
                  queryForInit:(NSDictionary *)initParams
            propertyDictionary:(NSDictionary *)propertyDictionary{
    if (identifier) {
        [self gotoViewWithIdentifier:identifier
                        queryForInit:initParams
                    queryForInstance:nil
                  propertyDictionary:propertyDictionary
                          retrospect:NO
                            animated:YES];
    }
}

- (void)gotoViewWithIdentifier:(NSString *)identifier
                  queryForInit:(NSDictionary *)initParams
              queryForInstance:(NSDictionary *)instanceParams
            propertyDictionary:(NSDictionary *)propertyDictionary{
    if (identifier) {
        [self gotoViewWithIdentifier:identifier
                        queryForInit:initParams
                    queryForInstance:instanceParams
                  propertyDictionary:propertyDictionary
                          retrospect:NO
                            animated:YES];
    }
}

- (void)gotoViewWithIdentifier:(NSString *)identifier
                  queryForInit:(NSDictionary *)initParams
              queryForInstance:(NSDictionary *)instanceParams
            propertyDictionary:(NSDictionary *)propertyDictionary
                    retrospect:(BOOL)retrospect
                      animated:(BOOL)animated{
    if (identifier) {
        LLViewDataModel * viewDataModel     = [self viewDataModelForIdentifier:identifier];
        viewDataModel.queryForInitMethod    = [NSMutableDictionary dictionaryWithDictionary:initParams];
        viewDataModel.viewInstanceMethod    = [NSValue valueWithPointer:@selector(doInitializeWithQuery:)];
        viewDataModel.queryForInstanceMethod= [NSMutableDictionary dictionaryWithDictionary:instanceParams];
        
        [self pushViewControllerWithViewDataModel:viewDataModel propertyDict:propertyDictionary retrospect:retrospect animated:animated];
    }
}

#pragma mark - perform
- (void)processService:(SEL)selector params:(NSDictionary *)params{
    if (!selector) {
        return;
    }
    
    if (self.topViewController && [self.topViewController respondsToSelector:selector]) {
        SuppressPerformSelectorLeakWarning(
           [self.topViewController performSelector:selector withObject:params];
        );
    } else if (self.rootViewController && [self.rootViewController respondsToSelector:selector]) {
        SuppressPerformSelectorLeakWarning(
           [self.rootViewController performSelector:selector withObject:params];
        );
    } else if ([self respondsToSelector:selector]) {
        SuppressPerformSelectorLeakWarning(
           [self performSelector:selector withObject:params];
        );
    }
}

@end
