//
//  RecordViewController.m
//  News
//
//  Created by ink on 15/2/12.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import "RecordViewController.h"
#import "AppDelegate.h"
@interface RecordViewController ()
{
    NSMutableArray *_dataArray;
    NSInteger _pageNum;
}
@end

@implementation RecordViewController
- (void)UIConfig
{
    self.title = @"我的消息";
    
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
    if (self.isPush) {
        AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        [delegate mainVCConfig];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self UIConfig];
    
    [self.tableView addHeaderWithTarget:self action:@selector(refresh)];
    [self.tableView addFooterWithTarget:self action:@selector(freshMore)];
    
    _dataArray = [[NSMutableArray alloc] init];
    [self refresh];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark - 上下拉刷新
- (void)refresh {
    _pageNum = 1;
    [self getMsgData];
}
- (void)freshMore {
    _pageNum++;
    [self getMsgData];
}


#pragma mark - 获取消息
- (void)getMsgData {
    if (_manager) {
        _manager = nil;
    }
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//如果报接口类型不一致请替换
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    NSDate *date = [NSDate date];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyyMMdd"];
//    NSString *string = [formatter stringFromDate:date];
//    NSString *MDstr = [CustomEncrypt jiamiWithDate:string];
    NSDictionary *dic = @{@"p":[NSString stringWithFormat:@"%ld",(long)_pageNum]};
    NSString *token = [CustomEncrypt jiamiWithDictionary:dic];
    NSDictionary *dict = @{@"p":[NSString stringWithFormat:@"%ld",(long)_pageNum],
                           @"token":token};
    [_manager POST:kMsg parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            if ([[result objectForKey:@"ret"] intValue] == 1) {
                NSLog(@"msgResult = %@",result);
                NSArray *array = (NSArray *)[result objectForKey:@"data"];
                if (_pageNum == 1) {
                    [_dataArray removeAllObjects];
                }
                [_dataArray addObjectsFromArray:array];
                [self.tableView reloadData];
            }else {
                NSString *msg = [result objectForKey:@"msg"];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
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

#pragma mark - 列表的代理
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 78.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray?_dataArray.count:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"msgRecordCell";
    MsgRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MsgRecordCell" owner:self options:nil] lastObject];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
    }
    NSDictionary *dict = [_dataArray objectAtIndex:indexPath.row];
    cell.titleLabel.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"title"]];
    NSString *dateStr = [NSString stringWithFormat:@"%@",[dict objectForKey:@"time"]];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[dateStr intValue]];
    NSString *string = [dateFormat stringFromDate:date];
    NSURL *picUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[dict objectForKey:@"picture"]]];
    [cell.imgView setImageWithURL:picUrl placeholderImage:[UIImage imageNamed:@"jpg_shouye_1"]];
    cell.dateLabel.text = string;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSDictionary *dict = [_dataArray objectAtIndex:indexPath.row];
//    ContentViewController  *contentVC = [[ContentViewController alloc] init];
//    contentVC.content = [NSString stringWithFormat:@"%@",[dict objectForKey:@"content"]];
//    [self.navigationController pushViewController:contentVC animated:YES];
    NSDictionary *dict = [_dataArray objectAtIndex:indexPath.row];
    NSInteger type = [[dict objectForKey:@"type"] integerValue];
    NSDictionary *dictionary = @{@"id":[dict objectForKey:@"id"]};
    if (type == 1) {
        //只有文本
        DetailViewController *detailVC = [[DetailViewController alloc] init];
      
        detailVC.isWithPic = NO;
        detailVC.infoDic = dictionary;
        BaseNavigationController *base = [[BaseNavigationController alloc] initWithRootViewController:detailVC];
        [self presentViewController:base animated:YES completion:nil];
    }else if (type == 2) {
        //图文
        DetailViewController *detailVC = [[DetailViewController alloc] init];
        detailVC.isWithPic = YES;
        
        detailVC.infoDic = dictionary;
        BaseNavigationController *base = [[BaseNavigationController alloc] initWithRootViewController:detailVC];
        [self presentViewController:base animated:YES completion:nil];
    }else if (type == 0) {
        //只有图
        PicturesViewController *picVC = [[PicturesViewController alloc] init];
        picVC.infoDic = dictionary;
       
        [self presentViewController:picVC animated:YES completion:nil];
    }

    
}


@end
