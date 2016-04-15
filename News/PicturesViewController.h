//
//  PicturesViewController.h
//  News
//
//  Created by ink on 15/1/28.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentViewController.h"
#import "BaseNavigationController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
@interface PicturesViewController : UIViewController<UIScrollViewDelegate,UITextViewDelegate>
{
    AFHTTPRequestOperationManager *_manager;
    MBProgressHUD *_HUD;
    NSString *_userId;
    NSString *curretIntro;
    NSString *currentTitle;
    BOOL _isLogin;
    NSString *can_comment;
#pragma mark -change by zhang
    UIView *popOverView;
    AFHTTPRequestOperationManager *_reviewManager;
    UIView *reviewView;
    UITextView *reviewTextView;
}

//=====
//是否是通过本地存储获取的数据---本地的数据
@property (assign, nonatomic) BOOL *getFileData;
@property (strong, nonatomic) NSDictionary *fileData;
//=====
@property (assign,nonatomic) BOOL isPush;
@property (strong, nonatomic) IBOutlet UIScrollView *backScrollView;
@property (strong, nonatomic) IBOutlet UIImageView *firstImageView;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIButton *commentBtn;

//新闻的列表的信息
@property (strong, nonatomic) NSDictionary  *infoDic;

- (IBAction)backBtnClicked:(id)sender;
//跟帖按钮
- (IBAction)commentBtnClicked:(id)sender;

//分享按钮
- (IBAction)shareBtnClicked:(id)sender;
//下载按钮
- (IBAction)loadBtnClicked:(id)sender;

//评论按钮
- (IBAction)commentAddClicked:(id)sender;
//收藏
- (IBAction)collectionBtnClicked:(id)sender;
@end
