//
//  SearchViewController.m
//  News
//
//  Created by iyoudoo on 15/2/3.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.searchTableView.hidden = YES;
    
    self.searchTF.text = @"";
    
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    _HUD.labelText = @"loading...";
    [self.view addSubview:_HUD];
    
    #pragma mark -change by zhang
    self.searchDict = [[NSMutableDictionary alloc] init];
    dataDic = [[NSArray alloc] init];
    _dataArray = [[NSArray alloc] init];
    _pageNum = 1;
    [self.searchTableView addHeaderWithTarget:self action:@selector(tableViewRefresh)];
    [self.searchTableView addFooterWithTarget:self action:@selector(tableViewFreshMore)];
    
    
    [self UIConfig];
    
    [self getData];
    
//    [self getSearchInfo];
    
//    hotTableView.hidden = YES;
    
}

#pragma mark -change by zhang
#pragma mark - 上下拉刷新
- (void)tableViewRefresh {
    _pageNum = 1;
    [self.searchDict removeAllObjects];
    //    [self.tableView reloadData];
    [self getSearchInfo];
}
#pragma mark -change by zhang
- (void)tableViewFreshMore {
    _pageNum++;
    [self getSearchInfo];
}

#pragma mark - 创建UI
-(void)UIConfig
{
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"搜索";
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 30);
    [button addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"icon_neirongxiangqing_1"] forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftItem;
    
//    self.searchTF.background = [UIImage imageNamed:@"bt_sousuo_1@2x"];
    self.searchTF.borderStyle = UITextBorderStyleNone;
    self.searchTF.backgroundColor = [UIColor whiteColor];
    self.searchTF.layer.cornerRadius = 5.0;
//    self.searchTF.borderStyle = UITextBorderStyleRoundedRect;
    //UITextField光标缩进
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 30)];
    self.searchTF.leftView = paddingView;
    self.searchTF.leftViewMode = UITextFieldViewModeAlways;
    
//    [self.searchBar setTranslucent:YES];
    
    //创建热点
    //hotTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    hotTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_W, SCREEN_H-64-50)];
    hotTableView.delegate = self;
    hotTableView.dataSource = self;
    hotTableView.separatorStyle = UITableViewCellSeparatorStyleNone;//隐藏分割线
    [self.view addSubview:hotTableView];
    
}

- (void)backButtonClicked {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark -change by zhang
-(void)getData
{
    if (_searchManager) {
        _searchManager = nil;
    }
    _searchManager = [AFHTTPRequestOperationManager manager];
    _searchManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//如果报接口类型不一致请替换
    _searchManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *string = [formatter stringFromDate:date];
    NSString *MDstr = [CustomEncrypt jiamiWithDate:string];
    NSDictionary *dictionary = @{@"token":MDstr};

//    NSString *string = self.searchTF.text;
//    NSDictionary *dic = @{@"key":string};
//    NSString *token = [CustomEncrypt jiamiWithDictionary:dic];
//    NSDictionary *dictionary = @{@"key":string,
//                                 @"token":token};
    [_HUD show:YES];
    [_searchManager POST:kHotkey parameters:dictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"搜newsInfo = %@",responseObject);
        [_HUD hide:YES];
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([[result objectForKey:@"ret"] intValue] == 1) {
            NSLog(@"dataDic = %@",dataDic);
            dataDic = [result objectForKey:@"data"];
            [hotTableView reloadData];
        }else {
            NSString *msg = [result objectForKey:@"msg"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_HUD hide:YES];
        NSLog(@"error:%@",error.description);
    }];
    
}

//-(void)getData
//{
//    if (_searchManager) {
//        _searchManager = nil;
//    }
//    _searchManager = [AFHTTPRequestOperationManager manager];
//    //NSString *string = [self.searchDict objectForKey:@"id"];
//    NSString *string = self.searchTF.text;
//    NSDictionary *dic = @{@"key":string};
//    NSString *token = [CustomEncrypt jiamiWithDictionary:dic];
//    NSDictionary *dictionary = @{@"key":string,
//                                 @"token":token};
//    [_HUD show:YES];
//    [_searchManager POST:kSearch parameters:dictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"搜newsInfo = %@",responseObject);
//        [_HUD hide:YES];
//        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        if ([[result objectForKey:@"ret"] intValue] == 1) {
//            //            NSDictionary *data = [result objectForKey:@"data"];
//            dataDic = [result objectForKey:@"data"];
//            NSLog(@"dataDic = %@",dataDic);
////            hotTableView.delegate = self;
////            hotTableView.dataSource = self;
//            [hotTableView reloadData];
//        }else {
//            NSString *msg = [result objectForKey:@"msg"];
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [_HUD hide:YES];
//        NSLog(@"error:%@",error.description);
//    }];
//    
//}

