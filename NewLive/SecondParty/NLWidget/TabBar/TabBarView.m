//
//  MyTabBar.m
//  XYHealth
//
//  Created by junxian on 14-4-24.
//  Copyright (c) 2014年 junxian. All rights reserved.
//

#import "TabBarView.h"
#import <QuartzCore/QuartzCore.h>
#import "UnitsMethods.h"
#import "UIButton+WebCache.h"


float _tabItemWidth;
float _tabItemHeight;

#define kPointWidth (9)
#define kTabWidth (26)
#define kCenterWidth 60

@interface TabBarView ()
{
    
}

-(void)buttonClickAction:(id)sender;


@end
@implementation TabBarView

- (id)initWithFrame:(CGRect)frame
{
    _tabItemWidth = 30;
    _tabItemHeight = kTabBarHeight,
    
    self = [super initWithFrame:frame];
    
    if (self) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 1)];
        line.backgroundColor = RGBA_COLOR(234, 234, 234, 1);
        [self addSubview:line];
        [self setBackgroundColor:[UIColor whiteColor]];
        
        _centerView = [[UIView alloc] initWithFrame:CGRectMake((frame.size.width - kCenterWidth) / 2, -25, kCenterWidth, kCenterWidth)];
        [_centerView.layer setCornerRadius:kCenterWidth / 2];
        _centerView.layer.borderColor = RGBA_COLOR(234, 234, 234, 1).CGColor;
        _centerView.layer.borderWidth = 1;
        [_centerView.layer setMasksToBounds:YES];
        [self addSubview:_centerView];
        _hiddenCenterView = YES;
        _centerView.hidden = YES;
        
        _centerMaskView = [[UIView alloc] initWithFrame:CGRectMake((frame.size.width - kCenterWidth) / 2, 1, kCenterWidth, frame.size.height - 1)];
        [self addSubview:_centerMaskView];
    }

    return self;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    _centerView.backgroundColor = backgroundColor;
    _centerMaskView.backgroundColor = backgroundColor;
}

- (void)setHiddenCenterView:(BOOL)hiddenCenterView
{
    _hiddenCenterView = hiddenCenterView;
    _centerView.hidden = hiddenCenterView;
    _centerMaskView.hidden = hiddenCenterView;
    
    if (self.views.count > 0) {
        NSInteger index = floorf((self.views.count * 1.0) / 2);
        if (index < self.views.count) {
            TabBarItem *item = [self.views objectAtIndex:index];
            
            if (hiddenCenterView) {
                item.tabButton.frame = CGRectMake(item.tabButton.frame.origin.x, 1, item.tabButton.frame.size.width, self.frame.size.height - 1);

                [item.tabButton setTitleColor:item.titleColor forState:UIControlStateNormal];
                if (![NSString sf_isBlankString:item.iconUrl]) {
                    item.tabButton.isNetworkForNormal = YES;
                    [item.tabButton sd_setImageWithURL:[NSURL URLWithPath:item.footerItem.iconUrl viewSize:CGSizeMake(kTabWidth, kTabWidth) cut:YES] forState:UIControlStateNormal placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        
                        if (![NSString sf_isBlankString:item.footerItem.title]) {
                            [item.tabButton setTitle:item.footerItem.title forState:UIControlStateNormal];
                        }
                    }];
                } else {
                    [item.tabButton setImage:[UIImage imageNamed:item.icon] forState:UIControlStateNormal];
                }
            } else {
                _centerView.alpha = 0;
                [item.tabButton setTitleColor:item.selectedTitleColor forState:UIControlStateNormal];
                [UIView beginAnimations:@"tabbar" context:nil];
                [UIView animateWithDuration:0.5 animations:^{
                    item.tabButton.isNetworkForNormal = NO;
                    item.tabButton.frame = CGRectMake(item.tabButton.frame.origin.x, -25, item.tabButton.frame.size.width, self.frame.size.height + 25);
                    
                    [item.tabButton setImage:[UIImage imageNamed:item.highlightIcon] forState:UIControlStateNormal];
                    _centerView.alpha = 1;
                } completion:^(BOOL finished) {
                    if (finished) {
                        
                    }
                }];
                [UIView commitAnimations];
            }
        }
    }
}

