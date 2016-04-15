//
//  LoginViewController.h
//  News
//
//  Created by ink on 15/1/19.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShareSDK/ShareSDK.h>
#import "BaseLogViewController.h"
#import "ResignViewController.h"
@interface LoginViewController : UIViewController
{
    
    
}
/**
 *登录
 */
@property (strong, nonatomic) IBOutlet UIButton *logBtn;

- (IBAction)loginBtnClicked:(id)sender;
/**
 *注册
 */
@property (strong, nonatomic) IBOutlet UIButton *registerBtn;

- (IBAction)resignBtnClicked:(id)sender;
/**
 *sina
 */
@property (weak, nonatomic) IBOutlet UIButton *weiboBtn;
- (IBAction)weiboBtnClicked:(id)sender;
/**
 *QQ
 */
@property (weak, nonatomic) IBOutlet UIButton *qqBtn;
- (IBAction)qqBtnClicked:(id)sender;



@end
