//
//  RecordViewController.h
//  News
//
//  Created by ink on 15/2/12.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MsgRecordCell.h"
#import "ContentViewController.h"

#import "MJRefresh.h"

@interface RecordViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    AFHTTPRequestOperationManager *_manager;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) BOOL isPush;
@end