-(void)setViewItems:(NSArray *)views
{
    if (self.views == nil) {
        self.views = [[NSMutableArray alloc] init];
    }
    
    for (TabBarItem *item in self.views) {
        [item.tabButton removeFromSuperview];
    }
    
    [self.views removeAllObjects];
    [self.views addObjectsFromArray:views];
    [self setTabBarViewFrame];

    for(int i=0; i < self.views.count; i++){
        TabBarItem *item=[self.views objectAtIndex:i];
        

        if(i == self.currentTabIndex) {
            if ([self.delegate respondsToSelector:@selector(tabBarView:tabBarItem:shouldSelectAtIndex:)]) {
                [self.delegate tabBarView:self tabBarItem:item shouldSelectAtIndex:i];
            }
            UIViewController *vc = nil;
            if (self.delegate && [self.delegate respondsToSelector:@selector(tabBarView:tabBarItem:viewControllerAtIndex:)]) {
                vc = [self.delegate tabBarView:self tabBarItem:item viewControllerAtIndex:i];
            }
            //先加入vc之间的子父关系，防止child vc viewDidLoad依赖响应链建立
            [self.parentViewController addChildViewController:vc];
            self.currentViewController = vc;
            [self.parentViewController.view addSubview:self.currentViewController.view];
            self.currentViewController.view.frame= CGRectMake(0, 0, self.parentViewController.view.frame.size.width, self.parentViewController.view.frame.size.height - kTabBarHeight);
            self.currentViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            item.tabButton.enabled = NO;
        }
        
        item.tabButton.exclusiveTouch=YES;
        [self addSubview:item.tabButton];
        [item.tabButton addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchDown];
    }
    
    [self.parentViewController.view bringSubviewToFront:self];
}

- (void)insertViewItems:(TabBarItem *)item withIndex:(NSUInteger)index
{
    [self.views insertObject:item atIndex:index];
    
    [item.tabButton addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchDown];
    item.tabButton.exclusiveTouch=YES;
    [self addSubview:item.tabButton];

    [self setTabBarViewFrame];
    [self.parentViewController.view bringSubviewToFront:self];
}

- (void)removeViewItemsWithIndex:(NSUInteger)index
{
    TabBarItem *tabBarItem = [self.views objectAtIndex:index];
    [tabBarItem.tabButton removeFromSuperview];
    [self.views removeObjectAtIndex:index];
    [self setTabBarViewFrame];
    [self.parentViewController.view bringSubviewToFront:self];
}

- (void)setTabBarViewFrame
{
    _tabItemWidth = kMainScreenWidth / self.views.count;

    for(int i=0; i < self.views.count; i++){
        TabBarItem *item=[self.views objectAtIndex:i];

        item.tabButton.frame = CGRectMake(_tabItemWidth * i, 1, _tabItemWidth, self.frame.size.height - 1);
        item.tabButton.tag = 1000 + i;
        
        if (![NSString sf_isBlankString:item.footerItem.iconUrl]) {
            [item.tabButton sd_setImageWithURL:[NSURL URLWithPath:item.footerItem.iconUrl viewSize:CGSizeMake(kTabWidth, kTabWidth) cut:YES] forState:UIControlStateNormal placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                if (![NSString sf_isBlankString:item.footerItem.title]) {
                    [item.tabButton setTitle:item.footerItem.title forState:UIControlStateNormal];
                }
                
                if (![NSString sf_isBlankString:item.footerItem.highlightIconUrl]) {
                    [item.tabButton sd_setImageWithURL:[NSURL URLWithPath:item.footerItem.highlightIconUrl viewSize:CGSizeMake(kTabWidth, kTabWidth) cut:YES] forState:UIControlStateHighlighted];
                    [item.tabButton sd_setImageWithURL:[NSURL URLWithPath:item.footerItem.highlightIconUrl viewSize:CGSizeMake(kTabWidth, kTabWidth) cut:YES] forState:UIControlStateDisabled];
                }
            }];
        }
    }
}

-(void)setSelectedItemWithIndex:(NSInteger)index
{
    if (index < self.views.count) {
        UIButton *ii = [[UIButton alloc]init];
        ii.tag = 1000 + index;
        [self buttonClickAction:ii];
    }
}

