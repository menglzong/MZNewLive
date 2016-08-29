//
//  BaseModel.m
//  LiuLian
//
//  Created by Liubin on 14/12/9.
//  Copyright (c) 2014年 MacBook Air. All rights reserved.
//

#import "BaseModel.h"
#import <objc/runtime.h>

typedef NS_ENUM(int, kJSONModelErrorTypes)
{
    kBaseModelErrorInvalidData = 1,
    kBaseModelErrorBadResponse = 2,
    kBaseModelErrorBadJSON = 3,
    kBaseModelErrorModelIsInvalid = 4,
    kBaseModelErrorNilInput = 5
};

NSString* const BaseModelErrorDomain = @"BaseModelErrorDomain";

@implementation BaseModel

/**
 * 功能描述: 根据字典实例化对象
 * 输入参数: dict 字典
 * 输出参数: N/A
 * 返 回 值: self
 */
-(id)initWithDictionary:(NSDictionary*)dict
{
    self = [self init];
    if (self)
    {
        if (dict && [dict isKindOfClass:[NSDictionary class]])
        {
            [self setPropertyWithDictionary:dict];
        }
    }
    return self;
}

/**
 * 功能描述: 根据json字符串实例化对象
 * 输入参数: string json字符串
 * 输出参数: N/A
 * 返 回 值: self
 */
-(id)initWithJsonString:(NSString*)str
{
    self = [self init];
    if (self)
    {
        if (str && str.length > 0)
        {
            NSError* initError = nil;
            id obj = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding]
                                                     options:kNilOptions
                                                       error:&initError];
            if (!initError && obj)
            {
                [self setPropertyWithDictionary:obj];
            }
        }
    }
    return self;
}

/**
 * 功能描述: 根据其他对象实例化对象
 * 输入参数: object 输入对象
 * 输出参数: err 错误信息
 * 返 回 值: self
 */
-(id)initWithObject:(NSObject *)obj
{
    //instance
    self = [self init];
    if (self)
    {
        if (obj)
        {
            [self setPropertyWithObject:obj];
        }
    }
    return self;
}

/**
 * 功能描述: 设置属性值
 * 输入参数: object
 * 输出参数: N/A
 * 返 回 值: void
 */
-(void)setPropertyWithObject:(NSObject*)object
{
    @try {
        //当前对象属性列表
        unsigned int selfCount = 0;
        objc_property_t *selfPropertyList = class_copyPropertyList([self class],&selfCount);
        //传入对象属性列表
        unsigned int inputCount = 0;
        objc_property_t *inputPropertyList = class_copyPropertyList([object class], &inputCount);
        for(int i = 0; i < selfCount; i++)
        {
            objc_property_t currProperty = selfPropertyList[i];
            
            NSString *currPropertyName = [NSString stringWithFormat:@"%s", property_getName(currProperty)];
            SEL setterSel = [self getSetterSelWithAttibuteName:currPropertyName];
            if (![self respondsToSelector:setterSel])
                continue;
            for (NSUInteger j = 0; j < inputCount; j++)
            {
                objc_property_t inputProperty = inputPropertyList[j];
                NSString *inputPropertyName = [NSString stringWithFormat:@"%s", property_getName(inputProperty)];
                //转换大写对比属性名
                if ([[currPropertyName uppercaseString] isEqualToString:[inputPropertyName uppercaseString]])
                {
                    id value = [object valueForKey:inputPropertyName];
                    [self setProperty:value forKey:currPropertyName];
                    break;
                }
            }
        }
        free(selfPropertyList);
        free(inputPropertyList);
    }
    @catch (NSException *exception) {
        NSString *message = [NSString stringWithFormat:@"faild to initialize %@ object using setPropertyWithObject method", [self class]];
        self.error = [NSError errorWithDomain:BaseModelErrorDomain
                                            code:kBaseModelErrorInvalidData
                                        userInfo:@{NSLocalizedDescriptionKey:message}];
    }
    @finally {
        
    }
}

/**
 * 功能描述: 设置属性值
 * 输入参数: dataDic 字典
 * 输出参数: N/A
 * 返 回 值: void
 */
