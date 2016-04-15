//
//  ResignViewController.h
//  News
//
//  Created by ink on 15/5/11.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResignViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>
{
    AFHTTPRequestOperationManager *_manager;
    MBProgressHUD *_HUD;
}
@property (strong, nonatomic) IBOutlet UITextField *userNameTF;

@property (strong, nonatomic) IBOutlet UITextField *passWordTF;

@property (strong, nonatomic) IBOutlet UITextField *againPasswordTF;

@property (strong, nonatomic) IBOutlet UIButton *registerBtn;

- (IBAction)resignBtnClicked:(id)sender;

@end
