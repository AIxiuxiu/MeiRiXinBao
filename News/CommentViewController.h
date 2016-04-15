//
//  CommentViewController.h
//  News
//
//  Created by ink on 15/1/30.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SectionView.h"
#import "CommentCell.h"

#import "DXPopover.h"
@interface CommentViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,SectionViewDelegate,UITextViewDelegate,UIActionSheetDelegate,UIGestureRecognizerDelegate>
{
    AFHTTPRequestOperationManager *_manager;
    
    //回复
    NSString *_userId;
    MBProgressHUD *_HUD;
    AFHTTPRequestOperationManager *_reviewManager;
#pragma mark -change by zhang
    UIView *popOverView;
    
    UIView *reviewView;
    UITextView *reviewTextView;
    //    NSString *_Id;
    NSString *_replyId;
    
#pragma mark -change by zhang
    //举报
    NSString *reportType;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
//新闻的id
@property (copy, nonatomic) NSString *newsId;
//是否从图片页面进来的
@property (assign, nonatomic) BOOL isFromPic;
//pop出的选择回复的view
//@property (nonatomic, strong) PopupListComponent* activePopup;


#pragma mark -change by zhang
//举报
@property (strong, nonatomic) IBOutlet UIView *reportView;
@property (strong, nonatomic) IBOutlet UILabel *reportLabel;
@property (strong, nonatomic) IBOutlet UIButton *qiPianBtn;//欺骗
@property (strong, nonatomic) IBOutlet UIButton *seQingBtn;//色情
@property (strong, nonatomic) IBOutlet UIButton *gongJiBtn;//攻击
@property (strong, nonatomic) IBOutlet UIButton *qiTaBtn;//其它
@property (strong, nonatomic) IBOutlet UIButton *quedingBtn;
@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;


//- (IBAction)qiPianClicked:(UIButton *)sender;
//- (IBAction)seQingClicked:(id)sender;
//- (IBAction)goongJiClicked:(UIButton *)sender;
//- (IBAction)qiTaClicked:(UIButton *)sender;
- (IBAction)quedingClicked:(UIButton *)sender;
- (IBAction)cancelBtnClicked:(UIButton *)sender;
@end