-(void)buttonClickAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSUInteger index = button.tag - 1000;
    
    if(index >= self.views.count) {
        return;
    }

    TabBarItem *tabBar = [self.views objectAtIndex:index];
    
    if(self.currentTabIndex == index) {
        if ([self.delegate respondsToSelector:@selector(tabBarView:refreshTabBarItem:)]) {
            [self.delegate tabBarView:self refreshTabBarItem:tabBar];
        }
        
        return;
    }

    BOOL should = YES;
    
    if ([self.delegate respondsToSelector:@selector(tabBarView:tabBarItem:shouldSelectAtIndex:)]) {
        should = [self.delegate tabBarView:self tabBarItem:tabBar shouldSelectAtIndex:index];
    }
    if (!should){
        return;
    }
    UIViewController *vc = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabBarView:tabBarItem:viewControllerAtIndex:)]) {
        vc = [self.delegate tabBarView:self tabBarItem:tabBar viewControllerAtIndex:index];
        //先加入vc之间的子父关系，防止child vc viewDidLoad依赖响应链建立
        [self.parentViewController addChildViewController:vc];
    }
    
    if (!vc) {
        return;
    }
    
    
    for(int i = 0; i < self.views.count; i++){
        TabBarItem *tab = [self.views objectAtIndex:i];
        if (tab.tabButton.tag != button.tag) {
            tab.tabButton.enabled = YES;
        }else{
            button = tab.tabButton;
        }
    }
    
    tabBar.tabButton.enabled = !self.hiddenCenterView;
    
    vc.view.frame= CGRectMake(0, 0, self.parentViewController.view.bounds.size.width, self.parentViewController.view.bounds.size.height - kTabBarHeight);
    vc.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    
    self.parentViewController.view.autoresizesSubviews = YES;
    [self.parentViewController.view addSubview:vc.view];
    [self.currentViewController.view removeFromSuperview];
    
//    //显示在最上面一层
    [self.parentViewController.view bringSubviewToFront:self];
    self.currentViewController = vc;
    
    self.currentTabIndex = button.tag - 1000;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(nullable UIEvent *)event
{
    BOOL result = [super pointInside:point withEvent:event];
    
    if (result) {
        return result;
    } else if (self.hiddenCenterView == NO) {
        return CGRectContainsPoint(_centerView.frame, point);
    }
    
    return result;
}

@end

@interface TabBarItem ()

@end

@implementation TabBarItem

- (id)initWithFoorItemModel:(SFFooterItemModel *)footerItem backgroundColor:(UIColor *)backgroundColor titleColor:(UIColor *)titleColor selectedTitleColor:(UIColor *)selectedTitleColor badgeBackgroundColor:(UIColor *)badgeBackgroundColor badgeTitleColor:(UIColor *)badgeTitleColor
{
    return [self initWithFoorItemModel:footerItem backgroundColor:backgroundColor titleColor:titleColor selectedTitleColor:selectedTitleColor badgeBackgroundColor:badgeBackgroundColor badgeTitleColor:badgeTitleColor tipStyle:TipButtonTipStyleNormal];
}

- (id)initWithFoorItemModel:(SFFooterItemModel *)footerItem
            backgroundColor:(UIColor *)backgroundColor
                 titleColor:(UIColor *)titleColor
         selectedTitleColor:(UIColor *)selectedTitleColor
       badgeBackgroundColor:(UIColor *)badgeBackgroundColor
            badgeTitleColor:(UIColor *)badgeTitleColor
    tipStyle:(TipButtonTipStyle)tipStyle
{
    self = [super init];
    
    self.footerItem = footerItem;
    
    self.tabButton = [[TabBarButton alloc] initWithFrame:CGRectMake(0, 0, _tabItemWidth, _tabItemHeight)];
    
    if (footerItem.icon) {
        [self.tabButton setImage:[UIImage imageNamed:footerItem.icon] forState:UIControlStateNormal];
        
        if (![NSString sf_isBlankString:footerItem.title]) {
            [self.tabButton setTitle:footerItem.title forState:UIControlStateNormal];
        }
        self.icon = footerItem.icon;
    } else if (footerItem.iconUrl) {
        self.iconUrl = footerItem.iconUrl;
        self.tabButton.isNetworkForNormal = YES;
    }
    
    if (footerItem.highlightIcon) {
        [self.tabButton setImage:[UIImage imageNamed:footerItem.highlightIcon] forState:UIControlStateHighlighted];
        [self.tabButton setImage:[UIImage imageNamed:footerItem.highlightIcon] forState:UIControlStateDisabled];
        self.highlightIcon = footerItem.highlightIcon;
    } else if (footerItem.highlightIconUrl) {
        self.tabButton.isNetworkForHighlight = YES;
    }
    
    [self.tabButton setTitleColor:titleColor forState:UIControlStateNormal];
    [self.tabButton setTitleColor:selectedTitleColor forState:UIControlStateHighlighted];
    [self.tabButton setTitleColor:selectedTitleColor forState:UIControlStateDisabled];
    [self.tabButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    self.tabButton.titleLabel.font = Small_Font;
    
    self.titleColor = titleColor;
    self.selectedTitleColor = selectedTitleColor;
    
    self.tabButton.tipBackgroundColor = badgeBackgroundColor;
    self.tabButton.tipTitleColor = badgeTitleColor;
    self.tabButton.tipStyle = tipStyle;
    
    return self;
}

- (void)setBadgeNumber:(NSInteger)badgeNumber
{
    _badgeNumber = badgeNumber;
    [self.tabButton setTipValue:badgeNumber];
}

@end
