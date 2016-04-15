//
//  APP_CONF.h
//  MedicineHall
//
//  Created by ink on 14/11/11.
//  Copyright (c) 2014年 ink. All rights reserved.
//

#ifndef MedicineHall_APP_CONF_h
#define MedicineHall_APP_CONF_h

#define weibo_key @"2395234916"
#define weibo_secret @"b4feb56ec00a68a1b8ccec2853a9202e"
#define weibo_redirectURL @"https://api.weibo.com/oauth2/default.html"

#define baidu_key @"r7uTaLWDMpq0DXmsGfGj8av1"

#define IPHONE5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#define RGBA(r,g,b) [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:1.0]

#define toString(v) [NSString stringWithFormat:@"%@",v]
// check whether this device is base on ios7 system.
#define IOS7      [[[UIDevice currentDevice] systemVersion] floatValue]>7
#define IOS8      [[[UIDevice currentDevice] systemVersion] floatValue]>=8
// define UIScreen Width & Height
#define SCREEN_W      [UIScreen mainScreen].bounds.size.width
#define SCREEN_H      [UIScreen mainScreen].bounds.size.height
#define USER_DEFAULT [NSUserDefaults standardUserDefaults]

#define APPDELEGATE  (AppDelegate *)[[UIApplication sharedApplication] delegate]
//===============接口================//
//页卡选项
#define kControl     @"http://news.iyousoon.com/Api/Action/label"
//首页新闻数据
#define khomeNews    @"http://news.iyousoon.com/Api/Action/homePage"
//新闻详情
#define knewsDetails @"http://news.iyousoon.com/Api/Action/newsDetails"
//登录
#define kLogin       @"http://news.iyousoon.com/Api/Action/login"
//查看跟帖
#define kComment     @"http://news.iyousoon.com/Api/Action/comment"
//收藏
#define kCollect     @"http://news.iyousoon.com/Api/Action/collect"
//添加收藏
#define kcollectAdd  @"http://news.iyousoon.com/Api/Action/collectAdd"
//修改用户头像
#define kchangeUserImage @"http://news.iyousoon.com/Api/Action/editAvatar"
//广告
#define kAdvert      @"http://news.iyousoon.com/Api/Action/advert"
//搜索
#define kSearch      @"http://news.iyousoon.com/Api/Action/search"
//修改用户昵称
#define kChangeNick  @"http://news.iyousoon.com/Api/Action/editUsername"
//求助 爆料
#define kHelpOrBao   @"http://news.iyousoon.com/Api/Action/upNews"
//意见反馈
#define kFeedBack    @"http://news.iyousoon.com/Api/Action/feedback"
//新闻投票
#define kVoteAdd     @"http://news.iyousoon.com/Api/Action/voteAdd"
//添加评论
#define kCommentAdd  @"http://news.iyousoon.com/Api/Action/commentAdd"
//推送消息
#define kMsg         @"http://news.iyousoon.com/Api/Action/pushlist"
//删除收藏
#define kDeleteCollection  @"http://news.iyousoon.com/Api/Action/collectDel"
//赞
#define kLike        @"http://news.iyousoon.com/Api/Action/like"
//举报
#define kReport      @"http://news.iyousoon.com/Api/Action/report"
//搜索热词
#define kHotkey      @"http://news.iyousoon.com/Api/Action/hotkey"
//我的跟帖
#define kMyComment   @"http://news.iyousoon.com/Api/Action/comment_talk1"
//我的回复
#define kMyBack      @"http://news.iyousoon.com/Api/Action/comment_talk2"
//离线下载
#define kDownLoad    @"http://news.iyousoon.com/Api/Action/offLineDown"
//获取城市列表
#define kGetCity     @"http://news.iyousoon.com/Api/Action/city"
//获取我的爆料和求助
#define kMyNews      @"http://news.iyousoon.com/Api/Action/myNews"
//登录
#define kLogPass     @"http://news.iyousoon.com/Api/Action/loginPass"
//注册
#define kRegister   @"http://news.iyousoon.com/Api/Action/register"


#endif
