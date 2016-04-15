//
//  WeatherViewController.m
//  News
//
//  Created by ink on 15/1/22.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import "WeatherViewController.h"

@interface WeatherViewController ()
{
    NSArray *weatherArray;
    NSString *pm25;
}
@end

@implementation WeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.PM25Btn.backgroundColor = [UIColor colorWithRed:0.60f green:0.80f blue:0.20f alpha:1.00f];
    [self.PM25Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self UIConfig];
    [self getWeatherInfo];
    // Do any additional setup after loading the view from its nib.
}
- (void)getWeatherInfo {
    if (_manager) {
        _manager = nil;
    }
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//如果报接口类型不一致请替换
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *dic  = @{@"location":_currentCity,
                           @"output":@"json",
                           @"ak":baidu_key,
                           @"mcode":@"com.iyoudoo.News"};
    
    [_manager GET:@"http://api.map.baidu.com/telematics/v3/weather" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"===%@",responseObject);
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([[result objectForKey:@"error"] intValue] == 0) {
            NSArray *array = [result objectForKey:@"results"];
            NSDictionary *dictionary = [array objectAtIndex:0];
            weatherArray = (NSArray *)[dictionary objectForKey:@"weather_data"];
            pm25 = [dictionary objectForKey:@"pm25"];
            //            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weartherShow:) name:@"showWeather" object:nil];
            NSDictionary *dict = @{@"city":_currentCity,
                                   @"weartherArray":weatherArray,
                                   @"pm25":pm25};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showWeather" object:dict];
            [self fillData];
        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取天气信息失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error :%@",error.description);
    }];

}
- (void)fillData {
    NSDictionary *weatherDic = @{@"多云":@"cloudy_day",
                                 @"雾":@"fog_day",
                                 @"雨夹雪":@"rain_snow",
                                 @"大雨":@"heavy_rain",
                                 @"雷雨":@"thunderstorm_day",
                                 @"大雪":@"heavy_snow",
                                 @"雨":@"rain_day",
                                 @"小雨转晴":@"shower_day",
                                 @"冰雹":@"Sleet_day",
                                 @"雨加冰雹":@"Sleet_rain_day",
                                 @"雪":@"snow_day",
                                 @"晴":@"sunny_day",
                                 @"风":@"wind_day"};
    [self.cityBtn setTitle:_currentCity forState:UIControlStateNormal];
    NSDictionary *today = [weatherArray objectAtIndex:0];
    NSString *todayDate = (NSString *)[today objectForKey:@"date"];
   NSArray *dates = [todayDate componentsSeparatedByString:@"("];
    NSString *date2 = [dates lastObject];
    NSString *nowTem = [date2 stringByReplacingOccurrencesOfString:@")" withString:@""];
    
    self.todayDateLabel.text = (NSString *)[dates objectAtIndex:0];
    self.nowTemLabel.text = nowTem;
    
    self.weatherLabel.text = [NSString stringWithFormat:@"%@ %@",[today objectForKey:@"weather"],[today objectForKey:@"temperature"]];
    [self.PM25Btn setTitle:pm25 forState:UIControlStateNormal];
    self.windLabel.text = (NSString *)[today objectForKey:@"wind"];
    
    NSDictionary *first  = [weatherArray objectAtIndex:1];
    NSDictionary *second = [weatherArray objectAtIndex:2];
    NSDictionary *third  = [weatherArray objectAtIndex:3];
    
    self.firstDateLabel.text = [first objectForKey:@"date"];
    [self.firstImageView setImageWithURL:[NSURL URLWithString:(NSString *)[first objectForKey:@"dayPictureUrl"]]];
    self.firstTemLabel.text = (NSString *)[first objectForKey:@"temperature"];
    
    self.secondDateLabel.text = [second objectForKey:@"date"];
    [self.secondImageView setImageWithURL:[NSURL URLWithString:(NSString *)[second objectForKey:@"dayPictureUrl"]]];
    self.secondTemLabel.text = (NSString *)[second objectForKey:@"temperature"];
    
    self.thirdDateLabel.text = [third objectForKey:@"date"];
    [self.thirdImageView setImageWithURL:[NSURL URLWithString:(NSString *)[third objectForKey:@"dayPictureUrl"]]];
    self.thirdTemLabel.text = (NSString *)[third objectForKey:@"temperature"];
    
    NSString *string = [NSString stringWithFormat:@"%@",[today objectForKey:@"weather"]];
    BOOL ishave = NO;
    for (NSString *str in [weatherDic allKeys]) {
        if ([string rangeOfString:str].location != NSNotFound) {
            ishave = YES;
            NSString *imageStr = [weatherDic objectForKey:str];
            [self.weatherImageView setImage:[UIImage imageNamed:imageStr]];
            break;
        }
    }
    if (!ishave) {
        [self.weatherImageView setImageWithURL:[NSURL URLWithString:[today objectForKey:@"dayPictureUrl"]]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 创建UI
- (void)UIConfig {
    self.title = @"天气";
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 30);
    [button addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"icon_neirongxiangqing_1"] forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftItem;
}
- (void)backButtonClicked {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)cityBtnClicked:(id)sender {
    if (!cityVC) {
        cityVC = [[CityViewController alloc] init];
        cityVC.delegate = self;
    }
    BaseNavigationController *baseVc = [[BaseNavigationController alloc] initWithRootViewController:cityVC];
    baseVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:baseVc animated:YES completion:nil];
}
#pragma mark - CityViewControllerDelegate
- (void)selectCity:(NSString *)cityName {
    _currentCity = cityName;
    [self getWeatherInfo];
}
- (IBAction)backBtnClicked:(id)sender {
    NSLog(@"%@",_currentCity);
    if (weatherArray == nil) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        NSDictionary *dict = @{@"city":_currentCity,
                               @"weartherArray":weatherArray,
                               @"pm25":pm25};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showWeather" object:dict];
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}
@end
