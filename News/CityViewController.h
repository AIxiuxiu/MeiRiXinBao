//
//  CityViewController.h
//  News
//
//  Created by ink on 15/2/27.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CityViewControllerDelegate;
@interface CityViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    AFHTTPRequestOperationManager *_manager;
}
@property (strong, nonatomic) NSMutableData *receiveData;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) id<CityViewControllerDelegate>delegate;
@end


@protocol CityViewControllerDelegate <NSObject>

- (void)selectCity:(NSString *)cityName;

@end