//
//  MacrosTools.h
//  IntelligentWallet
//
//  Created by 统领 on 16/1/11.
//  Copyright © 2016年 HongZheJinRong. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "SecretMD5.h"
#import "UIRateAdaptive.h"
#pragma mark - 通用宏
#ifdef DEBUG
#define CLog(format, ...)  NSLog(format, ## __VA_ARGS__)
#else
#define CLog(format,...)
#endif

#define RainColor(x,y,z)   [UIColor colorWithRed:(x)/255.0 green:(y)/255.0 blue:(z)/255.0 alpha:1.0]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define SeacrchBarWidth    SCREEN_WIDTH > 320 ? 250 : 200
#define AlertViewWidth     SCREEN_WIDTH > 320 ? 250 : 200
#define AlertViewHeight    200

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#define RGB(r,g,b)  RainColor(r,g,b)

#define ScreenWidth  SCREEN_WIDTH

#define TabbarHeight                                        49
#define NavgationHeight                                     64

#define ContributeTitle                                     @"N币贡献榜"
//热线电话
#define SAFEGUARD_PHONE_NUMBER                              @"400-650-6833"
//友盟AppKey
#define UMengAppKey                                         @"5768e71a67e58e7be30009b8"
//设置昵称的固定替换字符串
#define UseThisEncrypedReplace_                             @"NewBroadcast"
//替换字符串的加密方法
#define AferEncryptionReplace_                              [SecretMD5 md5HexDigest:UseThisEncrypedReplace_]
//设备固定参数
#define DEVICE_DEVICE_ID                                    @"DeviceID"//设备编号
#define DEVICE_DEVICE_TYPE                                  @"DeviceType"//设备类型1安卓，2苹果
#define DEVICE_APPVERSION                                   @"AppVersion"//应用build版本号
#define DEVICE_DEVICE_INFO                                  @"DeviceInfo"//设备型号
#define YUNXINAPPLEKEY                                      @"feb295676e3da56aabdc40b2d49015eb" //云信appkey
#define YXIMManager                                         [IMManager shareInstance]

//判断设备型号
#define UI_IS_LANDSCAPE         ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft || [UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight)
#define UI_IS_IPAD              ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define UI_IS_IPHONE            ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define UI_IS_IPHONE4           (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height < 568.0)
#define UI_IS_IPHONE5           (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0)
#define UI_IS_IPHONE6           (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0)
#define UI_IS_IPHONE6PLUS       (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 736.0 || [[UIScreen mainScreen] bounds].size.width == 736.0) // Both orientations
#define UI_IS_IOS8_AND_HIGHER   ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)

#define UI_RATE_WIDTH           [UIRateAdaptive WidthRateUIWith750Design]
#define UI_RATE_HEIGHT          [UIRateAdaptive HeightRateUIWith750Design]

typedef NS_ENUM(NSInteger, LoginStyle) {
    LoginStyle_QQ = 0,
    LoginStyle_WeChat,
    LoginStyle_Sina,
    LoginStyle_Mobile,
};

//设置Jpush别名Key
#define SetJPushAlias           @"SetJPushAlias"
//设置JPush自定消息通知名
#define ReciveJPUSHCustomMessageNotification  @"reciveJPUSHCustomNotification"