#pragma mark -change by zhang
-(void)getSearchInfo
{
    if(self.searchTF.text == nil || [self.searchTF.text isEqualToString:@""]){
        self.searchTableView.hidden = YES;
        hotTableView.hidden = NO;
        [self getData];
    }else{
        if(_searchManager){
            _searchManager = nil;
        }
        _searchManager = [AFHTTPRequestOperationManager manager];
        _searchManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//如果报接口类型不一致请替换
        _searchManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //    self.searchStr = self.searchBar.text;
        self.searchStr = self.searchTF.text;
        NSLog(@"搜索关键字====%@",self.searchStr);
        NSDictionary *dic = @{@"key":self.searchStr,
                            @"p":[NSString stringWithFormat:@"%ld",(long)_pageNum]};
        NSString *token = [CustomEncrypt jiamiWithDictionary:dic];
        NSDictionary *dict = @{@"key":self.searchStr,
                              @"p":[NSString stringWithFormat:@"%ld",(long)_pageNum],
                               @"token":token};
        [_HUD show:YES];
        [_searchManager POST:kSearch parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"搜索结果====%@",responseObject);
            [_HUD hide:YES];
            [self.searchTableView headerEndRefreshing];
            [self.searchTableView footerEndRefreshing];
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"搜索结果result===%@",result);
            if ([[result objectForKey:@"ret"] intValue] == 1) {
                //            _dataArray = [result objectForKey:@"data"];
                //            [self.searchTableView reloadData];
                if (_pageNum == 1) {
                    NSDictionary *dd = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                    [self.searchDict setDictionary:dd];
                }else {
//                    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//                    NSString *string = [NSString stringWithFormat:@"%@",[result objectForKey:@"data"]];
//                    NSLog(@"string***====%@",string);
//                    if ([string isEqualToString:@"<null>"]) {
//                        [self displayNotification:nil titleStr:@" 没有更多数据了 " Duration:0.8 time:0.2];
//                        return ;
//                    }
                    NSDictionary *dd = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                    NSArray *moreArray = [dd objectForKey:@"data"];
                    NSMutableArray *muArray = [[NSMutableArray alloc] init];
                    NSArray *array = [self.searchDict objectForKey:@"data"];
                    [muArray addObjectsFromArray:array];
                    [muArray addObjectsFromArray:moreArray];
                    [self.searchDict setObject:muArray forKey:@"data"];
                }
                
//                dataDic = [self.searchDict objectForKey:@"data"];
                NSLog(@"搜索dataDic = %@",dataDic);
                self.searchTableView.delegate = self;
                self.searchTableView.dataSource = self;
                [self.searchTableView reloadData];
            }else {
                NSString *msg = [result objectForKey:@"msg"];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [_HUD hide:YES];
            [self.searchTableView headerEndRefreshing];
            [self.searchTableView footerEndRefreshing];
            NSLog(@"searchError:%@",error.description);
        }];
    }
}

