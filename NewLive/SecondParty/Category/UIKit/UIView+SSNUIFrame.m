//
//  UIView+SSNUIFrame.m
//  sfhaitao
//
//  Created by meng on 15/12/30.
//  Copyright (c) 2015年 meng. All rights reserved.
//

#import "UIView+SSNUIFrame.h"

@implementation UIView (SSNUIFrame)

- (CGSize)ssn_size {
    return self.frame.size;
}
- (void)setSsn_size:(CGSize)ssn_size {
    CGRect frame = self.frame;
    frame.size = ssn_size;
    self.frame = frame;
}

- (CGPoint)ssn_origin {
    return self.frame.origin;
}
- (void)setSsn_origin:(CGPoint)ssn_origin {
    CGRect frame = self.frame;
    frame.origin = ssn_origin;
    self.frame = frame;
}

- (CGFloat)ssn_width {
    return self.frame.size.width;
}
- (void)setSsn_width:(CGFloat)ssn_width {
    CGRect frame = self.frame;
    frame.size.width = ssn_width;
    self.frame = frame;
}

- (CGFloat)ssn_height {
    return self.frame.size.height;
}
- (void)setSsn_height:(CGFloat)ssn_height {
    CGRect frame = self.frame;
    frame.size.height = ssn_height;
    self.frame = frame;
}

- (CGFloat)ssn_x {
    return self.frame.origin.x;
}
- (void)setSsn_x:(CGFloat)ssn_x {
    CGRect frame = self.frame;
    frame.origin.x = ssn_x;
    self.frame = frame;
}

- (CGFloat)ssn_y {
    return self.frame.origin.y;
}
- (void)setSsn_y:(CGFloat)ssn_y {
    CGRect frame = self.frame;
    frame.origin.y = ssn_y;
    self.frame = frame;
}

- (CGFloat)ssn_left {
    return self.frame.origin.x;
}
- (void)setSsn_left:(CGFloat)ssn_left {
    CGRect frame = self.frame;
    frame.origin.x = ssn_left;
    self.frame = frame;
}

- (CGFloat)ssn_top {
    return self.frame.origin.y;
}
- (void)setSsn_top:(CGFloat)ssn_top {
    CGRect frame = self.frame;
    frame.origin.y = ssn_top;
    self.frame = frame;
}

- (CGFloat)ssn_bottom {
    return self.frame.origin.y + self.frame.size.height;
}
- (void)setSsn_bottom:(CGFloat)ssn_bottom {
    CGRect frame = self.frame;
    frame.origin.y = ssn_bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)ssn_right {
    return self.frame.origin.x + self.frame.size.width;
}
- (void)setSsn_right:(CGFloat)ssn_right {
    CGRect frame = self.frame;
    frame.origin.x = ssn_right - frame.size.width;
    self.frame = frame;
}

- (CGPoint)ssn_center {
    return self.center;
}
- (void)setSsn_center:(CGPoint)ssn_center {
    self.center = ssn_center;
}

- (CGFloat)ssn_center_x {
    return self.center.x;
}
- (void)setSsn_center_x:(CGFloat)ssn_center_x {
    CGPoint center = self.center;
    center.x = ssn_center_x;
    self.center = center;
}

- (CGFloat)ssn_center_y {
    return self.center.y;
}
- (void)setSsn_center_y:(CGFloat)ssn_center_y {
    CGPoint center = self.center;
    center.y = ssn_center_y;
    self.center = center;
}

- (CGPoint)ssn_top_left_corner {
    return self.frame.origin;
}
- (void)setSsn_top_left_corner:(CGPoint)ssn_top_left_corner {
    CGRect frame = self.frame;
    frame.origin = ssn_top_left_corner;
    self.frame = frame;
}

- (CGPoint)ssn_top_right_corner {
    CGRect frame = self.frame;
    frame.origin.x += frame.size.width;
    return frame.origin;
}
- (void)setSsn_top_right_corner:(CGPoint)ssn_top_right_corner {
    CGRect frame = self.frame;
    frame.origin.x = ssn_top_right_corner.x - frame.size.width;
    frame.origin.y = ssn_top_right_corner.y;
    self.frame = frame;
}

- (CGPoint)ssn_bottom_right_corner {
    CGRect frame = self.frame;
    frame.origin.x += frame.size.width;
    frame.origin.y += frame.size.height;
    return frame.origin;
}
- (void)setSsn_bottom_right_corner:(CGPoint)ssn_bottom_right_corner {
    CGRect frame = self.frame;
    frame.origin.x = ssn_bottom_right_corner.x - frame.size.width;
    frame.origin.y = ssn_bottom_right_corner.y - frame.size.height;
    self.frame = frame;
}

