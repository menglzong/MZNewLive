//
//  BaseModel.h
//  LiuLian
//
//  Created by Liubin on 14/12/9.
//  Copyright (c) 2014年 MacBook Air. All rights reserved.
//

#import <Foundation/Foundation.h>

/**************************************************
 * 内容描述: 实体类基类【提供序列化入口方法,归档、拷贝协议实现,通用方法及其他抽象属性实现】
 * 创 建 人: 刘彬
 * 创建日期: 2014-12-09
 **************************************************/
@interface BaseModel : NSObject<NSCoding,NSCopying>

@property(nonatomic,strong) NSError *error;

-(id)initWithJsonString:(NSString*)str;
-(id)initWithDictionary:(NSDictionary*)dict;
-(id)initWithObject:(NSObject *)obj;
-(void)setPropertyWithObject:(NSObject*)object;
-(void)setPropertyWithDictionary:(NSDictionary*)attrMapDic;
- (NSString *)customDescription;
- (NSString *)description;
- (NSData*)getArchivedData;
-(id)convert2object:(NSObject*)obj;
-(NSMutableDictionary *)convert2Dictionary;

- (NSString *)cleanString:(NSString *)str;


@end
