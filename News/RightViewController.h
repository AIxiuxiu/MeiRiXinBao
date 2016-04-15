//
//  RightViewController.h
//  News
//
//  Created by ink on 15/1/14.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiscloseViewController.h"
#import "BaseNavigationController.h"

#import "ZhuyeViewController.h"
#import "LoginViewController.h"
#import "CollectionViewController.h"
#import "RecordViewController.h"
#import "DrawViewController.h"
#import "MyCommentViewController.h"
@interface RightViewController : UIViewController
/*
 因为变动删掉了参与调查的view，但是操作简单 参与调查的view 就是抽奖的view，将抽奖的view直接隐藏了
*/
@property (strong, nonatomic) IBOutlet UIView *discloseView;//我的爆料
@property (strong, nonatomic) IBOutlet UIView *helpView;//我的求助
@property (strong, nonatomic) IBOutlet UIView *researchView;//参与调查
@property (strong, nonatomic) IBOutlet UIView *voteView;//参与抽奖
@property (strong, nonatomic) IBOutlet UIImageView *headImageView;//显示头像
@property (strong, nonatomic) IBOutlet UIButton *nickBtn;//显示用户昵称


//消息
- (IBAction)messageBtnClicked:(id)sender;
//跟帖
- (IBAction)commentBtnClicked:(id)sender;
//收藏
- (IBAction)collectBtnClicked:(id)sender;
//登录
- (IBAction)loginBtnClicked:(id)sender;
@end
