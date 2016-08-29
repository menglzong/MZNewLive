//
//  NetworkManager.m
//  LivePlayer
//
//  Created by 韩乾坤 on 16/5/9.
//  Copyright © 2016年 lim. All rights reserved.
//

#import "LiveNetworkManager.h"
#import <AFNetworking/AFNetworking.h>
#import "ShowAlertViewManager.h"

@interface LiveNetworkManager ()

@property (strong, nonatomic) ShowAlertViewManager *showAlertManager;

@end
static LiveNetworkManager *_liveNetworkManager;
@implementation LiveNetworkManager

+(instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _liveNetworkManager=[[LiveNetworkManager alloc]init];
    });
    return _liveNetworkManager;
}

- (void)POST:(RequestAction)action
      params:(NSDictionary *)paramDic
     success:(void (^)(NSDictionary *reponseObject))success
     failure:(void (^)(NSError *error))failure{
    
    ParamManager *paramMg = [[ParamManager alloc] init];
    NSString *secretParam = [paramMg encodeRequestParams:paramDic withRequestAction:action];
    
    NSString *urlStr = [BasicURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString * (^AFQueryStringSerializationBlock)(NSURLRequest *, id, NSError *__autoreleasing *) = ^(NSURLRequest *request, id parameters, NSError *__autoreleasing *error){
        return parameters;
    };
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer = [AFHTTPRequestSerializer serializer];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    Ivar var = class_getInstanceVariable([AFHTTPRequestSerializer class],"_queryStringSerialization");
    object_setIvar(session.requestSerializer, var, AFQueryStringSerializationBlock);
    
    [session POST:urlStr parameters:secretParam progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error;
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
        if (!_showAlertManager) {
            _showAlertManager = [[ShowAlertViewManager alloc] init];
        }
        if (error && failure) {
            failure(error);
        }
        else if(error == nil) {
            if ([responseDic[@"IsSingle"] integerValue]== 1) {
                [_showAlertManager showAlertView];
            }
            success(responseDic);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            failure(error);
        }
    }];
}

- (void)POSTForData:(RequestAction)action
      params:(NSDictionary *)paramDic
     success:(void (^)(id reponseObject))success
     failure:(void (^)(NSError *error))failure{
    
    ParamManager *paramMg = [[ParamManager alloc] init];
    NSString *secretParam = [paramMg encodeRequestParams:paramDic withRequestAction:action];
    
    NSString *urlStr = [BasicURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString * (^AFQueryStringSerializationBlock)(NSURLRequest *, id, NSError *__autoreleasing *) = ^(NSURLRequest *request, id parameters, NSError *__autoreleasing *error){
        return parameters;
    };
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer = [AFHTTPRequestSerializer serializer];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    Ivar var = class_getInstanceVariable([AFHTTPRequestSerializer class],"_queryStringSerialization");
    object_setIvar(session.requestSerializer, var, AFQueryStringSerializationBlock);
    
    [session POST:urlStr parameters:secretParam progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error;
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
        NSInteger responseCode = [responseDic[@"ReturnCode"] integerValue];
        if (!_showAlertManager) {
            _showAlertManager = [[ShowAlertViewManager alloc] init];
        }
        switch (responseCode) {
            case 0:
            {
                if(error == nil && success){
                    if ([responseDic[@"IsSingle"] integerValue]== 1) {
                        [_showAlertManager showAlertView];
                    }
                    success(responseDic[@"Data"]);
                }
            }
                break;
            default:
            {
                if (error && failure) {
                    failure(error);
                }
            }
                break;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            failure(error);
        }
    }];
}



@end
