//
//  LLBaseNavigator.m
//  LiuLianLib
//
//  Created by BlackDev on 12/16/14.
//  Copyright (c) 2014 SF. All rights reserved.
//

#import "LLBaseNavigator.h"
#import "NSObject+Category.h"
#import "SFAppConfigBiz.h"
#import "NSObject+SFGCD.h"
#import "NSFileManager+SSN.h"
#import "SFHybirdManager.h"
#import "SSNSafeDictionary.h"
#import "NSThread+SSN.h"
#import "FunctionSwitchManager.h"
#import "SFFWebViewController.h"

@interface LLBaseNavigator()

@property (nonatomic, strong) NSArray *whiteList;

@property (nonatomic, strong) NSArray *blackList;

@property (nonatomic, strong) NSArray *browseList;

@property (nonatomic,strong,readonly) NSMutableDictionary *viewModalMap;

//@property (nonatomic,strong) dispatch_queue_t open_url_queue;
@property (nonatomic) BOOL isReady;//view map 数据是否加载完成

@end

@implementation LLBaseNavigator

@synthesize viewModalDict           = _viewModalDict;
@synthesize window                  = _window;
@synthesize rootViewController      = _rootViewController;
@synthesize topViewController       = _topViewController;
@synthesize visibleViewController   = _visibleViewController;


#pragma mark - init
- (instancetype)init{
    if (self = [super init]) {
        _viewModalMap = [[NSMutableDictionary alloc] initWithCapacity:0];
        _isReady = NO;
        [self readViewControllerConfigurations];
        [self readWhiteListConfigurations];
        [self readBlackListConfigurations];
        [self readBrowseListConfigurations];
    }
    
    return self;
}

- (NSDictionary *)viewModalDict {
    return [_viewModalMap copy];
}

#pragma mark - functions
- (NSDictionary *)readViewMapWithPath:(NSString *)path {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    @autoreleasepool {
        NSArray * viewMaps = [NSArray arrayWithContentsOfFile:path];
        
        if (viewMaps && viewMaps.count) {
            for (NSDictionary * viewMap in viewMaps) {
                NSString * className  = [viewMap objectForKey:@"className"];
                NSString * identifier = [viewMap objectForKey:@"identifier"];
                NSString * webUrl     = [viewMap objectForKey:@"webUrl"];
                NSString * filePath   = [viewMap objectForKey:@"filePath"];
                ViewType   type       = [[viewMap objectForKey:@"type"] integerValue];
                NSString * desc       = [viewMap objectForKey:@"description"];
                ViewRole role         = [[viewMap objectForKey:@"role"] integerValue];
                NSString *inTab       = [viewMap objectForKey:@"intab"];
                BOOL useCache        = [[viewMap objectForKey:@"cache"] boolValue];

                if (identifier && identifier.length) {
                    Class viewClass = nil;
                    //防止线上下发viewmap存在SFWebViewController重名类
                    if ([className isEqualToString:@"SFWebViewController"]) {
                        className = @"SFFWebViewController";
                    }
                    if (className) viewClass = NSClassFromString(className);
                    
                    // LLNavigatorProtocol协议规范的方法
                    SEL initMethod    = @selector(initWithQuery:);
                    SEL instanceMethod= @selector(doInitializeWithQuery:);
                    
                    // 创建viewcontroller配置对象
                    LLViewDataModel * viewDataModel = [[LLViewDataModel alloc] init];
                    viewDataModel.viewClass         = viewClass;
                    viewDataModel.viewInitMethod    = [NSValue valueWithPointer:initMethod];
                    viewDataModel.viewInstanceMethod= [NSValue valueWithPointer:instanceMethod];
                    viewDataModel.webUrl            = webUrl;
                    viewDataModel.filePath          = filePath;
                    viewDataModel.type              = type;
                    viewDataModel.desc              = desc ? desc : identifier;
                    viewDataModel.role              = role;
                    viewDataModel.identifier        = identifier;
                    viewDataModel.inTab             = inTab;
                    
                    if ([[viewMap objectForKey:@"cache"] boolValue]) {
                    viewDataModel.useCache          = useCache;    
                    }
                    viewDataModel.useCache          = useCache;
                    
                    // 扣取url中的参数
                    NSRange startRange = [webUrl rangeOfString:@"{"];
                    NSRange endRange = [webUrl rangeOfString:@"}"];
                    if (startRange.length > 0 && endRange.length > 0) {
                        NSString *param = [webUrl substringWithRange:NSMakeRange(startRange.location, endRange.location - startRange.location + 1)];
                        viewDataModel.webUrl = [viewDataModel.webUrl stringByReplacingOccurrencesOfString:param withString:@"%@"];
                        
                        param = [param stringByReplacingOccurrencesOfString:@"{" withString:@""];
                        param = [param stringByReplacingOccurrencesOfString:@"}" withString:@""];
                        
                        viewDataModel.paramKey = param;
                    }

                    if (viewDataModel.paramKey == nil && ([viewDataModel.identifier hasPrefix:@"activity"] || [@"y" isEqualToString:viewDataModel.identifier])) {
                        viewDataModel.paramKey = @"activityId";
                    }
                    
                    [dic setObject:viewDataModel forKey:identifier];
                }
            }
        }
    }
    
    return dic;
}