-(void)setPropertyWithDictionary:(NSDictionary*)attrMapDic
{
    @try {
        NSEnumerator *keyEnum = [attrMapDic keyEnumerator];
        id attributeName;
        while ((attributeName = [keyEnum nextObject])) {
            //当前对象属性列表
            unsigned int selfCount = 0;
            objc_property_t *selfPropertyList = class_copyPropertyList([self class],&selfCount);
            for(int i = 0; i < selfCount; i++)
            {
                objc_property_t currProperty = selfPropertyList[i];
                NSString *currPropertyName = [NSString stringWithFormat:@"%s", property_getName(currProperty)];
                //忽略只读属性
                SEL setterSel = [self getSetterSelWithAttibuteName:currPropertyName];
                if (![self respondsToSelector:setterSel])
                    continue;
                //判断属性名和属性类型是否一致
                if ([[currPropertyName uppercaseString] isEqualToString:[attributeName uppercaseString]]) {
                    id value = attrMapDic[attributeName];
                    [self setProperty:value forKey:currPropertyName];
                    break;
                }
            }
            free(selfPropertyList);
        }
    }
    @catch (NSException *exception) {
        NSString *message = [NSString stringWithFormat:@"faild to initialize %@ object using setPropertyWithDictionary method", [self class]];
        self.error = [NSError errorWithDomain:BaseModelErrorDomain
                                         code:kBaseModelErrorInvalidData
                                     userInfo:@{NSLocalizedDescriptionKey:message}];
    }
    @finally {
        
    }
}

- (void)setProperty:(id)value forKey:(NSString *)key
{
    SEL setterSel = [self getSetterSelWithAttibuteName:key];
    if ([self respondsToSelector:setterSel])
    {
        if (value && ![value isKindOfClass:[NSNull class]])
        {
            [self setValue:value forKey:key];
        }
        else
        {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self performSelector:setterSel withObject:nil];
#pragma clang diagnostic pop
        }
    }
}

/**
 * 功能描述: 获取set方法名
 * 输入参数: attributeName 属性名
 * 输出参数: N/A
 * 返 回 值: SEL
 */
-(SEL)getSetterSelWithAttibuteName:(NSString*)attributeName{
    NSString *capital = [[attributeName substringToIndex:1] uppercaseString];
    NSString *setterSelStr = [NSString stringWithFormat:@"set%@%@:",capital,[attributeName substringFromIndex:1]];
    return NSSelectorFromString(setterSelStr);
}

/**
 * 功能描述: 反序列化
 * 输入参数: decoder
 * 输出参数: N/A
 * 返 回 值: self
 */
- (id)initWithCoder:(NSCoder *)decoder{
    if( self = [super init] ){
        @try {
            unsigned int nCount = 0;
            objc_property_t *popertyList = class_copyPropertyList([self class],&nCount);
            for (NSUInteger i = 0; i < nCount; i++) {
                objc_property_t property = popertyList[i];
                NSString *currPropertyName = [NSString stringWithFormat:@"%s", property_getName(property)];
                SEL sel = [self getSetterSelWithAttibuteName:currPropertyName];
                if ([self respondsToSelector:sel]) {
                    id value = [decoder decodeObjectForKey:currPropertyName];
                    [self setProperty:value forKey:currPropertyName];
                }
            }
            free(popertyList);
        }
        @catch (NSException *exception) {
            NSString *message = [NSString stringWithFormat:@"faild to decoder %@ object using initWithCoder method", [self class]];
            self.error = [NSError errorWithDomain:BaseModelErrorDomain
                                             code:kBaseModelErrorInvalidData
                                         userInfo:@{NSLocalizedDescriptionKey:message}];
        }
        @finally {
            
        }
    }
    return self;
}

/**
 * 功能描述: 序列化对象
 * 输入参数: encoder
 * 输出参数: N/A
 * 返 回 值: N/A
 */
- (void)encodeWithCoder:(NSCoder *)encoder{
    @try {
        unsigned int nCount = 0;
        objc_property_t *propertyList = class_copyPropertyList([self class],&nCount);
        for (NSUInteger i = 0; i < nCount; i++) {
            objc_property_t property = propertyList[i];
            NSString *methodName = [NSString stringWithFormat:@"%s", property_getName(property)];
            SEL getSel = NSSelectorFromString(methodName);
            if ([self respondsToSelector:getSel]) {
                id valueObj = [self valueForKey:methodName];
                if (valueObj) {
                    [encoder encodeObject:valueObj forKey:methodName];
                }
            }
        }
        free(propertyList);
    }
    @catch (NSException *exception) {
        NSString *message = [NSString stringWithFormat:@"faild to encoder %@ object using encodeWithCoder method", [self class]];
        self.error = [NSError errorWithDomain:BaseModelErrorDomain
                                         code:kBaseModelErrorInvalidData
                                     userInfo:@{NSLocalizedDescriptionKey:message}];
    }
    @finally {
        
    }
}

- (id)copyWithZone:(NSZone *)zone
{
    id result = [[[self class] allocWithZone:zone] init];
    [result setPropertyWithObject:self];
    return result;
}

- (NSData*)getArchivedData
{
    return [NSKeyedArchiver archivedDataWithRootObject:self];
}

