//
//  LLViewMap.h
//  LiuLianLib
//
//  Created by BlackDev on 12/16/14.
//  Copyright (c) 2014 SF. All rights reserved.
//

#ifndef LiuLianLib_LLViewMap_h
#define LiuLianLib_LLViewMap_h


#define APPURL_HOST_VIEW                                                @"view"
#define APPURL_HOST_SERVICE                                             @"service"

// 参数，是否回溯
#define APPURL_PARAM_RETROSPECT                                         @"_retrospect"
// 参数，是否需要切换效果
#define APPURL_PARAM_ANIMATED                                           @"_animated"

#pragma mark - --------------------- SERVICE ---------------------

// 退出当前页面()
#define APPURL_SERVICE_IDENTIFIER_VIEWEXIT                              @"viewExit"
// 退到root页面
#define APPURL_SERVICE_IDENTIFIER_POPTOROOT                             @"popToRoot"

// webview
#define APPURL_VIEW_IDENTIFIER_WEBVIEW                                  @"webview"

#pragma mark - --------------------- VIEW ------------------------

// splash
#define APPURL_VIEW_IDENTIFIER_SPLASH                                   @"splash"
// Tab
#define APPURL_VIEW_IDENTIFIER_TAB                                      @"maintab"
// 商城首页
#define APPURL_VIEW_IDENTIFIER_INDEX                                    @"index"
// 海淘发现
#define APPURL_VIEW_IDENTIFIER_THEMEINDEX                               @"themeindex"
// 发现列表
#define APPURL_VIEW_IDENTIFIER_THEMELIST                                @"themelist"
// 发现详情
#define APPURL_VIEW_IDENTIFIER_THEMEDETAIL                              @"themedetail"
// 检索结果
#define APPURL_VIEW_IDENTIFIER_THEMESEARCH                              @"themesearch"
// 标签聚合
#define APPURL_VIEW_IDENTIFIER_THEMETAGS                                @"themetags"
// 评论列表页面
#define APPURL_VIEW_IDENTIFIER_COMMENTLIST                              @"commentlist"
// 回复列表页面
#define APPURL_VIEW_IDENTIFIER_REPLAYLIST                               @"replaylist"
// 我的订单
#define APPURL_VIEW_IDENTIFIER_MYORDER                                  @"orderlist"
// 创建订单
#define APPURL_VIEW_IDENTIFIER_ORDERSUBMIT                              @"order"
// 订单详情
#define APPURL_VIEW_IDENTIFIER_ORDERDETAIL                              @"orderdetail"
// 优惠券
#define APPURL_VIEW_IDENTIFIER_COUPON                                   @"coupon"
// 我的评论
#define APPURL_VIEW_IDENTIFIER_MYCOMMENT                                @"mycomment"
// 我的发现
#define APPURL_VIEW_IDENTIFIER_MYTHEME                                  @"mytheme"
// 地址管理
#define APPURL_VIEW_IDENTIFIER_ADDRESSMANAGE                            @"recaddrmanage"
// 设置
#define APPURL_VIEW_IDENTIFIER_SETTING                                  @"setting"
// 我的收藏
#define APPURL_VIEW_IDENTIFIER_MYLOVE                                   @"mylove"
// 我的关注商品
#define APPURL_VIEW_IDENTIFIER_MYCOLLECTED                              @"mycollected"
// 我关注的品牌
#define APPURL_VIEW_IDENTIFIER_MYBRANDLIST                              @"mybrandlist"
// 物流详情
#define APPURL_VIEW_IDENTIFIER_LOGISTICS                                @"logistics"
// 购物车
#define APPURL_VIEW_IDENTIFIER_SHOPPINGCART                             @"shoppingcart"
// 用户中心
#define APPURL_VIEW_IDENTIFIER_CENTER                                   @"center"
// 关于我们
#define APPURL_VIEW_IDENTIFIER_ABOUTUS                                  @"aboutus"
// 关于App
#define APPURL_VIEW_IDENTIFIER_ABOUTAPP                                 @"aboutapp"
// 用户协议
#define APPURL_VIEW_IDENTIFIER_LICENSEAGREEMENT                         @"licenseagreement"
// 选择收货地址
#define APPURL_VIEW_IDENTIFIER_ADDRSELECT                                @"selectaddress"
// 收货地址列表
#define APPURL_VIEW_IDENTIFIER_ADDRLIST                                  @"recaddrmanage"
// 收货地址详情
#define APPURL_VIEW_IDENTIFIER_ADDRDETAIL                                @"addressdetail"
// 收货地址编辑
#define APPURL_VIEW_IDENTIFIER_ADDREDIT                                  @"addressedit"
// 商品详情
#define APPURL_VIEW_IDENTIFIER_PRODUCTDETAIL                             @"detail"
// 品牌详情
#define APPURL_VIEW_IDENTIFIER_BRANDDETAIL                               @"brandStory"
// 活动详情
#define APPURL_VIEW_IDENTIFIER_ACTIVITYDETAIL                            @"activityground"
// 商品图文详情
#define APPURL_VIEW_IDENTIFIER_PRODUCTDESC                               @"detaildesc"
// 分享红包
#define APPURL_VIEW_IDENTIFIER_LUCKYMONEYSHARE                           @"luckymoneyshare"
// 老带新
#define APPURL_VIEW_IDENTIFIER_INVITATION                                @"invitation"
// 老带新规则页面
#define APPURL_VIEW_IDENTIFIER_INVITATIONRULE                            @"helpcenter-invitation"
// 介绍给朋友
#define APPURL_VIEW_IDENTIFIER_INVITATEFRIEND                            @"inviteFriend"
// 我的积分
#define APPURL_VIEW_IDENTIFIER_MYPOINT                                   @"mypoint"
// 去支付
#define APPURL_VIEW_IDENTIFIER_GOTOPAY                                   @"gotopay"
// 物流详情
#define APPURL_VIEW_IDENTIFIER_LOGISICS                                  @"logistics"
// 配送时效
#define APPURL_VIEW_IDENTIFIER_SHIPPINGAGING                             @"shipping-aging"
// 配送时效
#define APPURL_VIEW_IDENTIFIER_SIGNRULE                                  @"sign-rule"

