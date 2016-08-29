//
//  LiveNetworkManager+UploadImg.h
//  GuoGuoLiveDev
//
//  Created by 韩乾坤 on 16/5/16.
//  Copyright © 2016年 统领得一网络科技（上海）有限公司. All rights reserved.
//

@interface UploadImageNetwork:NSObject

+(instancetype)shareInstance;
- (void)uploadImg:(NSData *)imgData
         fileName:(NSString *)fileName
          success:(void (^)(NSString *reponseObject))success
          failure:(void (^)(NSError *error))failure;
@end
