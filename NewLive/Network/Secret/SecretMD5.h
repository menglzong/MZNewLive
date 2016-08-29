//
//  SecretMD5.h
//  LivePlayer
//
//  Created by 韩乾坤 on 16/5/10.
//  Copyright © 2016年 lim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SecretMD5 : NSObject
+ (NSString *)md5HexDigest:(NSString*)input;
@end
