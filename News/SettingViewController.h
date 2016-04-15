//
//  SettingViewController.h
//  News
//
//  Created by ink on 15/1/15.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FontViewController.h"
#import "YijianViewController.h"
#import "BaseNavigationController.h"
#import "AboutUsViewController.h"
@interface SettingViewController : UIViewController<FontViewControllerDelegate,UIAlertViewDelegate>
{
    FontViewController *_fontVC;
}
//字体view
@property (strong, nonatomic) IBOutlet UIView *fontView;
//缓存view
@property (strong, nonatomic) IBOutlet UIView *cachView;
//意见反馈
@property (strong, nonatomic) IBOutlet UIView *adviceBackView;
//关于
@property (strong, nonatomic) IBOutlet UIView *aboutView;
///////////////
@property (strong, nonatomic) IBOutlet UILabel *fontLabel;
@property (strong, nonatomic) IBOutlet UIButton *autoLoadBtn;
@property (strong, nonatomic) IBOutlet UIButton *loadPicBtn;


- (IBAction)wifiLoadBtnClicked:(id)sender;

- (IBAction)noWifiNopicBtnClicked:(id)sender;



@end
