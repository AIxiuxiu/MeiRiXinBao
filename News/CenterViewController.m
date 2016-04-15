//
//  CenterViewController.m
//  News
//
//  Created by ink on 15/1/14.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import "CenterViewController.h"
@interface CenterViewController ()
{
    NSInteger selectNum;
    NSMutableArray *vcArray;
}
@end

@implementation CenterViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)refreshMainView {
    self.slideSwitchView.userSelectedChannelID = 100;
    [vcArray removeAllObjects];
    [self.slideSwitchView buildUI];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    _HUD.labelText = @"正在下载...";
    [self.view addSubview:_HUD];
#pragma mark - 定位放在这里不行---已经移到listViewController里面了
#pragma mark- changeByChangpeng
//    [self location];
    
    
    vcArray = [[NSMutableArray alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMainView) name:@"refreshMainView" object:nil];
    
    [self getControls];//获取页卡
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self UIConfig];
    self.title = @"每日新报";
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    self.slideSwitchView.tabItemNormalColor = [SUNSlideSwitchView colorFromHexRGB:@"868686"];
    self.slideSwitchView.tabItemSelectedColor = [SUNSlideSwitchView colorFromHexRGB:@"bb0b15"];
    self.slideSwitchView.shadowImage = [[UIImage imageNamed:@"red_line_and_shadow.png"]
                                        stretchableImageWithLeftCapWidth:63.0f topCapHeight:0.0f];
    self.slideSwitchView.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];;
    
    UIButton *rightSideButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightSideButton setImage:[UIImage imageNamed:@"icon_rightarrow.png"] forState:UIControlStateNormal];
    [rightSideButton setImage:[UIImage imageNamed:@"icon_rightarrow.png"]  forState:UIControlStateHighlighted];
    [rightSideButton addTarget:self action:@selector(channelVC) forControlEvents:UIControlEventTouchUpInside];
    rightSideButton.frame = CGRectMake(0, 0, 24.0f, 14.0f);
    rightSideButton.userInteractionEnabled = YES;
    self.slideSwitchView.rigthSideButton = rightSideButton;
    [self getAds];
    
#pragma mark - 下载
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoad) name:@"downLoadNews" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(freshAlertMsg:) name:@"freshAlertMsg" object:nil];
//    [self.slideSwitchView buildUI];

    // Do any additional setup after loading the view from its nib.
}
#pragma mark - 获取load页广告
- (void)getAds {
    if (_ADManager) {
        _ADManager = nil;
    }
    _ADManager = [AFHTTPRequestOperationManager manager];
    NSDictionary *dic = @{@"type":@"1"};
    NSString *token = [CustomEncrypt jiamiWithDictionary:dic];
    NSDictionary *dict = @{@"type":@"1",
                           @"token":token};
    _ADManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//如果报接口类型不一致请替换
    _ADManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [_ADManager POST:kAdvert parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"adresult = %@",responseObject);
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([[result objectForKey:@"ret"] intValue]==1) {
            NSDictionary *dictionary = [result objectForKey:@"data"];
            UIImageView *image = [[UIImageView alloc] init];
            [image setImageWithURL:[NSURL URLWithString:[dictionary objectForKey:@"src"]]];
            [USER_DEFAULT setObject:[dictionary objectForKey:@"src"] forKey:@"loadingAd"];
        }else {
            [USER_DEFAULT setObject:nil forKey:@"loadingAd"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@  ,  %s",error.description,__FUNCTION__);
    }];
}
- (void)cancelDownLoadNews {
    _downLoadManager = nil;
    NSFileManager *fileManger = [NSFileManager defaultManager];
    NSString *path = [NSString stringWithFormat:@"%@/Library/imgs",NSHomeDirectory()];
    NSString *path1 = [NSString stringWithFormat:@"%@/Library/newsFile.plist",NSHomeDirectory()];
    [fileManger removeItemAtPath:path error:nil];
    [fileManger removeItemAtPath:path1 error:nil];
    NSString *imagePath = [NSString stringWithFormat:@"%@/Library/imgs",NSHomeDirectory()];
    [fileManger createDirectoryAtPath:imagePath withIntermediateDirectories:NO attributes:nil error:nil];

}
- (void)freshAlertMsg:(NSNotification *)notification {
//    NSInteger p = (NSInteger)([notification.object floatValue]*100);
//    NSString *message = [NSString stringWithFormat:@"已下载%ld %",(long)p];
//    loadAlert.message = message;
}

