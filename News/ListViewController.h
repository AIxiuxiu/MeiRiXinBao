//
//  ListViewController.h
//  News
//
//  Created by ink on 15/1/14.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewListCell.h"
#import "NoPicCell.h"
#import "PicCell.h"
#import "BannerCell.h"
#import "MJRefresh.h"

#import <MapKit/MapKit.h>
@protocol listViewControllerDelegate;
@interface ListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate,BannerCellDelegate>
{
    AFHTTPRequestOperationManager *_adManager;
    AFHTTPRequestOperationManager *_manager;
    MBProgressHUD *_HUD;
    CLLocationManager *_locationManager;
    NSString *_currentCity;
    AFHTTPRequestOperationManager *_locationManger;
    BOOL refresh;
}

//@property (assign, nonatomic)NSInteger numOfVC;

@property (strong, nonatomic) NSDictionary *dict;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) id<listViewControllerDelegate> delegate;
@property (assign,nonatomic) BOOL isFirst;
//是否是最开始的页卡
@property (assign,nonatomic) BOOL isShouYe;
- (void)viewDidCurrentView;
@end





@protocol listViewControllerDelegate <NSObject>

- (void)pushToType:(NSInteger)type andObject:(id)object;

@end