// 读取配置文件
- (void)readViewControllerConfigurations
{
    NSString * viewMapPath = [[NSBundle mainBundle] pathForResource:@"viewmap" ofType:@"plist"];
    NSString * tempPath = [PATH_OF_HYBIRD stringByAppendingPathComponent:@"viewmap.plist"];
    
    NSFileManager *fileManager = [NSFileManager ssn_fileManager];
    if ([SFHybirdManager defaultManager].isRemoteH5 && [SFHybirdManager defaultManager].isH5Inited && [fileManager fileExistsAtPath:tempPath]) {
        viewMapPath = tempPath;
    }
    
    NSDictionary *maps = [self readViewMapWithPath:viewMapPath];
    
    if ([maps count]) {
        [self.viewModalMap setDictionary:maps];
    }
    
    _isReady = YES;
}

/**
 *  重新读取viewmap
 */
- (void)rereadViewControllerConfigurations {
    [self readViewControllerConfigurations];
}

- (void)readWhiteListConfigurations
{
    NSDictionary *subinfos = [[FunctionSwitchManager sharedInstance] getFunctionSubInfoWithIdentifier:@"whitelist"];
    self.whiteList = [subinfos objectForKey:@"items"];
}

- (void)readBrowseListConfigurations
{
    NSDictionary *subinfos = [[FunctionSwitchManager sharedInstance] getFunctionSubInfoWithIdentifier:@"whitelist"];
    self.browseList = [subinfos objectForKey:@"browselist"];
}

- (void)readBlackListConfigurations
{
    NSDictionary *subinfos = [[FunctionSwitchManager sharedInstance] getFunctionSubInfoWithIdentifier:@"whitelist"];
    self.blackList = [subinfos objectForKey:@"blacklist"];

}

- (BOOL)isURLInWhiteList:(NSString *)url
{
    BOOL exits           = NO;
    BOOL enableWhiteList = [[FunctionSwitchManager sharedInstance] checkFunctionEnableWithIdentifier:@"whitelist"];
    
    if (enableWhiteList) {
        NSURL *URL = [NSURL URLWithString:url];
        NSString *hostString = [NSString stringWithFormat:@"%@://%@", URL.scheme, URL.host];
        if ([self.whiteList containsObject:hostString]) {
            exits = YES;
        }
    } else {
        exits = YES;
    }
    
    return exits;
}

- (BOOL)isURLInBlackList:(NSString *)url
{
    BOOL exits           = NO;
    BOOL enableWhiteList = [[FunctionSwitchManager sharedInstance] checkFunctionEnableWithIdentifier:@"whitelist"];
    
    if (enableWhiteList) {
        NSURL *URL = [NSURL URLWithString:url];

        for (NSString *blackUrl in self.blackList) {
            NSURL *blackU = [NSURL URLWithString:blackUrl];
            
            if ([blackU.host hasPrefix:@"*"]) {
                NSArray *subHosts = [URL.host componentsSeparatedByString:@"."];
                NSArray *blackSubHosts = [blackU.host componentsSeparatedByString:@"."];
                
                if (subHosts.count == blackSubHosts.count) {
                    BOOL same = YES;
                    for (NSInteger index = 0; index < subHosts.count; index++) {
                        NSString *black = [blackSubHosts objectAtIndex:index];
                        NSString *sub = [subHosts objectAtIndex:index];
                        
                        if (![black isEqualToString:@"*"] && ![black isEqualToString:sub]) {
                            same = NO;
                            break;
                        }
                    }
                    
                    if (same) {
                        exits = YES;
                        break;
                    }
                }
                
            } else if ([URL.host isEqualToString:blackU.host]) {
                exits = YES;
                break;
            }
        }
    } else {
        exits = NO;
    }
    
    return exits;
}

