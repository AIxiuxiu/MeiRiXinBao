//
//  YijianViewController.h
//  Part-time job easy
//
//  Created by ink on 14-8-22.
//  Copyright (c) 2014年 ink. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MBProgressHUD.h"
@interface YijianViewController : UIViewController<UITextViewDelegate,MBProgressHUDDelegate,UITextFieldDelegate,UIAlertViewDelegate>
{
    MBProgressHUD *_HUD;
    AFHTTPRequestOperationManager *_manager;
}
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UITextField *teleTextField;
- (IBAction)sendButtonClicked:(id)sender;

@end
