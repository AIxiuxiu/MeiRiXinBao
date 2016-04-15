//
//  CenterViewController.h
//  News
//
//  Created by ink on 15/1/14.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SUNSlideSwitchView.h"
#import "MMDrawerController.h"
#import "MMDrawerController+Subclass.h"
#import "ListViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "ChannelViewController.h"
#import "BaseNavigationController.h"
//百度定位
#import "BMKLocationService.h"
#import "BMKGeocodeSearch.h"
#import "BMKGeocodeSearchOption.h"


#import "DetailViewController.h"
#import "BaseNavigationController.h"
#import "PicturesViewController.h"
//自带的定位
#import <MapKit/MapKit.h>
#import "downLoadNews.h"

@interface CenterViewController : UIViewController<SUNSlideSwitchViewDelegate,UIAlertViewDelegate,listViewControllerDelegate>
{
    AFHTTPRequestOperationManager *_ADManager;
    AFHTTPRequestOperationManager *_AFManager;
    AFHTTPRequestOperationManager *_manager;
    AFHTTPRequestOperationManager *_downLoadManager;
    CLLocationManager *_locationManager;
    CGFloat _longitude;
    CGFloat _latitude;
    MBProgressHUD *_HUD;
    UIAlertView *loadAlert;
    UILabel *_label;
}
@property (strong, nonatomic) NSArray *weartherArray;
@property (copy, nonatomic)NSString *pm25;
@property (copy,nonatomic) NSString *currentCity;
@property (strong, nonatomic) IBOutlet SUNSlideSwitchView *slideSwitchView;


@end