- (BOOL)isURLInBrowseList:(NSString *)url
{
    BOOL exits           = NO;
    BOOL enableWhiteList = [[FunctionSwitchManager sharedInstance] checkFunctionEnableWithIdentifier:@"whitelist"];
    
    if (enableWhiteList) {
        NSURL *URL = [NSURL URLWithString:url];
        NSString *hostString = [NSString stringWithFormat:@"%@://%@", URL.scheme, URL.host];
        if ([self.browseList containsObject:hostString]) {
            exits = YES;
        }
    } else {
        exits = YES;
    }
    
    return exits;
}

- (id)checkIfViewClassExists:(Class)viewClass inStack:(NSArray *)stack
{
    id controller           = nil;
    
    if (stack && viewClass) {
        for (NSUInteger i = 0; i < stack.count; i++) {
            id object       = [stack objectAtIndex:i];
            
            if ([object isKindOfClass:viewClass]) {
                controller   = object;
            }
        }
    }
    
    return controller;
}

- (id)checkIfViewClassExistsWithIdentifier:(NSString *)identifier inStack:(NSArray *)stack{
    id controller = nil;
    
    if (stack && identifier) {
        for (NSUInteger i = 0; i < stack.count; i++) {
            id object = [stack objectAtIndex:i];
            
            if ([object isKindOfClass:[CDVWebViewController class]]) {
                CDVWebViewController *tempVC = (CDVWebViewController *)object;
                if ([tempVC.identifier isEqualToString:identifier]) {
                    controller = object;
                }
            } else if ([object isKindOfClass:[SFFWebViewController class]]) {
                SFFWebViewController *tempVC = (SFFWebViewController *)object;
                if ([tempVC.identifier isEqualToString:identifier]) {
                    controller = object;
                }
            }
        }
    }
    
    return controller;
}

- (NSArray *)navigationStack
{
    NSArray * stack             = nil;
    
    if (self.rootViewController && [self.rootViewController isKindOfClass:[UINavigationController class]]) {
        stack                   = [(UINavigationController *)self.rootViewController viewControllers];
    }
    
    return stack;
}

#pragma mark - jump
- (UIViewController *)pushViewControllerWithViewDataModel:(LLViewDataModel *)viewDataModel propertyDict:(NSDictionary *)propertyDict animated:(BOOL)animated{
    UIViewController * controller           = nil;
    
    if (viewDataModel) {
        // 获取相关参数
        Class       viewClass               = viewDataModel.viewClass;
        SEL         initMethod              = [viewDataModel.viewInitMethod pointerValue];
        
        NSObject * object                   = nil;
        
        if (viewClass && initMethod) {

            if (viewDataModel.useCache && viewDataModel.cachedController) {
                // 支持缓存的情况， 用缓存的viewcontroller（Nativie的情况）
                object = viewDataModel.cachedController;
            } else {
                BOOL userCache = [[viewDataModel.queryForInitMethod objectForKey:@"_useCache"] boolValue];
                NSString* identifier = [viewDataModel.queryForInitMethod objectForKey:@"_identifier"];
                LLViewDataModel *oldViewData = [self viewDataModelForIdentifier:identifier];
                
                if (userCache && oldViewData && oldViewData.useCache && oldViewData.cachedController) {
                    // 走线上的情况， 看viewmap中的定义是否支持缓存
                    object = oldViewData.cachedController;
                } else {
                    object                          = [viewClass alloc];
                    // 配置object
                    [self configObject:object withViewDataModel:viewDataModel propertyDict:propertyDict shouldCallInitMethod:YES];
                    
                    if (oldViewData.useCache) {
                        oldViewData.cachedController = object;
                    } else if (viewDataModel.useCache) {
                        viewDataModel.cachedController = object;
                    }
                }
            }

            // 跳转
            if ([object isKindOfClass:[UIViewController class]]) {
                controller                  = (UIViewController *)object;
                
                [self pushViewController:controller animated:animated];
            }
        }
    }
    
    return controller;
}

