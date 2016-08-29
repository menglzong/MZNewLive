//
//  SFAlterController.h
//  actionSheet
//
//  Created by meng on 4/11/16.
//  Copyright © 2016 meng. All rights reserved.
//  ios7,ios8,ios9 通用alterViewController

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// alter style
typedef NS_ENUM(NSUInteger, SFAlertControllerStyle) {
    SFAlertControllerStyleActionSheet = 0,
    SFAlertControllerStyleAlter,
};

// action style
typedef NS_ENUM(NSInteger, SFAlertActionStyle) {
    SFAlertActionStyleDefault = 0,
    SFAlertActionStyleCancel,
    SFAlertActionStyleDestructive
};


@interface SFAlertAction : NSObject
/*!
 *  @brief SFAlertAction构造方法
 *
 *  @param title   title
 *  @param style   SFAlertActionStyle
 *  @param handler handle
 *
 */
+(instancetype)actionWithTitle:(NSString *)title
                         style:(SFAlertActionStyle)style
                       handler:(void (^ _Nullable)(SFAlertAction * _Nonnull action))handler;
@end

@interface SFAlertController : NSObject

/*!
 *  @brief 默认初始化方法
 *
 *  @param title          title
 *  @param message        message
 *  @param preferredStyle SFAlertControllerStyle
 */
+ (instancetype)alertControllerWithTitle:(nullable NSString *)title
                                 message:(nullable NSString *)message
                          preferredStyle:(SFAlertControllerStyle)preferredStyle;

/*!
 *  @brief 显示一个actionSheet
 *
 *  @param title title
 *
 */
+ (instancetype)actionSheetWithTitle:(nullable NSString *)title;

/*!
 *  @brief 显示一个alter
 *
 *  @param title   title
 *  @param message message
 *
 */
+ (instancetype)alertWithTitle:(nullable NSString *)title message:(nullable NSString *)message;

/*!
 *  @brief alter快捷初始化方法
 *
 *  @param title       title
 *  @param message     message
 *  @param cancelTitle cancel title
 *  @param cancelBlock cancelBlock
 *  @param otherTitle  otherTitle
 *  @param otherBlock  otherBlock
 *
 */
- (instancetype)alertWithTitle: (NSString * _Nullable)title
                       message:(NSString *)message
             cancelButtonTitle:(NSString * _Nullable)cancelTitle
                   cancelBlock:(void (^ _Nullable)(SFAlertAction *))cancelBlock
              otherButtonTitle: (NSString * _Nullable)otherTitle
                    otherBlock:(void (^ _Nullable)(SFAlertAction *))otherBlock;

- (instancetype)init NS_UNAVAILABLE;

/*!
 *  @brief 增加action
 *
 *  @param action SFAlertAction
 */
- (void)addAction: (SFAlertAction *)action;

/*!
 *  @brief 支持UITextField操作
 *
 *  @param configurationHandler block
 */
- (void)addTextFieldWithConfigurationHandler:(void (^)(UITextField *textField))configurationHandler;

/*!
 *  @brief 显示alterController
 *
 *  @param viewController viewController
 *  @param flag           flag
 *  @param completion     block
 */
-(void)sf_presentViewWithController:(nullable UIViewController *)viewController
                           animated:(BOOL)flag
                         completion:(void (^ __nullable)(void))completion;

/*!
 *  @brief 显示alterController,默认参数
 *
 */
-(void)sf_presentViewWithController:(nullable UIViewController *)viewController;

/*!
 *  @brief 当前的action
 */
@property (nullable, nonatomic, copy, readonly) NSArray<SFAlertAction *> *actions;

/*!
 *  @brief textFields
 */
@property (nullable, nonatomic, readonly) NSArray<UITextField *> *textFields;

/*!
 *  @brief title
 */
@property (nullable, nonatomic, copy) NSString *title;

/*!
 *  @brief message
 */
@property (nullable, nonatomic, copy) NSString *message;

/*!
 *  @brief textField的相关操作block
 */
@property (nullable, nonatomic, copy, readonly) NSArray< void (^)(UITextField *textField)> *textFieldHandlers;

/*!
 *  @brief 展示的style
 */
@property (nonatomic, readonly) SFAlertControllerStyle preferredStyle;

/*!
 *  @brief 当前显示的alter (UIAlertController, UIActionSheet, UIAlterView)
 */
@property (nonnull,nonatomic,strong,readonly) id adaptiveAlert;

@end

NS_ASSUME_NONNULL_END