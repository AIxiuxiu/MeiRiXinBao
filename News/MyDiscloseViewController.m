//
//  MyDiscloseViewController.m
//  News
//
//  Created by ink on 15/4/8.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import "MyDiscloseViewController.h"

@interface MyDiscloseViewController ()
{
    //接口参数 1爆料 2求助
    NSString *_type;
    //数据源
    NSMutableArray *_dataArray;
}
@end

@implementation MyDiscloseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 30);
    [button addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"icon_neirongxiangqing_1"] forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    _dataArray = [[NSMutableArray alloc] init];
    if (_isHelp) {
        _type = @"2";
        self.title = @"我的求助";
    }else {
        _type = @"1";
        self.title = @"我的爆料";
    }
    
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    [self getdata];
    // Do any additional setup after loading the view from its nib.
}
- (void)backButtonClicked {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)getdata {
    NSString *uid = [USER_DEFAULT objectForKey:@"userId"];
    if (_manager) {
        _manager = nil;
    }
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//如果报接口类型不一致请替换
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *dic = @{@"user_id":uid,
                          @"type":_type};
    NSString *token = [CustomEncrypt jiamiWithDictionary:dic];
    NSDictionary *dict = @{@"user_id":uid,
                           @"type":_type,
                           @"token":token};
    [_manager POST:kMyNews parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"result1 = %@",responseObject);
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([[result objectForKey:@"ret"] intValue] == 1) {
            NSArray *array = [result objectForKey:@"data"];
            [_dataArray addObjectsFromArray:array];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 107.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"myDiscloseCell";
    MyDiscloseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyDiscloseCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dic = [_dataArray objectAtIndex:indexPath.row];
    cell.dataDic =dic;
    [cell fillData];
    return cell;
}

@end
