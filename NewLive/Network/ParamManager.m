//
//  ParamManager.m
//  LivePlayer
//
//  Created by 韩乾坤 on 16/5/9.
//  Copyright © 2016年 lim. All rights reserved.
//

#import "ParamManager.h"
#import <UIKit/UIKit.h>
#import "Secret3DES.h"
#import "SecretMD5.h"


//‘&’全局参数连接符，‘_’业务参数连接符
#define GOLBAL_LINK_CHAR            @"&"
#define LOCAL_LINK_CHAR             @"_"

#define KEY_IMEI                    @"wImei"        //设备唯一标识符
#define KEY_AGENT                   @"wAgent"       //商户ID
#define KEY_SYSTEM                  @"wSystem"      //系统
#define KEY_MODEL                   @"wModels"      //平台
#define KEY_PARAM                   @"wParam"       //业务参数
#define KEY_ACTION                  @"wAction"      //业务接口编号
#define KEY_MSGID                   @"wMsgID"       //戳（建议使用时间戳）
#define KEY_SIGN                    @"wSign"        //根据参数生成的MD5（商户编号 + 业务接口编号 + 时间戳 + 加密后的参数 + 客户端MD5Key)
#define KEY_RequestUserId           @"wRequestUserID"//userid
#define KEY_Version                 @"wVersion"      //版本号


@implementation ParamManager

- (NSString *)encodeRequestParams:(NSString *)paramsStr{
    return [Secret3DES TripleDES:paramsStr encryptOrDecrypt:kCCEncrypt];
}

- (NSDictionary *)decodeResponseParams:(NSData *)params{
    return nil;
}

- (NSString *)encodeRequestParams:(NSDictionary *)param withRequestAction:(RequestAction)action{
    //把参数转化为参数=数据 _ 的方式
    NSString *localParamStr = [self localParam:param];
                                                                                                               
    //对业务参数进行3DES加密
    localParamStr = [self encodeRequestParams:localParamStr];
    //加密后的参数进行字符串替换
    localParamStr = [localParamStr stringByReplacingOccurrencesOfString:@"/" withString:@"^"];
    localParamStr = [localParamStr stringByReplacingOccurrencesOfString:@"+" withString:@"*"];
    localParamStr = [localParamStr stringByReplacingOccurrencesOfString:@"=" withString:@"-"];
    
    //根据现有参数，获取通用参数（MD5加密用来验证参数的正确性）
   
    NSString *golbalParamStr = [self golbalParam:action localParam:localParamStr];
    return golbalParamStr;
}

- (NSString *)localParam:(NSDictionary *)reqParam{
    //将数据格式化为参数=数据 _ 的方式
    return [self formatterParams:reqParam linkChar:LOCAL_LINK_CHAR];
}

- (NSString *)golbalParam:(RequestAction)action localParam:(NSString *)localParam{
    //通用参数格式为参数=数据&的形式
    NSMutableDictionary *globalParam = @{ KEY_IMEI  : [self deviceUDID],
                                          KEY_SYSTEM: [self deviceSystem],
                                          KEY_MODEL : [self deviceModel],
                                          KEY_RequestUserId : [self requestUserId],
                                          KEY_PARAM : localParam,
                                          KEY_MSGID : [self netTime],
                                          KEY_AGENT : AGENT,
                                          KEY_ACTION: @(action),
                                          KEY_Version : [self appVersion],
                                          }.mutableCopy;
    //生成MD5验证戳
    NSString *strForMD5 = [self makeParamStrForMD5:globalParam];
    NSString *md5Str = [SecretMD5 md5HexDigest:strForMD5];
    
    //添加生成的MD5秘钥
    [globalParam setObject:md5Str forKey:KEY_SIGN];
    
    return [self formatterParams:globalParam linkChar:GOLBAL_LINK_CHAR];
}

//拼接参数，用于生成MD5Key
- (NSString *)makeParamStrForMD5:(NSDictionary *)paramDic{
     return [NSString stringWithFormat:@"%@%@%@%@%@",paramDic[KEY_AGENT],paramDic[KEY_ACTION],paramDic[KEY_MSGID],paramDic[KEY_PARAM],MD5KEY];
}

//格式化参数
- (NSString *)formatterParams:(NSDictionary *)paramDic linkChar:(NSString *)linkChar{
    __block NSString *paramStr = @"";
    [paramDic.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *key = [obj toNSString];
        NSString *value = [[paramDic objectForKey:key] toNSString];
        NSString *linkCharTmp = paramStr.length ? [linkChar toNSString]: @"";
        paramStr = [NSString stringWithFormat:@"%@%@%@=%@",paramStr,linkCharTmp,key,value];
    }];
    return paramStr;
}

//时间戳
- (NSString *)netTime{
    //获取网络时间
    CGFloat timeInterval = [[NSDate date] timeIntervalSinceReferenceDate];
    return [NSString stringWithFormat:@"%f",timeInterval];
}

- (NSString *)deviceModel{
    UIDevice *device = [UIDevice currentDevice];
    return [NSString stringWithFormat:@"%@-%@-%@",device.model,device.systemName,device.systemVersion];
}

- (NSString *)deviceSystem{
    return [UIDevice currentDevice].systemName;
}

- (NSString *)deviceUDID{
    NSString *deviceUDID = [[UIDevice currentDevice] identifierForVendor].UUIDString;
    NSString *md5Str = [SecretMD5 md5HexDigest:deviceUDID];
    UserInfoManager *uManager = [UserInfoManager defaultManager];
    [uManager setDeviceUUID:md5Str];
    return md5Str;
}

- (NSString *)requestUserId {
    NSString *userId = [NSString stringWithFormat:@"%ld",[[UserInfoManager defaultManager] getUserID]];
    return [UserInfoTools checkLoginState] ? userId : @"0";
}

- (NSString *)appVersion {
    return [NSString stringWithFormat:@"%@(%@)",[DeviceTools getAppVersion],[DeviceTools getAppBuildCode]];
}

@end