// 检索
#define APPURL_VIEW_IDENTIFIER_SEARCHGATE                                @"searchgate"
// 支付成功
#define APPURL_VIEW_IDENTIFIER_PAYSUCCESS                                @"pay-success"

// 发表评价
#define APPURL_VIEW_IDENTIFIER_COMMNETGOODS                              @"commentgoods"
// 评价列表
#define APPURL_VIEW_IDENTIFIER_COMMNETGOODSLIST                          @"commentgoodslist"
// 返还税金
#define APPURL_VIEW_IDENTIFIER_RETURNTAX                                 @"refundtax"

// 检索
#define APPURL_VIEW_IDENTIFIER_SEARCHGATE                                 @"searchgate"

// 检索
#define APPURL_VIEW_IDENTIFIER_SEARCH                                     @"search"
#define APPURL_VIEW_IDENTIFIER_SEARCHV2                                   @"searchv2"

// 活动
#define APPURL_VIEW_IDENTIFIER_ACTIVITY                                   @"activity"

// 原滋原味
#define APPURL_VIEW_IDENTIFIER_Y                                          @"y"
//福利社
#define APPURL_VIEW_IDENTIFIER_WELFARE                                    @"welfare"
//扫一扫
#define APPURL_VIEW_IDENTIFIER_SCANCODE                                   @"scanner"
//搭配购商品列表
#define APPURL_VIEW_IDENTIFIER_COLLOCATION                                @"collocation"

//app推广
#define APPURL_VIEW_IDENTIFIER_OTHER_APP                                  @"other/app"

//分享红包
#define APPURL_VIEW_IDENTIFIER_INVITATION_BAG                             @"invitation-bag"

//服务说明
#define APPURL_VIEW_IDENTIFIER_SERVICE                                    @"other/service"

//活动
#define APPURL_VIEW_IDENTIFIER_PROMO                                      @"activity/831"

//联系客服
#define APPURL_VIEW_IDENTIFIER_CONTACT_SEAVICE                            @"activity/871"

// 个人委托协议
#define APPURL_VIEW_IDENTIFIER_CONTACT_TRUSTAGREEMENT                     @"service-agreement"

// 登录
#define APPURL_VIEW_IDENTIFIER_LOGIN                                      @"login"

// 注册
#define APPURL_VIEW_IDENTIFIER_REGISTERR                                  @"register"

// 设置密码
#define APPURL_VIEW_IDENTIFIER_RETRIEVE                                   @"retrieve"

// 自助服务
#define APPURL_VIEW_IDENTIFIER_ORDER_SERVICE                              @"order/service"

// 退货／售后
#define APPURL_VIEW_IDENTIFIER_ORDER_REFUND                              @"order/service-orderlist"

// 留言
#define APPURL_VIEW_IDENTIFIER_FEED_BACK                                 @"activity/1553"

// 预售全款规则
#define APPURL_VIEW_IDENTIFIER_FULL_PRESALE_RULE                         @"activity/1726"

// 预售规则
#define APPURL_VIEW_IDENTIFIER_PRESALE_RULE                              @"activity/1727"

