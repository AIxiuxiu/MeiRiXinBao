//
//  MsgBackView.h
//  News
//
//  Created by ink on 15/2/14.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MsgBackCell.h"
#import "MJRefresh.h"
@protocol MsgBackDelegate;
@interface MsgBackView : UIView<UITableViewDataSource,UITableViewDelegate,MsgBackCellDelegate>
{
    AFHTTPRequestOperationManager *_manager;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView1;
@property(weak, nonatomic) id<MsgBackDelegate>delegate;
@end
@protocol MsgBackDelegate <NSObject>

- (void)newsViewClicked:(NSDictionary *)dic;
- (void)commentVC:(NSString *)commentId;

@end