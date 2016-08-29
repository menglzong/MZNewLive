//
//  MyTabBar.h
//  XYHealth
//
//  Created by junxian on 14-4-24.
//  Copyright (c) 2014年 junxian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabBarButton.h"
#import "SFFooterItemModel.h"

#define kTabBarHeight 49

@class TabBarView;
@class TabBarItem;

@protocol TabBarViewDelegate<NSObject>

@required
- (BOOL)tabBarView:(TabBarView *)tabBarView tabBarItem:(TabBarItem*)barItem shouldSelectAtIndex:(NSInteger)itemIndex;
- (UIViewController*)tabBarView:(TabBarView *)tabBarView tabBarItem:(TabBarItem*)barItem viewControllerAtIndex:(NSInteger)itemIndex;

// 已经选中当前tab， 再次点击
- (void)tabBarView:(TabBarView *)tabBarView refreshTabBarItem:(TabBarItem *)barItem;

@end

@interface TabBarView : UIView
{
    UIView *_centerView;
    UIView *_centerMaskView;
}

@property(nonatomic, assign) id <TabBarViewDelegate> delegate;

@property (nonatomic, weak  ) UIViewController *parentViewController;
@property (nonatomic, strong) UIViewController *currentViewController;
@property (nonatomic, strong) NSMutableArray   *views;
@property NSInteger currentTabIndex;

@property (nonatomic, assign) BOOL hiddenCenterView;

- (void)setViewItems:(NSArray *)views;
// 插入一个item
- (void)insertViewItems:(TabBarItem *)item withIndex:(NSUInteger)index;
// 删除一个item
- (void)removeViewItemsWithIndex:(NSUInteger)index;
- (void)setSelectedItemWithIndex:(NSInteger)index;

@end


@interface TabBarItem :NSObject

- (id)initWithFoorItemModel:(SFFooterItemModel *)footerItem
            backgroundColor:(UIColor *)backgroundColor
                 titleColor:(UIColor *)titleColor
         selectedTitleColor:(UIColor *)selectedTitleColor
       badgeBackgroundColor:(UIColor *)badgeBackgroundColor
            badgeTitleColor:(UIColor *)badgeTitleColor;

- (id)initWithFoorItemModel:(SFFooterItemModel *)footerItem
            backgroundColor:(UIColor *)backgroundColor
                 titleColor:(UIColor *)titleColor
         selectedTitleColor:(UIColor *)selectedTitleColor
       badgeBackgroundColor:(UIColor *)badgeBackgroundColor
            badgeTitleColor:(UIColor *)badgeTitleColor
            tipStyle:(TipButtonTipStyle)tipStyle;


@property (nonatomic, strong) NSString *highlightIcon;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *iconUrl;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *selectedTitleColor;

@property (nonatomic, strong) TabBarButton      *tabButton;
@property (nonatomic, assign) NSInteger        badgeNumber;
@property (nonatomic, strong) SFFooterItemModel *footerItem;

@end
