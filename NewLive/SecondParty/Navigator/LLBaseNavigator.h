//
//  LLBaseNavigator.h
//  LiuLianLib
//
//  Created by BlackDev on 12/16/14.
//  Copyright (c) 2014 SF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLNavigatorProtocol.h"
#import "LLViewDataModel.h"
#import "LLViewMap.h"
#import "CDVWebViewController.h"

/*!
 @class
 @abstract      页面导航器，用于页面跳转等控制
 @discussion    使用方法：
 1.需要导航的类的要实现LLNavigatorProtocol协议；
 2.在viewmap.plist中进行viewcontroller相关配置；
 3.配置用于跳转到的url（具体见pms.ipo.com）；
 4.使用时有两种方法，a.根据配置的跳转url进行跳转；
 b.直接调用pushViewControllerWithViewDataModel:方法；
 5.统一起见，建议使用url进行跳转；
 */
@interface LLBaseNavigator : NSObject

/*!
 @property
 @abstract      window，默认是系统的keywindow，若没有，则创建一个，用来
 承载导航堆栈
 */
@property (nonatomic, strong)   UIWindow          *window;
/*!
 @property
 @abstract      window的根viewcontroller
 */
@property (nonatomic, strong)   UIViewController  *rootViewController;
/*!
 @property
 @abstract      导航堆栈中最上面的viewcontroller
 */
@property (nonatomic, readonly) UIViewController  *topViewController;
/*!
 @property
 @abstract      当前可视的viewcontroller
 */
@property (nonatomic, readonly) UIViewController  *visibleViewController;

/*!
 @property
 @abstract      存放viewcontroller相关信息,key是viewcontroller对象的identifier，
 value是LLViewDataModel对象
 */
@property (nonatomic, copy, readonly)   NSDictionary *viewModalDict;


// 单例
//DEF_SINGLETON(LLBaseNavigator)

/*!
 @method
 @abstract      设置rootviewcontroller
 */
- (void)setupRootViewController:(UIViewController *)rootViewController;

/*!
 @method
 @abstract      返回一个view datamodel对象，应调用此方法获取viewdatamodel，而不是直接alloc LLViewDataModel
 @param         identifier: view 标识，每个viewcontroller都对应一个identifier，通过这个找到
 相应的viewcontroller
 @discussion    获取到viewdatamodel对象之后，需要对其进行配置，比如初始化方法参数，实例方法参数,具体方法可以参考
 LLNavigatorProtocol
 @link          LLNavigatorProtocol
 @return        LLViewDataModel,对应的view datamodel
 */
- (LLViewDataModel *)viewDataModelForIdentifier:(NSString *)identifier;

/*!
 @method
 @abstract      检查URL是否在白名单中
 @param         url: url
 @return        bool
 */
- (BOOL)isURLInWhiteList:(NSString *)url;

/*!
 @method
 @abstract      检查URL是否在黑名单中
 @param         url: url
 @return        bool
 */
- (BOOL)isURLInBlackList:(NSString *)url;

/*!
 @method
 @abstract      检查URL是否在可在浏览器打开的名单中
 @param         url: url
 @return        bool
 */
- (BOOL)isURLInBrowseList:(NSString *)url;
/*!
 @method
 @abstract      根据viewDataModel配置进入一个新的viewcontroller页面
 @param         viewDataModel: viewcontroller配置对象
 @param         animated: 是否需要页面切换动画
 @return        生成的viewcontroller对象
 */
- (UIViewController *)pushViewControllerWithViewDataModel:(LLViewDataModel *)viewDataModel propertyDict:(NSDictionary *)propertyDict animated:(BOOL)animated;

/*!
 @method
 @abstract      根据viewDataModel配置进入一个新的viewcontroller页面
 @param         viewDataModel: viewcontroller配置对象
 @param         retrospect: 是否回溯，若为YES,那么会先判断导航堆栈中是否已存在此类的对象，若存在，则直接跳转到
 这个viewcontroller；否则，新建一个viewcontroller，然后跳转过去；
 @param         animated: 是否需要页面切换动画
 @return        生成的viewcontroller对象
 */
- (UIViewController *)pushViewControllerWithViewDataModel:(LLViewDataModel *)viewDataModel propertyDict:(NSDictionary *)propertyDict retrospect:(BOOL)retrospect animated:(BOOL)animated;


// base method
- (void)configObject:(NSObject *)object withViewDataModel:(LLViewDataModel *)viewDataModel propertyDict:(NSDictionary *)propertyDict shouldCallInitMethod:(BOOL)shouldCallInitMethod;

/**
 *  重新读取viewmap
 */
- (void)rereadViewControllerConfigurations;

/**
 *  判断队列里是否已有identifier
 */
- (BOOL)canPopToIdentifier:(NSString *)identifier;

@end


@interface LLBaseNavigator (LLViewController)

/*!
 @method
 @abstract      退当前导航栈
 */
- (void)viewExit:(NSDictionary *)query;

/*!
 @method
 @abstract      退到root页面
 */
- (void)popToRoot:(NSDictionary *)query;

@end