//
//  MyCommentViewController.h
//  News
//
//  Created by ink on 15/2/13.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyBackCell.h"
#import "CommentViewController.h"
#import "MJRefresh.h"
#import "MsgBackView.h"

#import "BaseNavigationController.h"
#import "DetailViewController.h"
#import "PicturesViewController.h"
@interface MyCommentViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MyBackCellDelegate,MsgBackDelegate,UITextViewDelegate>
{
    AFHTTPRequestOperationManager *_manager;
    MsgBackView *_secondView;
    
    ///
    AFHTTPRequestOperationManager *_reviewManager;
    MBProgressHUD *_HUD;
    UIView *popOverView;
    UIView *reviewView;
    UITextView *reviewTextView;
    ///
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
//选择器的view
@property (strong, nonatomic) IBOutlet UIView *segView;
//选择器
@property (strong, nonatomic) IBOutlet UISegmentedControl *selectSeg;

- (IBAction)selectSegChange:(id)sender;


@end


