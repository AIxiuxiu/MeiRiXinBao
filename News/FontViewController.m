//
//  FontViewController.m
//  News
//
//  Created by ink on 15/1/27.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import "FontViewController.h"

@interface FontViewController ()
{
    NSArray *_dataArray;
}
@end

@implementation FontViewController
- (void)UIConfig {
    self.title = @"字号设置";
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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self UIConfig];
    _dataArray = @[@"小号字",@"中号字",@"大号字"];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"fontCell"];
    cell.textLabel.text = [_dataArray objectAtIndex:indexPath.row];
    NSString *string = [NSString stringWithFormat:@"%@",[USER_DEFAULT objectForKey:@"systemFont"]];
    if ([string isEqualToString:cell.textLabel.text]) {
        cell.contentView.backgroundColor = [UIColor colorWithRed:0.88f green:0.94f blue:0.99f alpha:1.00f];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *string = [_dataArray objectAtIndex:indexPath.row];
    [USER_DEFAULT setObject:string forKey:@"systemFont"];
    [self.tableView reloadData];
    [self.delegate selectFontWithString:string];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