- (CGPoint)ssn_bottom_left_corner {
    CGRect frame = self.frame;
    frame.origin.y += frame.size.height;
    return frame.origin;
}
- (void)setSsn_bottom_left_corner:(CGPoint)ssn_bottom_left_corner {
    CGRect frame = self.frame;
    frame.origin.x = ssn_bottom_left_corner.x;
    frame.origin.y = ssn_bottom_left_corner.y - frame.size.height;
    self.frame = frame;
}

- (CGPoint)ssn_top_center {
    CGRect frame = self.frame;
    frame.origin.x += (frame.size.width)/2;
    return frame.origin;
}
- (void)setSsn_top_center:(CGPoint)ssn_top_center {
    CGRect frame = self.frame;
    frame.origin.x = ssn_top_center.x - (frame.size.width)/2;
    frame.origin.y = ssn_top_center.y;
    self.frame = frame;
}

- (CGPoint)ssn_right_center {
    CGRect frame = self.frame;
    frame.origin.x += frame.size.width;
    frame.origin.y += (frame.size.height)/2;
    return frame.origin;
}
- (void)setSsn_right_center:(CGPoint)ssn_right_center {
    CGRect frame = self.frame;
    frame.origin.x = ssn_right_center.x - frame.size.width;
    frame.origin.y = ssn_right_center.y - (frame.size.height)/2;
    self.frame = frame;
}

- (CGPoint)ssn_bottom_center {
    CGRect frame = self.frame;
    frame.origin.x += (frame.size.width)/2;
    frame.origin.y += frame.size.height;
    return frame.origin;
}
- (void)setSsn_bottom_center:(CGPoint)ssn_bottom_center {
    CGRect frame = self.frame;
    frame.origin.x = ssn_bottom_center.x - (frame.size.width)/2;
    frame.origin.y = ssn_bottom_center.y - frame.size.height;
    self.frame = frame;
}

- (CGPoint)ssn_left_center {
    CGRect frame = self.frame;
    frame.origin.y += (frame.size.height)/2;
    return frame.origin;
}
- (void)setSsn_left_center:(CGPoint)ssn_left_center {
    CGRect frame = self.frame;
    frame.origin.x = ssn_left_center.x;
    frame.origin.y = ssn_left_center.y - (frame.size.height)/2;
    self.frame = frame;
}

@end

/**
 *  左上角
 *
 *  @param rect 矩形区域
 *
 *  @return 左上角坐标
 */
CGPoint ssn_top_left_corner(CGRect rect) {
    return rect.origin;
}

/**
 *  右上角
 *
 *  @param rect 矩形区域
 *
 *  @return 右上角坐标
 */
CGPoint ssn_top_right_corner(CGRect rect) {
    return CGPointMake(rect.origin.x + rect.size.width, rect.origin.y);
}

/**
 *  右下角
 *
 *  @param rect 矩形区域
 *
 *  @return 右下角坐标
 */
CGPoint ssn_bottom_right_corner(CGRect rect) {
    return CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
}

/**
 *  左下角
 *
 *  @param rect 矩形区域
 *
 *  @return 左下角坐标
 */
CGPoint ssn_bottom_left_corner(CGRect rect) {
    return CGPointMake(rect.origin.x, rect.origin.y + rect.size.height);
}

/**
 *  中心点
 *
 *  @param rect 矩形区域
 *
 *  @return 中心点坐标
 */
CGPoint ssn_center(CGRect rect) {
    return CGPointMake(rect.origin.x + (rect.size.width)/2, rect.origin.y + (rect.size.height)/2);
}

/**
 *  上边线中心点
 *
 *  @param CGRect 矩形区域
 *
 *  @return 上边线中心点坐标
 */
CGPoint ssn_top_center(CGRect rect) {
    return CGPointMake(rect.origin.x + (rect.size.width)/2, rect.origin.y);
}

/**
 *  右边线中心点
 *
 *  @param rect 矩形区域
 *
 *  @return 右边线中心点坐标
 */
CGPoint ssn_right_center(CGRect rect) {
    return CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + (rect.size.height)/2);
}

/**
 *  底边线中心点
 *
 *  @param rect 矩形区域
 *
 *  @return 底边线中心点坐标
 */
CGPoint ssn_bottom_center(CGRect rect) {
    return CGPointMake(rect.origin.x + (rect.size.width)/2, rect.origin.y + rect.size.height);
}

/**
 *  左边线中心点
 *
 *  @param rect 矩形区域
 *
 *  @return 左边线中心点坐标
 */
CGPoint ssn_left_center(CGRect rect) {
    return CGPointMake(rect.origin.x, rect.origin.y + (rect.size.height)/2);
}
