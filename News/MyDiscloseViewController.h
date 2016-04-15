//
//  MyDiscloseViewController.h
//  News
//
//  Created by ink on 15/4/8.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyDiscloseCell.h"
@interface MyDiscloseViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    AFHTTPRequestOperationManager *_manager;
}
//判断是爆料还是求助
@property (assign, nonatomic) BOOL isHelp;
//列表
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
