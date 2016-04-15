//
//  ListViewController.m
//  News
//
//  Created by ink on 15/1/14.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import "ListViewController.h"
#import "downLoadNews.h"
#define NewsLoadPath [NSString stringWithFormat:@"%@/Library/newsFile.plist",NSHomeDirectory()]
#define K_GETSIZE(_info_) CGSize size = [_info_ boundingRectWithSize:CGSizeMake(300, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size;
@interface ListViewController ()
{
    NSMutableDictionary *dataDic;
    UIImageView *imageView;
    NSInteger _pageNum;
}
@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isShouYe) {
        [self location];
    }
    
    _isFirst = YES;
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    _HUD.labelText = @"loading...";
    [self.view addSubview:_HUD];
    dataDic = [[NSMutableDictionary alloc] init];
    _pageNum = 1;
    [self.tableView addHeaderWithTarget:self action:@selector(tableViewRefresh)];
    [self.tableView addFooterWithTarget:self action:@selector(tableViewFreshMore)];
    
    
        [self createAdImageView];
//        [self getAdImage];
    
    // Do any additional setup after loading the view from its nib.
}
#pragma mark - 上下拉刷新
- (void)tableViewRefresh {
    _pageNum = 1;
    dataDic = [[NSMutableDictionary alloc] init];
    refresh = YES;
    [dataDic removeAllObjects];
   // [self.tableView reloadData];
    [self getNewsInfo];
}
- (void)tableViewFreshMore {
    _pageNum++;
    [self getNewsInfo];
}

#pragma mark - 广告位
- (void)createAdImageView {
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.tableView.frame.origin.y+65,SCREEN_W, 150)];
    imageView.alpha = 1;
    
    imageView.hidden = YES;
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    [imageView setClipsToBounds:YES];
    [self.view insertSubview:imageView belowSubview:self.tableView];
}

#pragma mark - 广告
- (void)getAdImage {
    if (_adManager) {
        _adManager = nil;
    }
    _adManager = [AFHTTPRequestOperationManager manager];
    NSDictionary *dic = @{@"type":@"2"};
    NSString *token = [CustomEncrypt jiamiWithDictionary:dic];
    NSDictionary *dict = @{@"type":@"2",
                           @"token":token};
    _adManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//如果报接口类型不一致请替换
    _adManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [_adManager POST:kAdvert parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"xialaAd = %@",responseObject);
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([[result objectForKey:@"ret"] intValue]==1) {
            NSDictionary *dictionary = [result objectForKey:@"data"];
            [imageView setImageWithURL:[NSURL URLWithString:[dictionary objectForKey:@"src"]] placeholderImage:[UIImage imageNamed:@"jpg_shouye_2"]];
//            [USER_DEFAULT setObject:[dictionary objectForKey:@"src"] forKey:@"xialaAd"];
        }else {
//            [USER_DEFAULT setObject:nil forKey:@"xialaAd"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@  ,  %s",error.description,__FUNCTION__);
    }];
}


