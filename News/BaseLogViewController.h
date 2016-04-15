//
//  BaseLogViewController.h
//  News
//
//  Created by ink on 15/5/11.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseLogViewController : UIViewController<UITextFieldDelegate>
{
    MBProgressHUD * _HUD;
    AFHTTPRequestOperationManager *_manager;
}
@property (strong, nonatomic) IBOutlet UITextField *userNameTF;

@property (strong, nonatomic) IBOutlet UITextField *passwordTF;

@property (strong, nonatomic) IBOutlet UIButton *logBtn;

- (IBAction)logBtnClicked:(id)sender;

@end
