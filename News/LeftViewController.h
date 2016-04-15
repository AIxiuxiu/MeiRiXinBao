//
//  LeftViewController.h
//  News
//
//  Created by ink on 15/1/14.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"

#import "SettingViewController.h"

#import "WeatherViewController.h"
#import "SearchViewController.h"
#import "UIViewController+MMDrawerController.h"

#import "XGPush.h"
@interface LeftViewController : UIViewController


@property (nonatomic,strong) BaseNavigationController *centerVC;


@property (strong, nonatomic) IBOutlet UIView *weatherView;//天气的view
@property (strong, nonatomic) IBOutlet UILabel *cityLabel;//城市label
@property (strong, nonatomic) IBOutlet UILabel *temperatureLabel;//温度label

@property (strong, nonatomic) IBOutlet UIView *searchView;//搜索view

@property (strong, nonatomic) IBOutlet UIView *setView;//设置View
@property (strong, nonatomic) IBOutlet UIView *offLineLoadView;//离线View
@property (strong, nonatomic) IBOutlet UIButton *pushBtn;//推送的按钮
//@property (strong, nonatomic) IBOutlet UIButton *loadBtn;//下载按钮
//推送按钮点击事件
- (IBAction)pushBtnClicked:(id)sender;
////下载按钮点击事件
//- (IBAction)loadBtnClicked:(id)sender;





@end
