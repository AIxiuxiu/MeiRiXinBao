//
//  DetailViewController.h
//  News
//
//  Created by ink on 15/1/26.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "LoginViewController.h"

#pragma mark - changeByChangpeng
#import "QuestionViewController.h"
#import "UIImageView+AFNetworking.h"
@interface DetailViewController : UIViewController<UITextViewDelegate,UIWebViewDelegate,UIActionSheetDelegate>

{
    AFHTTPRequestOperationManager *_manager;
    MBProgressHUD *_HUD;
    AFHTTPRequestOperationManager *_adManager;
    
    //评论
    NSString *_userId;
    AFHTTPRequestOperationManager *_reviewManager;
    //    UIToolbar *_toolBar;
    UIView *reviewView;
    UITextView *reviewTextView;
    NSString *can_comment;
    BOOL _isLogin;
#pragma mark -change by zhang
    UIView *popOverView;
   
}
//=====
//是否是通过本地存储获取的数据---本地的数据
@property (assign, nonatomic) BOOL *getFileData;
@property (strong, nonatomic) NSDictionary *fileData;
//=====
////日期
//@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
////标题
//@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
////图片
//@property (strong, nonatomic) IBOutlet UIImageView *imageView;
////内容
//@property (strong, nonatomic) IBOutlet UILabel *contentLabel;

@property (strong, nonatomic) IBOutlet UIWebView *webView;


@property (strong, nonatomic) IBOutlet UIScrollView *backScrollView;
//判断是否是推送
@property (assign, nonatomic) BOOL isPush;


//新闻的列表的信息
@property (strong, nonatomic) NSDictionary  *infoDic;
@property (assign, nonatomic) BOOL isWithPic;
- (IBAction)shareBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@property (strong, nonatomic) IBOutlet UIButton *reviewBtn;
- (IBAction)collectBtnClicked:(id)sender;
- (IBAction)reviewBtnClicked:(UIButton *)sender;
@end
