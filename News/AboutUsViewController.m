//
//  AboutUsViewController.m
//  MedicineHall
//
//  Created by ink on 14/11/19.
//  Copyright (c) 2014年 ink. All rights reserved.
//

#import "AboutUsViewController.h"
@interface AboutUsViewController ()
{
    NSArray *_titles;//cell前面的标题
    NSArray *_values;//cell后面的值
}
@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self navigationBarConfig];
//    self.tableView.scrollEnabled = NO;
//    self.backView.layer.masksToBounds = YES;
//    self.backView.layer.cornerRadius = 6.0;
//    self.backView.layer.borderWidth = 1.0;
    self.backView.backgroundColor = [UIColor colorWithRed:0.96f green:0.98f blue:1.00f alpha:1.00f];
    self.titleLabel.textColor = [UIColor colorWithRed:0.20f green:0.50f blue:0.89f alpha:1.00f];
    _titles = @[@"企业邮箱"];
    _values = @[@"822997384@qq.com"];
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    CGRect frame = self.tableView.frame;
    frame.size.height = 60;
    self.tableView.frame = frame;
    // Do any additional setup after loading the view from its nib.
}

//导航栏创建
- (void)navigationBarConfig {
    self.navigationController.navigationBar.translucent = NO;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    label.text = @"联系我们";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:18];
    self.navigationItem.titleView = label;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 30);
    [button addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"icon_neirongxiangqing_1"] forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftItem;
  
}
//pop
- (void)backBtnClicked:(UIButton *)backBtn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"aboutUsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
  
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 100, 20)];
    titleLabel.text = [_titles objectAtIndex:indexPath.row];
    [cell.contentView addSubview:titleLabel];
    
    UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 20, 160, 20)];
    valueLabel.text = [_values objectAtIndex:indexPath.row];
    valueLabel.textAlignment = NSTextAlignmentRight;
    valueLabel.textColor = [UIColor colorWithRed:0.24f green:0.66f blue:0.94f alpha:1.00f];
    [cell.contentView addSubview:valueLabel];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *str = [_values objectAtIndex:indexPath.row];
    if (indexPath.row == 0) {
//        //打电话
//        str = [NSString stringWithFormat:@"tel:%@",str];
//        UIWebView *callWebView = [[UIWebView alloc] init];
//        [callWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
//        [self.view addSubview:callWebView];
//    }else if (indexPath.row == 1){
//        //跳转网页
//        str = [NSString stringWithFormat:@"http://%@",str];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
//    }else if (indexPath.row == 2){
//        //邮件
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto://%@",str]]];
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
