//
//  CityViewController.m
//  News
//
//  Created by ink on 15/2/27.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import "CityViewController.h"

@interface CityViewController ()
{
    NSMutableArray *_dataArray;
    NSMutableArray *_allKeys;
}
@end

@implementation CityViewController
- (void)UIConfig
{
    
    self.title = @"城市";
    
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 30);
    [button addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"icon_neirongxiangqing_1"] forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftItem;
}
#pragma mark -返回按钮
- (void)backButtonClicked {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self UIConfig];
    _dataArray = [[NSMutableArray alloc] init];
    _allKeys = [[NSMutableArray alloc] init];
    NSURL *url = [NSURL URLWithString:kGetCity];
    
    //第二步，创建请求
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    
    [request setHTTPMethod:@"POST"];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *string = [formatter stringFromDate:date];
    NSString *MDstr = [CustomEncrypt jiamiWithDate:string];
    
    NSString *str = [NSString stringWithFormat:@"token=%@",MDstr];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    
    [NSURLConnection connectionWithRequest:request delegate:self];
    
//    [self getData];
    // Do any additional setup after loading the view from its nib.
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response

{
    
    NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
    
    NSLog(@"%@",[res allHeaderFields]);
    
    self.receiveData = [NSMutableData data];
    
}

//接收到服务器传输数据的时候调用，此方法根据数据大小执行若干次

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data

{
    
    [self.receiveData appendData:data];
    
}

//数据传完之后调用此方法

-(void)connectionDidFinishLoading:(NSURLConnection *)connection

{
    
    NSString *receiveStr = [[NSString alloc]initWithData:self.receiveData encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",receiveStr);
    id result  = [NSJSONSerialization JSONObjectWithData:self.receiveData options:NSJSONReadingMutableContainers error:nil];
    NSDictionary *dic = (NSDictionary *)result;
    if ([[dic objectForKey:@"ret"] intValue] ==1) {
        NSArray *data = [result objectForKey:@"data"];
        for (NSDictionary *dict in data) {
            [_allKeys addObject:[dict objectForKey:@"namesort"]];
            [_dataArray addObject:[dict objectForKey:@"citydata"]];
        }
        [self.tableView reloadData];

    }else {
        NSString *msg = [result objectForKey:@"msg"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

//网络请求过程中，出现任何错误（断网，连接超时等）会进入此方法

-(void)connection:(NSURLConnection *)connection

 didFailWithError:(NSError *)error{
    
}

- (void)getData {
    if (_manager) {
        _manager = nil;
    }
    _manager = [[AFHTTPRequestOperationManager alloc] init];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *string = [formatter stringFromDate:date];
    NSString *MDstr = [CustomEncrypt jiamiWithDate:string];
    NSDictionary *dictionary = @{@"token":MDstr};
    NSLog(@"%@",dictionary);
    [_manager POST:kGetCity parameters:dictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([[result objectForKey:@"ret"] intValue] == 1) {
            NSArray *data = [result objectForKey:@"data"];
            for (NSDictionary *dict in data) {
                [_allKeys addObject:[dict objectForKey:@"namesort"]];
                [_dataArray addObject:[dict objectForKey:@"citydata"]];
            }
            [self.tableView reloadData];
            
        }else {
            NSString *msg = [result objectForKey:@"msg"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error.description);
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
//索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return _allKeys?_allKeys:nil;
}
//点击索引事件
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    // 获取所点目录对应的indexPath值
    NSIndexPath *selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:index];
    // 让table滚动到对应的indexPath位置
    [tableView scrollToRowAtIndexPath:selectIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    return index;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *citys = [_dataArray objectAtIndex:section];
    return citys?citys.count:0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _allKeys.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *string = [_allKeys objectAtIndex:section];
    return string;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSArray *citys = [_dataArray objectAtIndex:indexPath.section];
    NSString *city = [citys objectAtIndex:indexPath.row];
    cell.textLabel.text = city;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *citys = [_dataArray objectAtIndex:indexPath.section];
    NSString *city = [citys objectAtIndex:indexPath.row];
    [self.delegate selectCity:city];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