#pragma mark - 列表代理
#pragma UITableViewDelelgate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    NSString *string = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"info"]];
    //    NSArray *array = (NSArray *)[dataDic objectForKey:@"info"];
    //NSString *string = [NSString stringWithFormat:@"%@",[result objectForKey:@"data"]];
    //    NSLog(@"nihao = %d",array.count);
    //    return array?array.count+1:1;
    
    
    
    //NSArray *array = (NSArray *)(dataDic);
    NSInteger m;
    
    if(tableView == hotTableView){
        NSString *string = [NSString stringWithFormat:@"%@",dataDic];
        if ([string isEqualToString:@"<null>"]) {
            //array = nil;
            dataDic = nil;
        }
        m = dataDic.count/2+dataDic.count%2;
        return dataDic?m:0;
    }else if (tableView == self.searchTableView){
        dataDic = [self.searchDict objectForKey:@"data"];
        NSString *string = [NSString stringWithFormat:@"%@",dataDic];
        if ([string isEqualToString:@"<null>"]) {
            //array = nil;
            dataDic = nil;
        }
        m = dataDic.count;
        return dataDic?dataDic.count:0;
    }
    return dataDic?m:0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == hotTableView){
//        static NSString *picCellId = @"picCell";
//        PicCell *cell = [tableView dequeueReusableCellWithIdentifier:picCellId];
//        if (cell == nil) {
//            cell = [[[NSBundle mainBundle] loadNibNamed:@"PicCell" owner:self options:nil] lastObject];
//        }
        static NSString *cellId=@"cellId";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
        
        if(!cell)
        {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }

        NSArray *array = (NSArray *)(dataDic);
        NSInteger m = [array count];
        NSLog(@"changdu===%d",m);
        NSDictionary *leftDic;
        NSDictionary *rightDic;
        
        //左边按钮
        if(indexPath.row*2+1 <= m){
            leftDic = [array objectAtIndex:indexPath.row*2];
            NSLog(@"左边按钮===%@",leftDic);
            //        cell.titleLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]];
            
            leftHotButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, (SCREEN_W-30)/2, 50)];
            [leftHotButton setBackgroundImage:[UIImage imageNamed:@"bt_sousuo_1"] forState:UIControlStateNormal];
            [leftHotButton setBackgroundImage:[UIImage imageNamed:@"bt_sousuo_2"] forState:UIControlStateSelected];
            //        [leftHotButton setTitle:[NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]] forState:UIControlStateNormal];
            [leftHotButton setTitle:[NSString stringWithFormat:@"%@",[leftDic objectForKey:@"key"]] forState:UIControlStateNormal];
            [leftHotButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            leftHotButton.titleLabel.textColor = [UIColor grayColor];
            [leftHotButton setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
            leftHotButton.layer.cornerRadius = 5.0;
            leftHotButton.tag = indexPath.row*2;
             NSLog(@"leftHotButton.tag===%ld",(long)leftHotButton.tag);
            [leftHotButton addTarget:self action:@selector(leftButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
            //        }
            //        if (leftHotButton.tag <= m) {
            [cell addSubview:leftHotButton];
        }
        
        //右边按钮
        if(indexPath.row*2+2 <= m){
            rightDic = [array objectAtIndex:indexPath.row*2+1];
            rightHotButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_W-10-(SCREEN_W-30)/2, 5, (SCREEN_W-30)/2, 50)];
            [rightHotButton setBackgroundImage:[UIImage imageNamed:@"bt_sousuo_1"] forState:UIControlStateNormal];
            [rightHotButton setBackgroundImage:[UIImage imageNamed:@"bt_sousuo_2"] forState:UIControlStateSelected];
            //        [rightHotButton setTitle:[NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]] forState:UIControlStateNormal];
            [rightHotButton setTitle:[NSString stringWithFormat:@"%@",[rightDic objectForKey:@"key"]] forState:UIControlStateNormal];
            NSLog(@"aa===%@",[rightDic objectForKey:@"key"]);
            [rightHotButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            rightHotButton.titleLabel.textColor = [UIColor grayColor];
            [rightHotButton setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
            rightHotButton.layer.cornerRadius = 5.0;
            rightHotButton.tag = indexPath.row*2+1;
            [rightHotButton addTarget:self action:@selector(rightButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
            //        }
            //        if (rightHotButton.tag < m) {
            [cell addSubview:rightHotButton];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;//不可点击
        
        return cell;
        
    }else if (tableView == self.searchTableView){
        //    NSArray *array = (NSArray *)[dataDic objectForKey:@"info"];
        dataDic = [self.searchDict objectForKey:@"data"];
        NSArray *array = (NSArray *)(dataDic);
        NSDictionary *dic = [array objectAtIndex:indexPath.row];
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
                    [cell.firstImageView setImageWithURL:[NSURL URLWithString:pic1] placeholderImage:[UIImage imageNamed:@"jpg_shouye_1"]];
                }
                    break;
                case 2:
                {
                    NSDictionary *d1 = [array objectAtIndex:0];
                    NSString *pic1 = [d1 objectForKey:@"picture"];
                    [cell.firstImageView setImageWithURL:[NSURL URLWithString:pic1] placeholderImage:[UIImage imageNamed:@"jpg_shouye_1"]];
                    NSDictionary *d2 = [array objectAtIndex:1];
                    NSString *pic2 = [d2 objectForKey:@"picture"];
                    [cell.secondImageView setImageWithURL:[NSURL URLWithString:pic2] placeholderImage:[UIImage imageNamed:@"jpg_shouye_1"]];
                }
                    break;
                case 3:
                {
                    NSDictionary *d1 = [array objectAtIndex:0];
                    NSString *pic1 = [d1 objectForKey:@"picture"];
                    [cell.firstImageView setImageWithURL:[NSURL URLWithString:pic1] placeholderImage:[UIImage imageNamed:@"jpg_shouye_1"]];
                    NSDictionary *d2 = [array objectAtIndex:1];
                    NSString *pic2 = [d2 objectForKey:@"picture"];
                    [cell.secondImageView setImageWithURL:[NSURL URLWithString:pic2] placeholderImage:[UIImage imageNamed:@"jpg_shouye_1"]];
                    NSDictionary *d3 = [array objectAtIndex:2];
                    NSString *pic3 = [d3 objectForKey:@"picture"];
                    [cell.thirdImageView setImageWithURL:[NSURL URLWithString:pic3] placeholderImage:[UIImage imageNamed:@"jpg_shouye_1"]];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger m;
    if (tableView == hotTableView) {
        m=60;
        return 60;
    }else if(tableView == self.searchTableView){
        //        NSArray *array = (NSArray *)[dataDic objectForKey:@"info"];
        dataDic = [self.searchDict objectForKey:@"data"];
        NSArray *array = (NSArray *)(dataDic);
        NSDictionary *dic = [array objectAtIndex:indexPath.row];
        //0图片 1纯文本 2图文
        if ([[dic objectForKey:@"type"] intValue] == 0) {
            m=100;
            return 100;
        }else{
            m=50;
            return 50;
        }
    }
    return m;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//        NSArray *array = (NSArray *)(dataDic);
//        NSDictionary *dic = [array objectAtIndex:indexPath.row];
//        if ([[dic objectForKey:@"type"] intValue] == 1) {
//            //只有文本
//            [self.delegate pushToType:1 andObject:dic];
//        }else if ([[dic objectForKey:@"type"] intValue] == 2) {
//            //图文
//            [self.delegate pushToType:2 andObject:dic];
//        }else if ([[dic objectForKey:@"type"] intValue] == 0) {
//            //只有图
//            [self.delegate pushToType:0 andObject:dic];
//        }
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if(tableView == hotTableView){
//        //点击时得到tag,  button.tag/2 为点击的哪一行
//        //              button.tag%2 为每行的哪一个
//        if(leftHotButton.selected){
//            NSLog(@"点击左按钮是哪行===%d",leftHotButton.tag/2);
//            NSLog(@"点击左按钮是哪个===%d",leftHotButton.tag%2);
//        //}else if (rightHotButton){
//            NSLog(@"点击右按钮是哪行===%d",rightHotButton.tag/2);
//            NSLog(@"点击右按钮是哪个===%d",rightHotButton.tag%2);
//       // }
//        
//        NSArray *array = (NSArray *)(dataDic);
//        NSDictionary *dic = [array objectAtIndex:leftHotButton.tag/2];
//        if ([[dic objectForKey:@"type"] intValue] == 1) {
//            //只有文本
//            //        [self.delegate pushToType:1 andObject:dic];
//            
//            DetailViewController *detailVC = [[DetailViewController alloc] init];
//            detailVC.isWithPic = NO;
//            detailVC.infoDic = dic;
//            BaseNavigationController *base = [[BaseNavigationController alloc] initWithRootViewController:detailVC];
//            base.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//            [self presentViewController:base animated:YES completion:nil];
//            
//        }else if ([[dic objectForKey:@"type"] intValue] == 2) {
//            //图文
//            //        [self.delegate pushToType:2 andObject:dic];
//            DetailViewController *detailVC = [[DetailViewController alloc] init];
//            detailVC.isWithPic = YES;
//            detailVC.infoDic = dic;
//            BaseNavigationController *base = [[BaseNavigationController alloc] initWithRootViewController:detailVC];
//            base.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//            [self presentViewController:base animated:YES completion:nil];
//        }else if ([[dic objectForKey:@"type"] intValue] == 0) {
//            //只有图
//            //        [self.delegate pushToType:0 andObject:dic];
//            PicturesViewController *picVC = [[PicturesViewController alloc] init];
//            picVC.infoDic = dic;
//            [self presentViewController:picVC animated:YES completion:nil];
//        }
//        }
//
//        
//    }else
    if (tableView == self.searchTableView){
        dataDic = [self.searchDict objectForKey:@"data"];
        NSArray *array = (NSArray *)(dataDic);
        NSDictionary *dic = [array objectAtIndex:indexPath.row];
        if ([[dic objectForKey:@"type"] intValue] == 1) {
            //只有文本
    //        [self.delegate pushToType:1 andObject:dic];
            
            DetailViewController *detailVC = [[DetailViewController alloc] init];
            detailVC.isWithPic = NO;
            detailVC.infoDic = dic;
            BaseNavigationController *base = [[BaseNavigationController alloc] initWithRootViewController:detailVC];
            base.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:base animated:YES completion:nil];

        }else if ([[dic objectForKey:@"type"] intValue] == 2) {
            //图文
    //        [self.delegate pushToType:2 andObject:dic];
            DetailViewController *detailVC = [[DetailViewController alloc] init];
            detailVC.isWithPic = YES;
            detailVC.infoDic = dic;
            BaseNavigationController *base = [[BaseNavigationController alloc] initWithRootViewController:detailVC];
            base.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:base animated:YES completion:nil];
        }else if ([[dic objectForKey:@"type"] intValue] == 0) {
            //只有图
    //        [self.delegate pushToType:0 andObject:dic];
            PicturesViewController *picVC = [[PicturesViewController alloc] init];
            picVC.infoDic = dic;
            [self presentViewController:picVC animated:YES completion:nil];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//- (void)pushToType:(NSInteger)type andObject:(id)object
//{
//    NSDictionary *dictionary = (NSDictionary *)object;
//    
//    if (type == 1) {
//        //只有文本
//        DetailViewController *detailVC = [[DetailViewController alloc] init];
//        detailVC.isWithPic = NO;
//        detailVC.infoDic = dictionary;
//        BaseNavigationController *base = [[BaseNavigationController alloc] initWithRootViewController:detailVC];
//        base.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//        [self presentViewController:base animated:YES completion:nil];
//    }else if (type == 2) {
//        //图文
//        DetailViewController *detailVC = [[DetailViewController alloc] init];
//        detailVC.isWithPic = YES;
//        detailVC.infoDic = dictionary;
//        BaseNavigationController *base = [[BaseNavigationController alloc] initWithRootViewController:detailVC];
//        base.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//        [self presentViewController:base animated:YES completion:nil];
//    }else if (type == 0) {
//        //只有图
//        PicturesViewController *picVC = [[PicturesViewController alloc] init];
//        picVC.infoDic = dictionary;
//        [self presentViewController:picVC animated:YES completion:nil];
//    }
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//textField搜索键盘的搜索按钮
//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
//{
//    [self.searchBar resignFirstResponder];
//    
//    [self getData];
//}

//- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
//{
//    [self.searchBar resignFirstResponder];
//}
//- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
//{
//    [self.searchBar resignFirstResponder];
//    return YES;
//}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.searchTF resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.searchTF resignFirstResponder];
    
    hotTableView.hidden = YES;
    self.searchTableView.hidden = NO;
    
    [self getSearchInfo];
    
    return YES;
}


//热点按钮点击
//点击时得到tag,  button.tag/2 为点击的哪一行
//              button.tag%2 为每行的哪一个
-(void)leftButtonTouch:(UIButton *)sender
{
    //首先获得Cell:button的 父视图是contentView ，再上一层才是TableViewCell
    UITableViewCell *cell = (UITableViewCell *)sender.superview.superview;
    //然后使用indexPathForCell方法，就得到indexPath了
   // NSIndexPath *indexPath = [hotTableView indexPathForCell:cell];
   // leftHotButton.tag = indexPath.row*2;
    NSLog(@"热点按钮tag左===%d",leftHotButton.tag);
    NSArray *array = (NSArray *)(dataDic);
    NSLog(@"leftHotButton.tag===%ld",(long)sender.tag);
    NSDictionary *dic = [array objectAtIndex:sender.tag];
    self.searchTF.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"key"]];
    
    hotTableView.hidden = YES;
    self.searchTableView.hidden = NO;
    
    [self getSearchInfo];
    
    /*
    if ([[dic objectForKey:@"type"] intValue] == 1) {
        //只有文本
        //        [self.delegate pushToType:1 andObject:dic];
        
        DetailViewController *detailVC = [[DetailViewController alloc] init];
        detailVC.isWithPic = NO;
        detailVC.infoDic = dic;
        BaseNavigationController *base = [[BaseNavigationController alloc] initWithRootViewController:detailVC];
        base.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:base animated:YES completion:nil];
        
    }else if ([[dic objectForKey:@"type"] intValue] == 2) {
        //图文
        //        [self.delegate pushToType:2 andObject:dic];
        DetailViewController *detailVC = [[DetailViewController alloc] init];
        detailVC.isWithPic = YES;
        detailVC.infoDic = dic;
        BaseNavigationController *base = [[BaseNavigationController alloc] initWithRootViewController:detailVC];
        base.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:base animated:YES completion:nil];
    }else if ([[dic objectForKey:@"type"] intValue] == 0) {
        //只有图
        //        [self.delegate pushToType:0 andObject:dic];
        PicturesViewController *picVC = [[PicturesViewController alloc] init];
        picVC.infoDic = dic;
        [self presentViewController:picVC animated:YES completion:nil];
    }
    
   */

}

-(void)rightButtonTouch:(UIButton *)sender
{
    //首先获得Cell:button的 父视图是contentView ，再上一层才是TableViewCell
    UITableViewCell *cell = (UITableViewCell *)sender.superview.superview;
    //然后使用indexPathForCell方法，就得到indexPath了
   // NSIndexPath *indexPath = [hotTableView indexPathForCell:cell];
   // rightHotButton.tag = indexPath.row*2+1;

    NSArray *array = (NSArray *)(dataDic);
    NSDictionary *dic = [array objectAtIndex:sender.tag];
    
    self.searchTF.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"key"]];
    
    hotTableView.hidden = YES;
    self.searchTableView.hidden = NO;
    
    [self getSearchInfo];
    
    /*
    if ([[dic objectForKey:@"type"] intValue] == 1) {
        //只有文本
        //        [self.delegate pushToType:1 andObject:dic];
        
        DetailViewController *detailVC = [[DetailViewController alloc] init];
        detailVC.isWithPic = NO;
        detailVC.infoDic = dic;
        BaseNavigationController *base = [[BaseNavigationController alloc] initWithRootViewController:detailVC];
        base.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:base animated:YES completion:nil];
        
    }else if ([[dic objectForKey:@"type"] intValue] == 2) {
        //图文
        //        [self.delegate pushToType:2 andObject:dic];
        DetailViewController *detailVC = [[DetailViewController alloc] init];
        detailVC.isWithPic = YES;
        detailVC.infoDic = dic;
        BaseNavigationController *base = [[BaseNavigationController alloc] initWithRootViewController:detailVC];
        base.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:base animated:YES completion:nil];
    }else if ([[dic objectForKey:@"type"] intValue] == 0) {
        //只有图
        //        [self.delegate pushToType:0 andObject:dic];
        PicturesViewController *picVC = [[PicturesViewController alloc] init];
        picVC.infoDic = dic;
        [self presentViewController:picVC animated:YES completion:nil];
    }
    */
    
}

#pragma mark -change by zhang
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


-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.searchTF resignFirstResponder];
}


- (IBAction)searchBtnClicked:(id)sender {
    [self.searchTF resignFirstResponder];
    hotTableView.hidden = YES;
    self.searchTableView.hidden = NO;
    [self getSearchInfo];
}
@end
