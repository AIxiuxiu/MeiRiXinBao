//
//  Disclose ViewController.h
//  News
//
//  Created by ink on 15/1/15.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DoImagePickerController.h"
#import "GTMbase64.h"

#import "LoginViewController.h"
#import "BaseNavigationController.h"

#import "MyDiscloseViewController.h"
@interface DiscloseViewController : UIViewController<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,DoImagePickerControllerDelegate,UITextViewDelegate,UIAlertViewDelegate>

{
    UIActionSheet *_sheet;
    UIToolbar *_toolBar;
    AFHTTPRequestOperationManager *_manager;
    MBProgressHUD *_HUD;
    
    NSMutableArray *_pics;
}

//因为爆料和求助页面是差不多的，就直接复用一下
@property (assign, nonatomic) BOOL isHelp;



@property (strong, nonatomic) NSArray *aIVs;
@property (strong, nonatomic) IBOutlet UIView *backView;

@property (strong, nonatomic) IBOutlet UITextView *textView;

@property (strong, nonatomic) IBOutlet UIButton *firstBtn;
@property (strong, nonatomic) IBOutlet UIButton *secondBtn;
@property (strong, nonatomic) IBOutlet UIButton *thirdBtn;
@property (strong, nonatomic) IBOutlet UIButton *fourthBtn;
@property (strong, nonatomic) IBOutlet UIButton *fifthBtn;
@property (strong, nonatomic) IBOutlet UIButton *sixBtn;

- (IBAction)postBtnClicked:(id)sender;



@end
