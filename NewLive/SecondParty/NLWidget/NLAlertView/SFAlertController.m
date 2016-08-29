//
//  SFAlterController.m
//  actionSheet
//
//  Created by meng on 4/11/16.
//  Copyright © 2016 meng. All rights reserved.
//

#import "SFAlertController.h"
#import <objc/runtime.h>

@interface NSObject (alertController)
@property (nullable, nonatomic, strong) SFAlertController *alertController;
@end

@implementation NSObject (alertController)

@dynamic alertController;

-(void)setAlertController:(SFAlertController *)alertController {
    objc_setAssociatedObject(self, @selector(alertController), alertController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(SFAlertController *)alertController {
    return objc_getAssociatedObject(self, @selector(alertController));
}

@end

@interface SFAlertAction ()
@property (nonnull, nonatomic, copy) NSString *title;
@property (nonatomic, assign) SFAlertActionStyle style;
@property (nonatomic, copy) void (^handler)(SFAlertAction *);
@property (nullable, nonatomic, weak) SFAlertController *controller;

-(void)performAction;
@end

@implementation SFAlertAction
+ (instancetype)actionWithTitle:(NSString *)title style:(SFAlertActionStyle)style handler:(void (^)(SFAlertAction * _Nonnull action))handler {
    SFAlertAction *action = [[SFAlertAction alloc] init];
    action.title = [title copy];
    action.style = style;
    action.handler = [handler copy];
    return action;
}

-(void)performAction {
    if (self.handler) {
        self.handler(self);
        self.handler = nil;
    }
}

@end


@interface SFAlertController () <UIAlertViewDelegate, UIActionSheetDelegate>

@property (nonnull,nonatomic,strong,readwrite) id adaptiveAlert;

@property (nonnull,nonatomic, readwrite) NSArray<SFAlertAction *> *actions;

@property (nullable, nonatomic, copy, readwrite) NSArray< void (^)(UITextField *textField)> *textFieldHandlers;

@property (nonatomic, readwrite) SFAlertControllerStyle preferredStyle;

@end

@implementation SFAlertController

#pragma mark - lifecycle

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(SFAlertControllerStyle)preferredStyle {
    return [[self alloc] initWithTitle:title message:message preferredStyle:preferredStyle];
}

+ (instancetype)actionSheetWithTitle:(nullable NSString *)title {
    return [[self alloc] initWithTitle:title message:nil preferredStyle:SFAlertControllerStyleActionSheet];
}

+ (instancetype)alertWithTitle:(nullable NSString *)title message:(nullable NSString *)message {
    return [[self alloc] initWithTitle:title message:message preferredStyle:SFAlertControllerStyleAlter];
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(SFAlertControllerStyle)preferredStyle {
    if (self = [super init]) {
        self.preferredStyle = preferredStyle;
        
        if (IOS_VERSION_8_OR_ABOVE) {
            self.adaptiveAlert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(NSInteger)preferredStyle];
        } else {
            switch (preferredStyle) {
                case SFAlertControllerStyleAlter:
                    self.adaptiveAlert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
                    break;
                case  SFAlertControllerStyleActionSheet:
                    self.adaptiveAlert = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
                    break;
                default:
                    break;
            }
        }
    }
    return self;
}

#pragma mark converince init
- (instancetype)alertWithTitle: (NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelTitle cancelBlock:(void (^)(SFAlertAction *))cancelBlock otherButtonTitle: (NSString *)otherTitle otherBlock:(void (^)(SFAlertAction *))otherBlock {
    SFAlertController *controller = [[SFAlertController alloc] initWithTitle:title message:message preferredStyle:SFAlertControllerStyleAlter];
    if (cancelTitle.length > 0) {
        SFAlertAction *cancelAction = [SFAlertAction actionWithTitle:cancelTitle style:SFAlertActionStyleCancel handler:cancelBlock];
        [controller addAction:cancelAction];
    }
    
    if (otherTitle.length > 0) {
        SFAlertAction *otherAction = [SFAlertAction actionWithTitle:otherTitle style:SFAlertActionStyleDefault handler:otherBlock];
        [controller addAction:otherAction];
    }
    
    return controller;
}

#pragma mark - function

-(void)sf_presentViewWithController:(UIViewController *)viewController {
    [self sf_presentViewWithController:viewController animated:YES completion:nil];
}

-(void)sf_presentViewWithController:(UIViewController *)viewController animated:(BOOL)flag completion:(void (^)(void))completion {
    if (IOS_VERSION_8_OR_ABOVE) {
        if (viewController == nil) {
            UIApplication *applection = [UIApplication performSelector: NSSelectorFromString(NSStringFromSelector(@selector(sharedApplication)))];
            viewController = applection.keyWindow.rootViewController;
            
            while (viewController.presentedViewController) {
                viewController = viewController.presentedViewController;
            }
            
            if (viewController == nil) {
                return;
            }
        }
        [viewController presentViewController:self.adaptiveAlert animated:flag completion:^{
            objc_setAssociatedObject(viewController, _cmd, self, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }];
    } else {
        self.alertController = self;
        if ([self.adaptiveAlert isKindOfClass:[UIAlertView class]]) {
            [self.textFieldHandlers enumerateObjectsUsingBlock:^(void (^configurationHandler)(UITextField *textField), NSUInteger idx, BOOL * _Nonnull stop) {
                configurationHandler([self.adaptiveAlert textFieldAtIndex:idx]);
            }];
            [self.adaptiveAlert show];
        } else if ([self.adaptiveAlert isKindOfClass:[UIActionSheet class]]) {
            // actionsheet bug
            [self.adaptiveAlert showInView:[UIApplication sharedApplication].keyWindow];
        }
    }
    
    if (completion) {
        completion();
    }
}

-(void)addAction:(SFAlertAction *)action {
    action.controller = self;
    self.actions = [[NSArray arrayWithArray:self.actions] arrayByAddingObject:action];
    
    if (IOS_VERSION_8_OR_ABOVE) {
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:action.title style:(NSInteger)action.style handler:^(UIAlertAction * _Nonnull uiaction) {
            [action performAction];
        }];
        [(UIAlertController *)self.adaptiveAlert addAction:alertAction];
    } else {
        if (SFAlertControllerStyleActionSheet == self.preferredStyle) {
            UIActionSheet *actionSheet = (UIActionSheet *)self.adaptiveAlert;
            NSUInteger currentButtonIndex = [actionSheet addButtonWithTitle:action.title];
            
            if (action.style == SFAlertActionStyleDestructive) {
                actionSheet.destructiveButtonIndex = currentButtonIndex;
            } else if (action.style == SFAlertActionStyleCancel) {
                actionSheet.cancelButtonIndex = currentButtonIndex;
            }
        } else {
            UIAlertView *alertView = (UIAlertView *)self.adaptiveAlert;
            NSUInteger currentButtonIndex = [alertView addButtonWithTitle:action.title];
            if (action.style == SFAlertActionStyleCancel) {
                alertView.cancelButtonIndex = currentButtonIndex;
            }
        }
    }
}

-(void)addTextFieldWithConfigurationHandler:(void (^)(UITextField * textField))configurationHandler {
    if (IOS_VERSION_8_OR_ABOVE) {
        [(UIAlertController *)self.adaptiveAlert addTextFieldWithConfigurationHandler:configurationHandler];
    } else {
        NSAssert(self.preferredStyle == SFAlertControllerStyleAlter, @"textfield only support alter");
        self.textFieldHandlers = [[NSArray arrayWithArray:self.textFieldHandlers] arrayByAddingObject:configurationHandler];
        [(UIAlertView *)self.adaptiveAlert setAlertViewStyle: self.textFieldHandlers.count > 1? UIAlertViewStyleLoginAndPasswordInput : UIAlertViewStylePlainTextInput];
    }
}

- (NSArray<UITextField *> *)textFields
{
    if (IOS_VERSION_8_OR_ABOVE) {
        return ((UIAlertController *)self.adaptiveAlert).textFields;
    }
    else {
        if ([self.adaptiveAlert isKindOfClass:[UIAlertView class]]) {
            switch (((UIAlertView *)self.adaptiveAlert).alertViewStyle) {
                case UIAlertViewStyleDefault: {
                    return @[];
                    break;
                }
                case UIAlertViewStyleSecureTextInput: {
                    return @[[((UIAlertView *)self.adaptiveAlert) textFieldAtIndex:0]];
                    break;
                }
                case UIAlertViewStylePlainTextInput: {
                    return @[[((UIAlertView *)self.adaptiveAlert) textFieldAtIndex:0]];
                    break;
                }
                case UIAlertViewStyleLoginAndPasswordInput: {
                    return @[[((UIAlertView *)self.adaptiveAlert) textFieldAtIndex:0], [((UIAlertView *)self.adaptiveAlert) textFieldAtIndex:1]];
                    break;
                }
                default: {
                    break;
                }
            }
        }
        else {
            return nil;
        }
    }
}

#pragma mark - ActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.actions[buttonIndex]) {
        [self.actions[buttonIndex] performAction];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    self.alertController = nil;
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    self.alertController = nil;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.actions[buttonIndex]) {
        [self.actions[buttonIndex] performAction];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    self.alertController = nil;
}

- (void)alertViewCancel:(UIAlertView *)alertView
{
    self.alertController = nil;
}

#pragma mark - property

- (NSString *)title
{
    return [self.adaptiveAlert title];
}

- (void)setTitle:(NSString *)title
{
    [self.adaptiveAlert setTitle:title];
}

- (NSString *)message
{
    return [self.adaptiveAlert message];
}

- (void)setMessage:(NSString *)message
{
    [self.adaptiveAlert setMessage:message];
}

- (UIAlertViewStyle)alertViewStyle
{
    if (!(IOS_VERSION_8_OR_ABOVE) && [self.adaptiveAlert isKindOfClass:[UIAlertView class]]) {
        return [self.adaptiveAlert alertViewStyle];
    }
    return 0;
}

- (void)setAlertViewStyle:(UIAlertViewStyle)alertViewStyle
{
    if (!(IOS_VERSION_8_OR_ABOVE) && [self.adaptiveAlert isKindOfClass:[UIAlertView class]]) {
        [self.adaptiveAlert setAlertViewStyle:alertViewStyle];
    }
}

- (SFAlertAction *)preferredAction
{
    if (CurrentSystemVersion >= 9.0) {
        return (SFAlertAction *)[self.adaptiveAlert preferredAction];
    }
    return nil;
}

- (void)setPreferredAction:(SFAlertAction *)preferredAction
{
    if (CurrentSystemVersion >= 9.0) {
        [self.adaptiveAlert setPreferredAction:preferredAction];
    }
}

@end
