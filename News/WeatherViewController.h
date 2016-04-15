//
//  WeatherViewController.h
//  News
//
//  Created by ink on 15/1/22.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CityViewController.h"
#import "BaseNavigationController.h"
@interface WeatherViewController : UIViewController<CityViewControllerDelegate>
{
    AFHTTPRequestOperationManager *_manager;
    CityViewController *cityVC;
}
@property (strong, nonatomic) IBOutlet UIButton *cityBtn;
@property (strong, nonatomic) IBOutlet UILabel *todayDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *nowTemLabel;
@property (strong, nonatomic) IBOutlet UILabel *weatherLabel;
@property (strong, nonatomic) IBOutlet UIImageView *weatherImageView;
@property (strong, nonatomic) IBOutlet UIButton *PM25Btn;
@property (strong, nonatomic) IBOutlet UILabel *windLabel;
@property (strong, nonatomic) IBOutlet UILabel *firstDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *thirdDateLabel;
@property (strong, nonatomic) IBOutlet UIImageView *firstImageView;
@property (strong, nonatomic) IBOutlet UIImageView *secondImageView;
@property (strong, nonatomic) IBOutlet UIImageView *thirdImageView;
@property (strong, nonatomic) IBOutlet UILabel *firstTemLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondTemLabel;
@property (strong, nonatomic) IBOutlet UILabel *thirdTemLabel;
- (IBAction)cityBtnClicked:(id)sender;

@property (copy, nonatomic) NSString *currentCity;


- (IBAction)backBtnClicked:(id)sender;

@end
