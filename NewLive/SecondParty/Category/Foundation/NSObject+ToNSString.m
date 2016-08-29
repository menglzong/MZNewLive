//
//  NSObject+ToNSString.m
//  Bank94Pro
//
//  Created by Tongling on 15/7/27.
//  Copyright (c) 2015年 &#32479;&#39046;&#24471;&#19968;&#32593;&#32476;&#31185;&#25216;&#65288;&#19978;&#28023;&#65289;&#26377;&#38480;&#20844;&#21496;. All rights reserved.
//

#import "NSObject+ToNSString.h"

@implementation NSObject (ToNSString)
- (NSString *)toNSString{
    if ([self isKindOfClass:[NSNull class]]) {
        return @"";
    }
    return [NSString stringWithFormat:@"%@",self];
}
@end