- (void)viewDidCurrentView {
   
    if (self.isFirst) {
        _isFirst = NO;
        downLoadNews *mang = [downLoadNews sharedLoadManager];
        if ([mang isExist]) {
            
            NSString *string = [self.dict objectForKey:@"id"];
            NSString *labelIds = [USER_DEFAULT objectForKey:@"label_id"];
            NSArray *a = [labelIds componentsSeparatedByString:@","];
            NSInteger index = [a indexOfObject:string];
            
            NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:NewsLoadPath];
            NSDictionary *dic = [array objectAtIndex:index];
            
            
            [dataDic setDictionary:dic];
            self.tableView.delegate = self;
            self.tableView.dataSource = self;
            [self.tableView reloadData];
        }else {
            [self getNewsInfo];
        }
//        [self getNewsInfo];
    }
}
- (void)getNewsInfo {
    
    if (_manager) {
        _manager = nil;
    }
    _manager = [AFHTTPRequestOperationManager manager];
    NSString *string = [self.dict objectForKey:@"id"];
    NSDictionary *dic = @{@"label_id":string,
                          @"p":[NSString stringWithFormat:@"%ld",(long)_pageNum]};
    NSString *token = [CustomEncrypt jiamiWithDictionary:dic];
    NSDictionary *dictionary = @{@"label_id":string,
                                 @"p":[NSString stringWithFormat:@"%ld",(long)_pageNum],
                                 @"token":token};
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//如果报接口类型不一致请替换
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [_HUD show:YES];
    [_manager POST:khomeNews parameters:dictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
//         NSLog(@"newsInfo = %@",responseObject);
//        if (_pageNum == 1) {
//            [dataDic removeAllObjects];
//        }
        [_HUD hide:YES];
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"responseObject===%@",dictionary);
        if ([[result objectForKey:@"ret"] intValue] == 1) {
           
            if (_pageNum == 1) {
                NSDictionary *dd = [result objectForKey:@"data"];
                [dataDic setDictionary:dd];
            }else {
                NSDictionary *data = [result objectForKey:@"data"];
                NSString *string = [NSString stringWithFormat:@"%@",[data objectForKey:@"info"]];
                if ([string isEqualToString:@"<null>"]) {
                    [self displayNotification:nil titleStr:@" 没有更多数据了 " Duration:0.8 time:0.2];
                    return ;
                }
                NSDictionary *dd = [result objectForKey:@"data"];
                NSArray *moreArray = [dd objectForKey:@"info"];
                NSMutableArray *muArray = [[NSMutableArray alloc] init];
                NSArray *array = [dataDic objectForKey:@"info"];
                [muArray addObjectsFromArray:array];
                [muArray addObjectsFromArray:moreArray];
                NSArray *bannerArray = [dataDic objectForKey:@"banner"];
                [dataDic setObject:bannerArray forKey:@"banner"];
                [dataDic setObject:muArray forKey:@"info"];
            }
            NSLog(@"dataDic = %@",dataDic);
            NSString *string = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"status"]];
            NSLog(@"stri === %@",string);
            [[NSUserDefaults standardUserDefaults]setObject:string forKey:@"status"];
            self.tableView.delegate = self;
            self.tableView.dataSource = self;
            [self.tableView reloadData];
            if (self.isShouYe) {
                imageView.hidden = NO;
            }
        }else {
            NSString *msg = [result objectForKey:@"msg"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_HUD hide:YES];
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        NSLog(@"error:%@",error.description);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = error.localizedDescription;
        hud.margin = 10.f;
        hud.yOffset = 150.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:0.5];
    }];

}
#pragma mark 提示
- (void)displayNotification:(NSString *)imageStr  titleStr:(NSString *)title Duration:(float)Duration time:(float)time
{
    //Duration展示之间 time消失动画时间
    BDKNotifyHUD *notify = [BDKNotifyHUD notifyHUDWithImage:[UIImage imageNamed:imageStr] text:title];
    CGFloat centerX= self.view.bounds.size.width/2;
    CGFloat centerY= self.view.bounds.size.height/2;
    notify.center = CGPointMake(centerX ,centerY);
    [self.view addSubview:notify];
    [notify presentWithDuration:Duration speed:time inView:self.view completion:^{
        [notify removeFromSuperview];
    }];
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

#pragma mark - 列表代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *string = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"info"]];
    NSArray *array = (NSArray *)[dataDic objectForKey:@"info"];
    if ([string isEqualToString:@"<null>"]) {
        array = nil;
    }
    NSArray *banns = [dataDic objectForKey:@"banner"];
    int number = 0;
    if (banns.count != 0) {
        number = 1;
    }
    return array?array.count+number:number;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"刷新了啊");
    NSArray *banns = [dataDic objectForKey:@"banner"];
    NSLog(@"banns=%@",banns);
    if (indexPath.row == 0&&banns.count !=0) {
        static NSString *bannerId = @"bannerCell";
        BannerCell *cell  = [tableView dequeueReusableCellWithIdentifier:bannerId];
        if (refresh == YES) {
            cell = nil;
        }
        refresh = NO;
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"BannerCell" owner:self options:nil] lastObject];
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if ([[dataDic objectForKey:@"banner"] isKindOfClass:[NSArray class]]) {
                NSLog(@"刷新banner吧");
                cell.banners = (NSArray *)[dataDic objectForKey:@"banner"];
                [cell fillData];
            }else {
                NSLog(@"没有banner");
            }

        }
               return cell;
    }else {
         NSArray *banns = [dataDic objectForKey:@"banner"];
        int index = indexPath.row;
        if (banns.count != 0) {
            index = indexPath.row-1;
        }
        NSArray *array = (NSArray *)[dataDic objectForKey:@"info"];
        NSDictionary *dic = [array objectAtIndex:index];
        //0图片 1纯文本 2图文
        if ([[dic objectForKey:@"type"] intValue] == 0) {
            static NSString *picCellId = @"picCell";
            PicCell *cell = [tableView dequeueReusableCellWithIdentifier:picCellId];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"PicCell" owner:self options:nil] lastObject];
            }
            
            cell.titleLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]];
            NSArray *array = [dic objectForKey:@"content"];
            switch (array.count) {
                case 1:
                {
                    NSDictionary *d1 = [array objectAtIndex:0];
                    NSString *pic1 = [d1 objectForKey:@"picture"];
                    [cell.firstImageView setImageWithURL:[NSURL URLWithString:pic1] placeholderImage:[UIImage imageNamed:@""]];//jpg_shouye_1
                }
                    break;
                case 2:
                {
                    NSDictionary *d1 = [array objectAtIndex:0];
                    NSString *pic1 = [d1 objectForKey:@"picture"];
                    [cell.firstImageView setImageWithURL:[NSURL URLWithString:pic1] placeholderImage:[UIImage imageNamed:@""]];
                    NSDictionary *d2 = [array objectAtIndex:1];
                    NSString *pic2 = [d2 objectForKey:@"picture"];
                    [cell.secondImageView setImageWithURL:[NSURL URLWithString:pic2] placeholderImage:[UIImage imageNamed:@""]];
                }
                    break;
                case 3:
                {
                    NSDictionary *d1 = [array objectAtIndex:0];
                    NSString *pic1 = [d1 objectForKey:@"picture"];
                    [cell.firstImageView setImageWithURL:[NSURL URLWithString:pic1] placeholderImage:[UIImage imageNamed:@""]];
                    NSDictionary *d2 = [array objectAtIndex:1];
                    NSString *pic2 = [d2 objectForKey:@"picture"];
                    [cell.secondImageView setImageWithURL:[NSURL URLWithString:pic2] placeholderImage:[UIImage imageNamed:@""]];
                    NSDictionary *d3 = [array objectAtIndex:2];
                    NSString *pic3 = [d3 objectForKey:@"picture"];
                    [cell.thirdImageView setImageWithURL:[NSURL URLWithString:pic3] placeholderImage:[UIImage imageNamed:@""]];
                }
                    break;
                default:
                    break;
            }
            
            return cell;
        }else if ([[dic objectForKey:@"type"] intValue] == 1) {
            static NSString *noPicCellId = @"noPicCell";
            NoPicCell *cell = [tableView dequeueReusableCellWithIdentifier:noPicCellId];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"NoPicCell" owner:self options:nil] lastObject];
            }
            cell.topLabel.text = [dic objectForKey:@"title"];
            cell.contentLabel.text = [dic objectForKey:@"content"];
            return cell;
        }else if ([[dic objectForKey:@"type"] intValue] == 2) {
            static NSString *newListCellId = @"newListCell";
            NewListCell *cell = [tableView dequeueReusableCellWithIdentifier:newListCellId];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"NewListCell" owner:self options:nil] lastObject];
            }
            cell.topLabel.text = [dic objectForKey:@"title"];
            cell.contentLabel.text = [dic objectForKey:@"content"];
            NSString *string = [dic objectForKey:@"illustrated"];
            [cell.headImageView setImageWithURL:[NSURL URLWithString:string] placeholderImage:[UIImage imageNamed:@"jpg_shouye_2"]];
            return cell;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
     NSArray *banns = [dataDic objectForKey:@"banner"];
    
   
    NSLog(@"hhh===%@",banns);
    if (indexPath.row == 0&&banns.count != 0) {
        
       
        NSDictionary *dict = [banns objectAtIndex:0];
        NSString *text = [dict objectForKey:@"text"];
    
        return 220;
        
    }else {
        NSArray *banns = [dataDic objectForKey:@"banner"];
        NSInteger index = indexPath.row;
        if (banns.count != 0) {
            index = indexPath.row-1;
        }
        NSArray *array = (NSArray *)[dataDic objectForKey:@"info"];
        NSDictionary *dic = [array objectAtIndex:index];
        //0图片 1纯文本 2图文
        if ([[dic objectForKey:@"type"] intValue] == 0) {
            return 100;
        }else if ([[dic objectForKey:@"type"] intValue] == 2)
        {
            return 80;
        }
        else{
            return 55;
        }
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     [self performSelector:@selector(unselectCell:) withObject:nil afterDelay:0.5];
    NSArray *banns = [dataDic objectForKey:@"banner"];
    if (banns.count != 0){
        if (indexPath.row != 0) {
            NSArray *array = (NSArray *)[dataDic objectForKey:@"info"];
            NSDictionary *dic = [array objectAtIndex:indexPath.row-1];
            
            
            if ([[dic objectForKey:@"type"] intValue] == 1) {
                //只有文本
                [self.delegate pushToType:1 andObject:dic];
            }else if ([[dic objectForKey:@"type"] intValue] == 2) {
                //图文
                [self.delegate pushToType:2 andObject:dic];
            }else if ([[dic objectForKey:@"type"] intValue] == 0) {
                //只有图
                [self.delegate pushToType:0 andObject:dic];
            }
        }
    }else {
        NSArray *array = (NSArray *)[dataDic objectForKey:@"info"];
        NSDictionary *dic = [array objectAtIndex:indexPath.row];
        if ([[dic objectForKey:@"type"] intValue] == 1) {
            //只有文本
            [self.delegate pushToType:1 andObject:dic];
        }else if ([[dic objectForKey:@"type"] intValue] == 2) {
            //图文
            [self.delegate pushToType:2 andObject:dic];
        }else if ([[dic objectForKey:@"type"] intValue] == 0) {
            //只有图
            [self.delegate pushToType:0 andObject:dic];
        }
    }
}
-(void)unselectCell:(id)sender{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}
#pragma mark-changeByChangpeng
#pragma mark- 定位
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
#pragma mark - BannerCellDelegate
- (void)clickedWithNewsDic:(NSDictionary *)dic {
    
#warning banner跳转
    int index = [[dic objectForKey:@"type"] intValue];

    [self.delegate pushToType:index andObject:dic];
}
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    NSLog(@"定位失败，%@",error.description);
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    CLLocationCoordinate2D loc = [newLocation coordinate];
    double longitude = loc.longitude;
    double latitude = loc.latitude;
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
                    [area_dic setValue:[NSString stringWithFormat:@"%f",latitude] forKey:@"latitude"];
                    [area_dic setValue:[NSString stringWithFormat:@"%f",longitude] forKey:@"longitude"];
                    
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
- (void)getWearther {
    if (_locationManger) {
        _locationManger = nil;
    }
    _locationManger = [AFHTTPRequestOperationManager manager];
    NSDictionary *dic  = @{@"location":_currentCity,
                           @"output":@"json",
                           @"ak":baidu_key,
                           @"mcode":@"com.iyoudoo.News"};
    _locationManger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//如果报接口类型不一致请替换
    _locationManger.responseSerializer = [AFHTTPResponseSerializer serializer];
    [_locationManger GET:@"http://api.map.baidu.com/telematics/v3/weather" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"===%@",responseObject);
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([[result objectForKey:@"error"] intValue] == 0) {
            NSArray *array = [result objectForKey:@"results"];
            NSDictionary *dictionary = [array objectAtIndex:0];
            NSString * weartherArray = [dictionary objectForKey:@"weather_data"];
            NSString * pm25 = [dictionary objectForKey:@"pm25"];
            //            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weartherShow:) name:@"showWeather" object:nil];
            NSDictionary *dict = @{@"city":_currentCity,
                                   @"weartherArray":weartherArray,
                                   @"pm25":pm25};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showWeather" object:dict];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error :%@",error.description);
    }];
}

@end