- (void)downLoad {
    downLoadNews *maneg = [downLoadNews sharedLoadManager];
//    if ([maneg isExist]) {
//        UIAlertView *alert= [[UIAlertView alloc] initWithTitle:@"" message:@"已下载" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//        return;
//    }
    if (!loadAlert) {
        loadAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"正在下载..." delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        loadAlert.tag = 1000;
    }
//    loadAlert.message = @"已下载0.0%...";
    [loadAlert show];
//    [_HUD show:YES];
    
    if (_downLoadManager) {
        _downLoadManager = nil;
    }
    _downLoadManager = [AFHTTPRequestOperationManager manager];
    _downLoadManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//如果报接口类型不一致请替换
   _downLoadManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSArray *allControls = [USER_DEFAULT objectForKey:@"allControls"];
    NSMutableArray *muArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in allControls) {
        [muArray addObject:[dictionary objectForKey:@"id"]];
    }
    NSString *labelId = [muArray componentsJoinedByString:@","];
    [USER_DEFAULT setObject:labelId forKey:@"label_id"];
    NSDictionary *dic = @{@"label_id":labelId};
    NSString *token = [CustomEncrypt jiamiWithDictionary:dic];
    NSDictionary *dict = @{@"label_id":labelId,
                           @"token":token};
    [_downLoadManager POST:kDownLoad parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([[result objectForKey:@"ret"] intValue] == 1) {
            NSLog(@"result = %@",result);
            NSArray *array = [result objectForKey:@"data"];
            NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(downLoadWithArray:) object:array];
            [thread start];
//            if (![maneg isExistWithNet]) {
//                [maneg saveWithArray:array];
//            }
//            [loadAlert dismissWithClickedButtonIndex:1 animated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@,%s",error.description,__FUNCTION__);
    }];
}
- (void)downLoadWithArray:(NSArray *)array {
    downLoadNews *maneg = [downLoadNews sharedLoadManager];
    if (![maneg isExistWithNet]) {
        [maneg saveWithArray:array];
    }
    [loadAlert dismissWithClickedButtonIndex:1 animated:YES];
}
#pragma mark - 页卡 
- (void)getControls {
    if (_AFManager) {
        _AFManager= nil;
    }
    _AFManager = [AFHTTPRequestOperationManager manager];
    
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *string = [formatter stringFromDate:date];
    NSString *MDstr = [CustomEncrypt jiamiWithDate:string];
    NSDictionary *dict = @{@"token":MDstr};
    _AFManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//如果报接口类型不一致请替换
    _AFManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [_AFManager POST:kControl parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"result = %@",result);
        
        if ([[result objectForKey:@"ret"] intValue]==1) {
            NSArray *controlArray = (NSArray *)[result objectForKey:@"data"];
            NSArray *allControls = [USER_DEFAULT objectForKey:@"allControls"];
            if ([allControls isEqualToArray:controlArray]) {
                NSLog(@"1111");
                //页卡没有改变
                //貌似这里什么都不用做
            }else {
                [USER_DEFAULT setObject:controlArray forKey:@"allControls"];
                NSMutableArray *selectArray = [[NSMutableArray alloc] init];
                NSMutableArray *moreArray = [[NSMutableArray alloc] init];
                if (controlArray.count>6) {
                    for (int i=0; i<6; i++) {
                        id dic = [controlArray objectAtIndex:i];
                        [selectArray addObject:dic];
                    }
                    for (int i=6; i<controlArray.count; i++) {
                        id dic = [controlArray objectAtIndex:i];
                        [moreArray addObject:dic];
                    }
                    [USER_DEFAULT setObject:selectArray forKey:@"selectControls"];
                    [USER_DEFAULT setObject:moreArray forKey:@"moreControls"];
                }else {
                    selectArray = [NSMutableArray arrayWithArray:controlArray];
                    moreArray = nil;
                    [USER_DEFAULT setObject:selectArray forKey:@"selectControls"];
                    [USER_DEFAULT setObject:moreArray forKey:@"moreControls"];
                }
                
            }
            [self.slideSwitchView buildUI];
        }else {
            NSString *msg = [result objectForKey:@"msg"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
//                        [self.slideSwitchView buildUI];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"error:%@,%s",error.description,__FUNCTION__);
//        [self.slideSwitchView buildUI];
    }];
    
//    
//    [_AFManager GET:kControl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"result = %@",result);
//        
//        if ([[result objectForKey:@"ret"] intValue]==1) {
//            NSArray *controlArray = (NSArray *)[result objectForKey:@"data"];
//            NSArray *allControls = [USER_DEFAULT objectForKey:@"allControls"];
//            if ([allControls isEqualToArray:controlArray]) {
//                NSLog(@"1111");
//                //页卡没有改变
//                //貌似这里什么都不用做
//            }else {
//                [USER_DEFAULT setObject:controlArray forKey:@"allControls"];
//                NSMutableArray *selectArray = [[NSMutableArray alloc] init];
//                NSMutableArray *moreArray = [[NSMutableArray alloc] init];
//                if (controlArray.count>6) {
//                    for (int i=0; i<6; i++) {
//                        id dic = [controlArray objectAtIndex:i];
//                        [selectArray addObject:dic];
//                    }
//                    for (int i=6; i<controlArray.count; i++) {
//                        id dic = [controlArray objectAtIndex:i];
//                        [moreArray addObject:dic];
//                    }
//                    [USER_DEFAULT setObject:selectArray forKey:@"selectControls"];
//                    [USER_DEFAULT setObject:moreArray forKey:@"moreControls"];
//                }else {
//                    selectArray = [NSMutableArray arrayWithArray:controlArray];
//                    moreArray = nil;
//                    [USER_DEFAULT setObject:selectArray forKey:@"selectControls"];
//                    [USER_DEFAULT setObject:moreArray forKey:@"moreControls"];
//                }
//                [self.slideSwitchView buildUI];
//            }
//        }else {
//            NSString *msg = [result objectForKey:@"msg"];
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"error:%@,%s",error.description,__FUNCTION__);
//    }];
}



