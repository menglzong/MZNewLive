//
//  UIView+SSNUIFrame.m
//  sfhaitao
//
//  Created by meng on 15/12/30.
//  Copyright (c) 2015年 meng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SSNUIFrame)

/**
 *  view的大小，设置时不改变原点位置
 */
@property (nonatomic) CGSize ssn_size;

/**
 *  view的原点位置
 */
@property (nonatomic) CGPoint ssn_origin;

/**
 *  view的宽度
 */
@property (nonatomic) CGFloat ssn_width;

/**
 *  view的高度
 */
@property (nonatomic) CGFloat ssn_height;

/**
 *  view的origin.x
 */
@property (nonatomic) CGFloat ssn_x;

/**
 *  view的origin.y
 */
@property (nonatomic) CGFloat ssn_y;

/**
 *  view左边位置
 */
@property (nonatomic) CGFloat ssn_left;

/**
 *  view上边位置
 */
@property (nonatomic) CGFloat ssn_top;

/**
 *  view下边位置
 */
@property (nonatomic) CGFloat ssn_bottom;

/**
 *  view右边位置
 */
@property (nonatomic) CGFloat ssn_right;

/**
 *  view的center
 */
@property (nonatomic) CGPoint ssn_center;

/**
 *  view的center.x
 */
@property (nonatomic) CGFloat ssn_center_x;

/**
 *  view的center.y
 */
@property (nonatomic) CGFloat ssn_center_y;

/**
 *  view的左上角
 */
@property (nonatomic) CGPoint ssn_top_left_corner;

/**
 *  view的右上角
 */
@property (nonatomic) CGPoint ssn_top_right_corner;

/**
 *  view的右下角
 */
@property (nonatomic) CGPoint ssn_bottom_right_corner;

/**
 *  view的左下角
 */
@property (nonatomic) CGPoint ssn_bottom_left_corner;

/**
 *  上边线中心点
 */
@property (nonatomic) CGPoint ssn_top_center;

/**
 *  右边线中心点
 */
@property (nonatomic) CGPoint ssn_right_center;

/**
 *  底边线中心点
 */
@property (nonatomic) CGPoint ssn_bottom_center;

/**
 *  左边线中心点
 */
@property (nonatomic) CGPoint ssn_left_center;


@end

/**
 *  左上角
 *
 *  @param rect 矩形区域
 *
 *  @return 左上角坐标
 */
CGPoint ssn_top_left_corner(CGRect rect);

/**
 *  右上角
 *
 *  @param rect 矩形区域
 *
 *  @return 右上角坐标
 */
CGPoint ssn_top_right_corner(CGRect rect);

/**
 *  右下角
 *
 *  @param rect 矩形区域
 *
 *  @return 右下角坐标
 */
CGPoint ssn_bottom_right_corner(CGRect rect);

/**
 *  左下角
 *
 *  @param rect 矩形区域
 *
 *  @return 左下角坐标
 */
CGPoint ssn_bottom_left_corner(CGRect rect);

/**
 *  中心点
 *
 *  @param rect 矩形区域
 *
 *  @return 中心点坐标
 */
CGPoint ssn_center(CGRect rect);

/**
 *  上边线中心点
 *
 *  @param CGRect 矩形区域
 *
 *  @return 上边线中心点坐标
 */
CGPoint ssn_top_center(CGRect rect);

/**
 *  右边线中心点
 *
 *  @param rect 矩形区域
 *
 *  @return 右边线中心点坐标
 */
CGPoint ssn_right_center(CGRect rect);

/**
 *  底边线中心点
 *
 *  @param rect 矩形区域
 *
 *  @return 底边线中心点坐标
 */
CGPoint ssn_bottom_center(CGRect rect);

/**
 *  左边线中心点
 *
 *  @param rect 矩形区域
 *
 *  @return 左边线中心点坐标
 */
CGPoint ssn_left_center(CGRect rect);


