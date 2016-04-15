//
//  AppDelegate.h
//  News
//
//  Created by ink on 15/1/8.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMDrawerController.h"
#import "LeftViewController.h"
#import "RightViewController.h"

#
#import "MMDrawerVisualState.h"

#import "LoadingViewController.h"
#import "XGPush.h"
#import "XGSetting.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    AFHTTPRequestOperationManager *_manager;
}
@property (assign, nonatomic) BOOL hasPush;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MMDrawerController *silder;
@property (strong, nonatomic) LeftViewController *leftVC;
@property (strong, nonatomic) RightViewController *rightVC;
@property (strong, nonatomic) NSString *wbtoken;
@property (strong, nonatomic) NSString *wbCurrentUserID;

- (void)mainVCConfig;
- (void)XGpush:(NSDictionary *)launchOptions;
- (void)jinruXG;
@end