- (UIViewController *)pushViewControllerWithViewDataModel:(LLViewDataModel *)viewDataModel
                                             propertyDict:(NSDictionary *)propertyDict
                                               retrospect:(BOOL)retrospect
                                                 animated:(BOOL)animated{
    UIViewController * controller = nil;
    
    // 不回溯，直接push一个新的viewcontroller
    if (!retrospect) {
        controller = [self pushViewControllerWithViewDataModel:viewDataModel propertyDict:propertyDict animated:animated];
        
        return controller;
    }
    
    if (viewDataModel) {
        // viewcontroller相关参数
        Class viewClass = viewDataModel.viewClass;
        
        // 检查是否在导航堆栈中已经存在此类的viewcontroller
        if ([viewClass isKindOfClass:[CDVWebViewController class]]
            || viewDataModel.type == ViewTypeH5
            || viewDataModel.type == ViewTypeWeb) {
            controller = [self checkIfViewClassExistsWithIdentifier:viewDataModel.identifier inStack:[self navigationStack]];
        } else {
            controller = [self checkIfViewClassExists:viewClass inStack:[self navigationStack]];
        }
        
        if (controller) {
            // 导航堆栈中存在这个类型的controller,那么跳转到这个controller
            // 配置controller
            [self configObject:controller withViewDataModel:viewDataModel propertyDict:propertyDict shouldCallInitMethod:NO];
            
            // 跳转
            [self popToViewController:controller animated:animated];
            
            return controller;
        }else{
            // 导航堆栈中不存在这个类型的controller,那么跳转到新的controller
            [self pushViewControllerWithViewDataModel:viewDataModel propertyDict:propertyDict animated:animated];
        }
    }
    
    return controller;
}

- (BOOL)canPopToIdentifier:(NSString *)identifier
{
    LLViewDataModel * viewDataModel = [self viewDataModelForIdentifier:identifier];
    
    BOOL result = NO;
    if (viewDataModel) {
        Class viewClass = viewDataModel.viewClass;
        if ([viewClass isKindOfClass:[CDVWebViewController class]]
            || viewDataModel.type == ViewTypeH5
            || viewDataModel.type == ViewTypeWeb) {
            
            UIViewController *controller = [self checkIfViewClassExistsWithIdentifier:viewDataModel.identifier inStack:[self navigationStack]];
            result = controller != nil;
        } else {
            UIViewController *controller = [self checkIfViewClassExists:viewClass inStack:[self navigationStack]];
            result = controller != nil;
        }
    }
    
    return result;
}

#pragma mark - basic navigation
- (void)popToViewController:(UIViewController *)controller animated:(BOOL)animated{
    if (self.rootViewController && [self.rootViewController isKindOfClass:[UINavigationController class]]) {
        if (controller && [controller isKindOfClass:[UIViewController class]] && [[(UINavigationController *)self.rootViewController viewControllers] containsObject:controller]) {
            [(UINavigationController *)self.rootViewController popToViewController:controller animated:animated];
        }
    }
}

- (void)pushViewController:(UIViewController *)controller animated:(BOOL)animated{
    if (self.rootViewController && [self.rootViewController isKindOfClass:[UINavigationController class]]) {
        if (controller && [controller isKindOfClass:[UIViewController class]]) {
            [(UINavigationController *)self.rootViewController pushViewController:controller animated:animated];
        }
    }
}