/**
 * 功能描述: 获取对象描述信息
 * 输入参数: N/A
 * 输出参数: N/A
 * 返 回 值: NSString
 */
- (NSString *)description
{
    NSMutableString *attrsDesc = [NSMutableString stringWithCapacity:100];
    unsigned int nCount = 0;
    objc_property_t *propertyList = class_copyPropertyList([self class],&nCount);
    for (NSUInteger i = 0; i < nCount; i++) {
        objc_property_t property = propertyList[i];
        NSString *methodName = [NSString stringWithFormat:@"%s", property_getName(property)];
        SEL getSel = NSSelectorFromString(methodName);
        if ([self respondsToSelector:getSel]) {
            id valueObj = [self valueForKey:methodName];
            if (valueObj) {
                [attrsDesc appendFormat:@" [%@=%@] ",methodName, valueObj];
            }else {
                [attrsDesc appendFormat:@" [%@=nil] ",methodName];
            }
        }
    }
    free(propertyList);
    NSString *customDesc = [self customDescription];
    NSString *desc;
    
    if (customDesc && [customDesc length] > 0 ) {
        desc = [NSString stringWithFormat:@"%@:{%@,%@}",[self class],attrsDesc,customDesc];
    }else {
        desc = [NSString stringWithFormat:@"%@:{%@}",[self class],attrsDesc];
    }
    return desc;
}

/**
 * 功能描述: 自定义描述
 * 输入参数: N/A
 * 输出参数: N/A
 * 返 回 值: NSString
 */
- (NSString *)customDescription{
    //子类可实现
    return nil;
}

/**
 * 功能描述: 当前对象转换成输入类型
 * 输入参数: N/A
 * 输出参数: N/A
 * 返 回 值: dic
 */
-(id)convert2object:(NSObject*)obj
{
    //当前对象属性列表
    unsigned int selfCount = 0;
    objc_property_t *selfPropertyList = class_copyPropertyList([self class],&selfCount);
    //传入对象属性列表
    unsigned int inputCount = 0;
    objc_property_t *inputPropertyList = class_copyPropertyList([obj class], &inputCount);
    for(int i = 0; i < selfCount; i++)
    {
        objc_property_t currProperty = selfPropertyList[i];
        NSString *currPropertyName = [NSString stringWithFormat:@"%s", property_getName(currProperty)];
        for (NSUInteger j = 0; j < inputCount; j++) {
            objc_property_t inputProperty = inputPropertyList[j];
            NSString *inputPropertyName = [NSString stringWithFormat:@"%s", property_getName(inputProperty)];
            //忽略只读属性
            SEL setterSel = [self getSetterSelWithAttibuteName:inputPropertyName];
            if (![self respondsToSelector:setterSel])
                continue;
            //转换大写对比属性名
            if ([[currPropertyName uppercaseString] isEqualToString:[inputPropertyName uppercaseString]])
            {
                id value = [self valueForKey:currPropertyName];
                
                if (value && ![value isKindOfClass:[NSNull class]])
                {
                    [obj setValue:value forKey:inputPropertyName];
                }
                else
                {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                    [obj performSelector:setterSel withObject:nil];
#pragma clang diagnostic pop
                }
                break;
            }
        }
    }
    free(selfPropertyList);
    free(inputPropertyList);
    return obj;
}

/**
 * 功能描述: 当前对象转换成字典
 * 输入参数: N/A
 * 输出参数: N/A
 * 返 回 值: dic
 */
-(NSMutableDictionary *)convert2Dictionary
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    //当前对象属性列表
    unsigned int selfCount = 0;
    objc_property_t *selfPropertyList = class_copyPropertyList([self class],&selfCount);
    for(int i = 0; i < selfCount; i++){
        objc_property_t currProperty = selfPropertyList[i];
        NSString *currPropertyName = [NSString stringWithFormat:@"%s", property_getName(currProperty)];
        id value = [self valueForKey:currPropertyName];
        [dic setValue:value forKey:currPropertyName];
    }
    free(selfPropertyList);
    return dic;
}


/**
 * 功能描述: 清除换行符和回车符
 * 输入参数: string
 * 输出参数: N/A
 * 返 回 值: string
 */
- (NSString *)cleanString:(NSString *)str {
    if (str == nil) {
        return @"";
    }
    NSMutableString *cleanString = [NSMutableString stringWithString:str];
    [cleanString replaceOccurrencesOfString:@"\n" withString:@""
                                    options:NSCaseInsensitiveSearch
                                      range:NSMakeRange(0, [cleanString length])];
    [cleanString replaceOccurrencesOfString:@"\r" withString:@""
                                    options:NSCaseInsensitiveSearch
                                      range:NSMakeRange(0, [cleanString length])];
    return cleanString;
}

- (void)dealloc{

}

@end