- (void)location {
    _locationManager = [[CLLocationManager alloc] init];
    if ([CLLocationManager locationServicesEnabled]) {
        NSLog(@"开始定位");
        _locationManager.delegate = self;
        _locationManager.distanceFilter = 200.0f;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        if (IOS8) {
            [_locationManager requestAlwaysAuthorization];        //NSLocationAlwaysUsageDescription
            [_locationManager requestWhenInUseAuthorization];
        }
        [_locationManager startUpdatingLocation];
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"启动定位失败，请开启定位服务！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        
        [alert show];
    }
    
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    CLLocationCoordinate2D loc = [newLocation coordinate];
    _longitude = loc.longitude;
    _latitude = loc.latitude;
    CLGeocoder *geo_coder = [[CLGeocoder alloc] init];
    CLGeocodeCompletionHandler handle=^(NSArray *placemark, NSError *error)
    {
        if (!error)
        {
            @try
            {
                for (CLPlacemark *mark in placemark)
                {
                    NSDictionary *area_dic=[mark addressDictionary];
                    [area_dic setValue:[NSString stringWithFormat:@"%f",_latitude] forKey:@"latitude"];
                    [area_dic setValue:[NSString stringWithFormat:@"%f",_longitude] forKey:@"longitude"];
                    
                    _currentCity=[area_dic objectForKey:@"State"];
                    NSLog(@"city = %@",_currentCity);
                    [self getWearther];
                }
            }
            @catch (NSException *exception) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Msg" message:@"Map can not get your current location" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                
                [alert show];
            }
        }
        else
        {
            // stop the location manager first.
            [_locationManager stopUpdatingLocation], _locationManager = nil;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"定位失败,检查设置" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"重新定位", nil];
            alert.delegate = self;
            [alert show];
        }
        
    };
    
    [geo_coder reverseGeocodeLocation:newLocation completionHandler:handle];
}

