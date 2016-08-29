//
//  SecretMD5.m
//  LivePlayer
//
//  Created by 韩乾坤 on 16/5/10.
//  Copyright © 2016年 lim. All rights reserved.
//

#import "SecretMD5.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation SecretMD5
+ (NSString *)md5HexDigest:(NSString*)input
{
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}
@end
