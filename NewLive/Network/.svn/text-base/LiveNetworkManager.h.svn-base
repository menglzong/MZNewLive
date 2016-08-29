//
//  NetworkManager.h
//  LivePlayer
//
//  Created by 韩乾坤 on 16/5/9.
//  Copyright © 2016年 lim. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <AFNetworking/AFNetworking.h>
#import "ParamManager.h"

@interface LiveNetworkManager : NSObject

+(instancetype)shareInstance;

- (void)POST:(RequestAction)action
      params:(NSDictionary *)paramDic
     success:(void (^)(NSDictionary *reponseObject))success
     failure:(void (^)(NSError *error))failure;

- (void)POSTForData:(RequestAction)action
             params:(NSDictionary *)paramDic
            success:(void (^)(id reponseObject))success
            failure:(void (^)(NSError *error))failure;

@end
