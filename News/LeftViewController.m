//
//  LeftViewController.m
//  News
//
//  Created by ink on 15/1/14.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import "LeftViewController.h"
#import "CenterViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "AppDelegate.h"
@interface LeftViewController ()
{
    CenterViewController *center;
}
@end

@implementation LeftViewController
- (instancetype)init {
    if (self=[super init]) {
        center = [[CenterViewController alloc] init];
        self.centerVC = [[BaseNavigationController alloc] initWithRootViewController:center];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *tuisongOff = [USER_DEFAULT objectForKey:@"tuisongOff"];
    if (tuisongOff) {
        self.pushBtn.selected = YES;
    }
    [self addGesture];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weartherShow:) name:@"showWeather" object:nil];
    // Do any additional setup after loading the view from its nib.
}
- (void)weartherShow:(NSNotification *)notification {
    NSDictionary *dic = (NSDictionary *)notification.object;
    if (!dic) {
        self.cityLabel.text = @"定位失败...";
        return;
    }
    NSLog(@"==%@",dic);
    NSString *city = [dic objectForKey:@"city"];
    NSArray *weathers = [dic objectForKey:@"weartherArray"];
    NSDictionary *today = [weathers objectAtIndex:0];
    NSString *temperature = [today objectForKey:@"temperature"];
    self.cityLabel.text = city;
    self.temperatureLabel.text = temperature;
}
#pragma mark - 添加点击手势
- (void)addGesture {
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClicked:)];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClicked:)];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClicked:)];
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClicked:)];
    [self.weatherView addGestureRecognizer:tap1];
    [self.searchView  addGestureRecognizer:tap2];
    [self.setView     addGestureRecognizer:tap3];
    [self.offLineLoadView    addGestureRecognizer:tap4];
}
- (void)viewClicked:(UITapGestureRecognizer *)tap {
    UIView *view = [tap view];
    if (view == self.weatherView) {
        WeatherViewController *weatherVC = [[WeatherViewController alloc] init];
//        BaseNavigationController *baseNav = [[BaseNavigationController alloc] initWithRootViewController:weatherVC];
        if ([self.cityLabel.text isEqualToString:@"定位失败..."]||[self.cityLabel.text isEqualToString:@"正在定位..."]) {
            weatherVC.currentCity = @"天津市";
        }else {
            weatherVC.currentCity = self.cityLabel.text;
        }
        weatherVC.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
        [self presentViewController:weatherVC animated:YES completion:^{
            
        }];
    }else if (view == self.searchView) {
        NSLog(@"这里是搜索的view");
        
        SearchViewController *searchVC = [[SearchViewController alloc] init];
        BaseNavigationController *baseNav = [[BaseNavigationController alloc] initWithRootViewController:searchVC];
        baseNav.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
        [self presentViewController:baseNav animated:YES completion:^{
            
        }];
    }else if (view == self.setView) {
        SettingViewController *setVC = [[SettingViewController alloc] init];
        BaseNavigationController *baseNav = [[BaseNavigationController alloc] initWithRootViewController:setVC];
        baseNav.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
        [self presentViewController:baseNav animated:YES completion:^{
            
        }];
    }else if (view == self.offLineLoadView) {
        [self loadViewClicked];
    }
}
#pragma mark - 推送按钮点击
- (IBAction)pushBtnClicked:(id)sender {
    self.pushBtn.selected = !self.pushBtn.selected;
    if (self.pushBtn.selected == NO) {
        [XGPush initForReregister:^{
            NSLog(@"成功注册设备");
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate XGpush:nil];
            [USER_DEFAULT setObject:nil forKey:@"tuisongOff"];
        }];
    }else {
        [XGPush unRegisterDevice];
        [USER_DEFAULT setObject:@"yes" forKey:@"tuisongOff"];
    }
}
//#pragma mark - 下载按钮点击
//- (IBAction)loadBtnClicked:(id)sender {
//    self.loadBtn.selected = !self.loadBtn.selected;
//}


- (void)loadViewClicked {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"downLoadNews" object:nil];
    [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
