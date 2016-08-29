//
//  ServerPrefrenceMacros.h
//  GuoGuoLiveDev
//
//  Created by 94bank on 16/4/28.
//  Copyright © 2016年 统领得一网络科技（上海）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifdef DEBUG
//代理商ID(测试)

#define AGENT                                   @"8888"
#define MD5KEY                                  @"a1s2d3f4g5h6"
#define _HOST                                   @"http://testapi.newzhibo.cn"
//充值web页面地址
#define RechargeWeb_URL(userid)                 [NSString stringWithFormat:@"http://testpay.newzhibo.cn/ChooseMoney.aspx?userid=%@&clienttype=101",userid]
//提现
#define TakeMoney_URL(contentDes)               [NSString stringWithFormat:@"http://testpay.newzhibo.cn/NbaoChangeRmb.aspx?wSign=%@",contentDes];
//提现记录
#define TakeMoneyList_URL(contentDes)           [NSString stringWithFormat:@"http://testpay.newzhibo.cn/NbaoChangeRmbList.aspx?wSign=%@",contentDes];

#else

//代理商ID(正式)
#define AGENT                                   @"10002"
#define MD5KEY                                  @"osfi2373jdfidf"
#define _HOST                                   @"http://api.newzhibo.cn"
////提现记录
#define TakeMoneyList_URL(contentDes)           [NSString stringWithFormat:@"http://pay.newzhibo.cn/NbaoChangeRmbList.aspx?wSign=%@",contentDes];
////提现
#define TakeMoney_URL(contentDes)               [NSString stringWithFormat:@"http://pay.newzhibo.cn/NbaoChangeRmb.aspx?wSign=%@",contentDes];
////充值web页面地址
#define RechargeWeb_URL(userid)                 [NSString stringWithFormat:@"http://pay.newzhibo.cn/ChooseMoney.aspx?userid=%@&clienttype=101",userid]
#endif





#define BasicURL                                [NSString stringWithFormat:@"%@/tran.aspx",_HOST]
//上传头像
#define UpLoadImgURL                            [NSString stringWithFormat:@"%@/FileUpload.aspx",_HOST]
//推流地址
#define StreamURL(UserId,CurrentTime)           [NSString stringWithFormat:@"rtmp://newlive.uplive.ks-cdn.com/live/%@?vdoid=%@",UserId,CurrentTime]
//直播地址
#define LiveURL(UserId)                         [NSString stringWithFormat:@"rtmp://newlive.rtmplive.ks-cdn.com/live/%@",UserId]
//录播地址
#define RecodeLiveURL(userId,CurrentTime)       [NSString stringWithFormat:@"record/live/%@/hls/%@-%@.m3u8",userId,userId,CurrentTime]
//分享
#define Share_URL(userId)                       [NSString stringWithFormat:@"http://www.newzhibo.cn/share.aspx?userid=%@",userId];
//关于我们
#define AboutUs_URL                             [NSString stringWithFormat:@"http://www.newzhibo.cn/apphtml/about.html"];
//N币贡献榜
#define NMoneyContribution(userId)              [NSString stringWithFormat:@"http://www.newzhibo.cn/apphtml/rechargetop.aspx?userid=%@",userId]
//协议地址
#define ProtocolWeb_URL                         [NSString stringWithFormat:@"http://www.newzhibo.cn/AppHtml/app_privacy.html"]




#define NetworkManager [LiveNetworkManager shareInstance]

typedef NS_ENUM(NSInteger, RequestAction) {
    
    SMS_action = 140,                       //发送短信
    AuthSMSCode_action = 101,               //验证短信验证码
    LiveList_action = 117,                  //直播列表
    UserInfo_action = 107,                  //个人信息
    CreatLiveRoom_action = 132,             //创建直播间
    CloseLiveRoom_action = 138,             //关闭直播间
    ExitLiveRoom_action = 119,              //退出直播间
    MenuList_action = 116,                  //栏目列表
    BannerList_action = 147,                //banner列表
    EnterLiveRoom_action = 118,             //进入直播间
    SearchLive_action = 145,                //搜索
    ChangeUserInfo_action = 105,            //修改个人信息
    FunsList_action = 129,                  //粉丝列表
    SetFuns_action = 134,                   //设置粉丝
    CancelFuns_action = 136,                //取消粉丝
    AttentionList_action = 128,             //关注列表
    SetAttention_action = 110,              //设置关注
    CancelAttention_action = 137,           //取消关注
    BlckList_action = 109,                  //黑名单列表
    SetBackList_action = 108,               //设置黑名单
    CancelBlackList_action = 135,           //取消黑名单
    ZhuBoHistoryList_action = 126,          //主播视频列表
    Apply_action = 106,                     //申请验证
    InboxList_action = 112,                 //收件箱列表
    DeleteEmail_action = 122,               //删除邮件
    QueryN_action = 152,                    //查询N宝
    Report_action = 125,                    //举报
    FeedBack_action = 114,                  //用户反馈
    BalanceOfAccount = 144,                 //账户余额
    TakeMoneyN_action = 149,                //兑换N宝
    GetLiveInfo_action = 151,               //获取直播信息
    GiveGift_action = 121,                  //赠送礼物
    GiftList_action = 133,                  //礼物列表
    ConstraintVersionUpdate = 160,          //强制更新
    ExitLogin_action = 115,                 //退出登录
    Receipt_test=161,                       //收据验证
    payOrWithdrawCash=164,                  //充值提现
    SnsPlatLogin_action = 143,              //第三方登录(验证)
    SnsPlatLoginBlinding_action = 123,      //第三方登录(绑定)
    rerunVideoGetRoomId_action =165,        //获取重播聊天室ID
    GotoVidelListRoom_action =166,          //进入录播室
    GoOutVidelListRoom_action =167,         //退出录播室
    GetCountOfVidelRoom_action =168,        //获取录播室人数
    GetADData_action = 170,                 //广告接口
    CancelManager_action = 173,             //取消管理员
    SetManager_action = 172,                //设置管理员
    ManagerList_action = 174,               //管理员列表
    CreateOrder_action = 175,               //生成订单
    NewReceipt_action = 176,                //充值新接口
    DelecteOldVideo_action=183,             //删除往期视频
    ForbidPlayerGetMoney_action = 184,      //禁止家族主播提现
    VerifyLiveSecret_action = 186,      //直播间密码验证
    SendBarrage_action = 185,           //发送弹幕
};
