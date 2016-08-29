//
//  BaseListModel.m
//  LiuLianLib
//
//  Created by BlackDev on 1/8/15.
//  Copyright (c) 2015 SF. All rights reserved.
//

#import "BaseListModel.h"

@implementation BaseListModel

- (id)initWithArray:(NSArray *)array
{
    self = [super init];
    if (self) {
        _items = [NSMutableArray arrayWithArray:array];
    }
    return self;
}

- (NSArray *)arrayValue
{
    return nil;
}

- (id)objectAtIndex:(NSUInteger)index {
    if (index < [self.items count]) {
        id object = [self.items objectAtIndex:index];
        return object;
    }
    
    return nil;
}

- (void)removeAllObjects
{
    [self.items removeAllObjects];
}

- (void)addObject:(id)object
{
    [self.items addObject:object];
}

#pragma mark - setter/getter
- (NSMutableArray *)items{
    if (_items == nil) {
        self.items = [NSMutableArray array];
    }
    
    return _items;
}

@end
