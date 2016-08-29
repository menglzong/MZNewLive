//
//  BaseListModel.h
//  LiuLianLib
//
//  Created by BlackDev on 1/8/15.
//  Copyright (c) 2015 SF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface BaseListModel : BaseModel

// 数据数组
@property (nonatomic, strong) NSMutableArray *items;
// 每页行数
@property (nonatomic, assign) NSInteger      pageNum;
// 当前页码
@property (nonatomic, assign) NSInteger      page;
// 当前页面数据数量
@property (nonatomic, assign) NSInteger      rows;
// 是否有更多
@property (nonatomic, assign) BOOL           hasMore;
// 总数量
@property (nonatomic, assign) NSInteger      totalRecords;
// 一行展示的个数（主要用于CMS，可配置成小数）
@property (nonatomic, strong) NSNumber       *displaySize;

/*!
 @function
 @abstract      通过array初始化
 */
- (id)initWithArray:(NSArray*)array;

/*!
 @function
 @abstract      array序列化
 */
- (NSArray*)arrayValue;

/*!
 @function
 @abstract      返回指定index的数据
 */
- (id)objectAtIndex:(NSUInteger)index;


- (void)removeAllObjects;

- (void)addObject:(id)object;

@end