#pragma mark - config
- (void)configObject:(NSObject *)object withViewDataModel:(LLViewDataModel *)viewDataModel propertyDict:(NSDictionary *)propertyDict shouldCallInitMethod:(BOOL)shouldCallInitMethod{
    if (viewDataModel && object) {
        // 获取相关参数
        Class       viewClass               = viewDataModel.viewClass;
        SEL         initMethod              = [viewDataModel.viewInitMethod pointerValue];
        SEL         instanceMethod          = [viewDataModel.viewInstanceMethod pointerValue];
        NSDictionary * queryForInitM        = viewDataModel.queryForInitMethod;
        NSDictionary * queryForInstanceM    = viewDataModel.queryForInstanceMethod;
        
        //queryForInitM                       = queryForInitM == nil ? [NSDictionary dictionary] : queryForInitM;
        //queryForInstanceM                   = queryForInstanceM == nil ? [NSDictionary dictionary] : queryForInstanceM;
        
        
        if (viewClass && initMethod) {
            // 初始化
            if ([object respondsToSelector:initMethod] && shouldCallInitMethod) {
                object = [(id<LLNavigatorProtocol>) object initWithQuery:queryForInitM];
            }
            // 属性
            if (propertyDict) {
                for (NSString * key in propertyDict.allKeys) {
                    id value                = [propertyDict objectForKey:key];
                    SEL getMethod           = NSSelectorFromString(key);
                    if ([object respondsToSelector:getMethod]) {
                        [object setValue:value forKey:key];
                    }
                }
            }
            // 实例方法
            if ([object respondsToSelector:instanceMethod]) {
                NSArray * params            = nil;
                if (queryForInstanceM) {
                    params                  = @[queryForInstanceM];
                }
                [object performSelector:instanceMethod withObjects:params];
            }
            
            if ([object respondsToSelector:@selector(setDesc:)]) {
                [object performSelector:@selector(setDesc:) withObject:viewDataModel.desc];
            }
        }
    }
}

#pragma mark - setter/getter
- (UIWindow *)window {
    if (_window == nil) {
        UIWindow * keyWindow    = [UIApplication sharedApplication].delegate.window;
        if (!keyWindow) {
            keyWindow           = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            keyWindow.backgroundColor = [UIColor whiteColor];
            
            [keyWindow makeKeyAndVisible];
        }
        
        self.window             = keyWindow;
    }
    
    return _window;
}


- (void)setupRootViewController:(UIViewController *)rootViewController{
    self.rootViewController         = rootViewController;
    self.window.rootViewController  = self.rootViewController;
}

- (LLViewDataModel *)viewDataModelForIdentifier:(NSString *)identifier{
    LLViewDataModel * viewDataModel         = nil;
    
    if ([NSString sf_isBlankString:identifier]) {
        return nil;
    }
    
    viewDataModel                           = [_viewModalMap objectForKey:identifier];
    
    return viewDataModel;
}

- (UIViewController *)topViewController{
    UIViewController * controller   = nil;
    
    if (self.rootViewController && [self.rootViewController isKindOfClass:[UINavigationController class]]) {
        //非arc下面，获取到此对象后需要将对象hold住，否则扔出去的肯能是个野指针
        controller  = [(UINavigationController *)self.rootViewController topViewController];
    }
    
    return controller;
}

- (UIViewController *)visibleViewController{
    UIViewController * controller   = nil;
    
    if (self.rootViewController && [self.rootViewController isKindOfClass:[UINavigationController class]]) {
        controller = [(UINavigationController *)self.rootViewController visibleViewController];
    }
    
    return controller;
}

@end


@implementation LLBaseNavigator (LLViewController)

- (void)viewExit:(NSDictionary *)query{
    if ([self.rootViewController isKindOfClass:[UINavigationController class]]) {
        BOOL animated = YES;
        if (query) {
            NSString * animatedString   = [query objectForKey:APPURL_PARAM_ANIMATED];
            if (animatedString) {
                animated                = [animatedString boolValue];
            }
        }
        [(UINavigationController *)self.rootViewController popViewControllerAnimated:animated];
    }
}

- (void)popToRoot:(NSDictionary *)query{
    if ([self.rootViewController isKindOfClass:[UINavigationController class]]) {
        BOOL animated = YES;
        if (query) {
            NSString * animatedString   = [query objectForKey:APPURL_PARAM_ANIMATED];
            if (animatedString) {
                animated                = [animatedString boolValue];
            }
        }
        [(UINavigationController *)self.rootViewController popToRootViewControllerAnimated:animated];
    }
}

@end