#pragma mark - uialertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1000) {
        [self cancelDownLoadNews];
    }
    if (buttonIndex == 1) {
        [self location];
    }else if (buttonIndex == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showWeather" object:nil];
    }
}
//http://api.map.baidu.com/telematics/v3/weather?location=北京&output=json&ak=r7uTaLWDMpq0DXmsGfGj8av1&mcode=com.iyoudoo.News
- (void)getWearther {
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
            _weartherArray = [dictionary objectForKey:@"weather_data"];
            _pm25 = [dictionary objectForKey:@"pm25"];
//            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weartherShow:) name:@"showWeather" object:nil];
            NSDictionary *dict = @{@"city":_currentCity,
                                   @"weartherArray":_weartherArray,
                                   @"pm25":_pm25};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showWeather" object:dict];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error :%@",error.description);
    }];
}


- (void)channelVC {
    ChannelViewController *channelVC = [[ChannelViewController alloc] init];
    BaseNavigationController *base = [[BaseNavigationController alloc] initWithRootViewController:channelVC];
    channelVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:base animated:YES completion:nil];
}
#pragma mark - 创建UI
- (void)UIConfig {
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"bt_shouye_1"] forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(0, 0, 18, 13);
    [leftBtn addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"bt_shouye_2"] forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(0, 0, 25, 25);
    [rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark - item事件

- (void)leftBtnClicked:(UIButton *)button {
    [self.mm_drawerController openDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
        
    }];
}
- (void)rightBtnClicked:(UIButton *)button {
    [self.mm_drawerController openDrawerSide:MMDrawerSideRight animated:YES completion:^(BOOL finished) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}
- (NSUInteger)numberOfTab:(SUNSlideSwitchView *)view{
    NSArray *array = [USER_DEFAULT objectForKey:@"selectControls"];
    NSLog(@"cao = %d",array.count);
    return array?array.count:0;
}
- (void)slideSwitchView:(SUNSlideSwitchView *)view panLeftEdge:(UIPanGestureRecognizer *)panParam
{
    MMDrawerController *drawerController = (MMDrawerController *)self.navigationController.mm_drawerController;
    [drawerController panGestureCallback:panParam];
}
- (void)slideSwitchView:(SUNSlideSwitchView *)view panRightEdge:(UIPanGestureRecognizer*) panParam {
    MMDrawerController *drawerController = (MMDrawerController *)self.navigationController.mm_drawerController;
    [drawerController panGestureCallback:panParam];
}
- (UIViewController *)slideSwitchView:(SUNSlideSwitchView *)view viewOfTab:(NSUInteger)number{
    NSArray *array = [USER_DEFAULT objectForKey:@"selectControls"];
    NSDictionary *dict = [array objectAtIndex:number];
    ListViewController *listVc = [[ListViewController alloc] init];
//    listVc.numOfVC = number;
    if (number ==0 ) {
        //通过这个字段。。标记下只有第一个页卡能定位。。其他的不让定位了
        listVc.isShouYe = YES;
    }else  {
        listVc.isShouYe = NO;
    }
    listVc.delegate = self;
    listVc.dict = dict;
    listVc.title = (NSString *)[dict objectForKey:@"title"];
    [vcArray addObject:listVc];
    return listVc;
}
- (void)slideSwitchView:(SUNSlideSwitchView *)view didselectTab:(NSUInteger)number
{
    ListViewController *listVc = [vcArray objectAtIndex:number];
    [listVc viewDidCurrentView];
}

- (void)pushToType:(NSInteger)type andObject:(id)object {
    NSDictionary *dictionary = (NSDictionary *)object;
    
    if (type == 1) {
        //只有文本
        DetailViewController *detailVC = [[DetailViewController alloc] init];
        detailVC.isWithPic = NO;
        detailVC.infoDic = dictionary;
        BaseNavigationController *base = [[BaseNavigationController alloc] initWithRootViewController:detailVC];
        base.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:base animated:YES completion:nil];
    }else if (type == 2) {
        //图文
        DetailViewController *detailVC = [[DetailViewController alloc] init];
        detailVC.isWithPic = YES;
        detailVC.infoDic = dictionary;
        BaseNavigationController *base = [[BaseNavigationController alloc] initWithRootViewController:detailVC];
        base.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:base animated:YES completion:nil];
    }else if (type == 0) {
        //只有图
        PicturesViewController *picVC = [[PicturesViewController alloc] init];
        picVC.infoDic = dictionary;
        [self presentViewController:picVC animated:YES completion:nil];
    }
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
