//
//  ZhuyeViewController.h
//  News
//
//  Created by ink on 15/1/16.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTMbase64.h"
@interface ZhuyeViewController : UIViewController<UIAlertViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

{
    AFHTTPRequestOperationManager *_manager;
    UIActionSheet *_sheet;
    MBProgressHUD *_HUD;
}

//昵称
@property (strong, nonatomic) IBOutlet UILabel *nickLabel;
//头像
@property (strong, nonatomic) IBOutlet UIImageView *headImageView;


@property (strong, nonatomic) IBOutlet UIView *nickView;

@property (strong, nonatomic) IBOutlet UIView *headView;

//退出登录点击
- (IBAction)logoutBtnClicked:(id)sender;

@end
