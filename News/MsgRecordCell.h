//
//  MsgRecordCell.h
//  News
//
//  Created by ink on 15/2/12.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MsgRecordCell : UITableViewCell
//消息标题
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
//日期的label
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@property (strong, nonatomic) IBOutlet UIImageView *imgView;

@end