// 有趣搜索活动
#define APPURL_VIEW_IDENTIFIER_THEME_ACTVITY                              @"activity/1790"

// 我的粉丝
#define APPURL_VIEW_IDENTIFIER_THEMEMYFANS                                @"thememyfans"

// 我的关注用户列表
#define APPURL_VIEW_IDENTIFIER_THEMEMYFOLLOWS                             @"thememyfollows"

// 消息中心
#define APPURL_VIEW_IDENTIFIER_MSGCENTER                                  @"msgcenter"

// 消息中心
#define APPURL_VIEW_IDENTIFIER_MSGLIST                                    @"msglist"
// 我的关注用户列表
#define APPURL_VIEW_IDENTIFIER_THEMEHOMEPAGE                             @"themehomepage"
//我的发现评论列表
#define APPURL_VIEW_IDENTIFIER_THEMECOMMENTLIST                          @"thememycommentlist"

//品牌
#define APPURL_VIEW_IDENTIFIER_SEARCHBRAND                               @"activity/1979"

// 申请售后
#define APPURL_VIEW_IDENTIFIER_ORDER_SALESSERVICE                        @"order/service-returngoods"

// 申请售后
#define APPURL_VIEW_IDENTIFIER_THEME_RANKING                             @"themeranking"

// 经验值明细
#define APPURL_VIEW_IDENTIFIER_THEME_EMPIRIC                             @"themeexpdetail"

// 邀请有礼
#define APPURL_VIEW_IDENTIFIER_USER_INVITAIONASKFD                       @"invitationAskfd"

// 有趣达人规则
#define APPURL_VIEW_IDENTIFIER_THEME_USER_RURE                           @"activity/2231"

// 修改昵称
#define APPURL_VIEW_IDENTIFIER_EDIT_NICK                                 @"modifynick"

// 主题图片浏览
#define APPURL_VIEW_IDENTIFIER_IMAGE_BROWSE                              @"imagebrowse"

// 发表有趣
#define APPURL_VIEW_IDENTIFIER_THEMEPUBLISH                              @"themepublish"

// 图片修改
#define APPURL_VIEW_IDENTIFIER_IMAGE_EDIT                                @"imageedit"

// 图片滤镜
#define APPURL_VIEW_IDENTIFIER_IMAGE_FILTER                              @"imagefilter"

// 图片裁剪
#define APPURL_VIEW_IDENTIFIER_IMAGE_CROP                                @"imagecrop"

// 图片浏览
#define APPURL_VIEW_IDENTIFIER_IMAGE_PREVIEW                             @"imagepreview"

// 拍照
#define APPURL_VIEW_IDENTIFIER_TAKEPHOTOS                                @"takephotos"

// 发表有趣添加标签
#define APPURL_VIEW_IDENTIFIER_THEME_ADD_TAG                             @"themeaddtag"

// 发表有趣添加品牌
#define APPURL_VIEW_IDENTIFIER_THEME_BRAND_EDIT                          @"themebrandtag"

// 发表有趣添加地点
#define APPURL_VIEW_IDENTIFIER_THEME_ADDRESS_EDIT                        @"themeaddresstag"

// 发表有趣添加图片标签
#define APPURL_VIEW_IDENTIFIER_THEME_IMAGE_TAG                           @"themeimagetag"

// 发表有趣从订单选择
#define APPURL_VIEW_IDENTIFIER_THEME_SELECT_ORDER                        @"themeselectorder"

// 发表有趣从搜索选择
#define APPURL_VIEW_IDENTIFIER_THEME_SELECT_GOODS                        @"themeselectgoods"

// 发表有趣草稿
#define APPURL_VIEW_IDENTIFIER_THEME_DRAFT                               @"themedraft"
// 有趣会员等级
#define APPURL_VIEW_IDENTIFIER_THEME_USER_Grade                           @"activity/2784"

// 砍价团详情
#define APPURL_VIEW_IDENTIFIER_ORDER_GROUPDETAIL                         @"groupPromotionDetails"

// 砍价团列表
#define APPURL_VIEW_IDENTIFIER_GROUP_PROMOTION_LIST                      @"groupPromotionList"

// 砍价团详情
#define APPURL_VIEW_IDENTIFIER_GROUP_PROMOTION_DETAIL                    @"groupPromotionDetails"


// 商品评价成功后
#define APPURL_VIEW_IDENTIFIER_COMMENTGOOD_SUCCESS                        @"commentgoodsuccess"

// 商品详情领取优惠券
#define APPURL_VIEW_IDENTIFIER_PRODUCT_COUPONS                            @"productcoupons"

// 签到领积分
#define APPURL_VIEW_IDENTIFIER_ACTIVITY_SIGN                              @"activity/3525"

#endif
