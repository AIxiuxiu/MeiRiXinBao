//
//  CommentCell.h
//  News
//
//  Created by ink on 15/1/30.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentCell : UITableViewCell
//头像
@property (strong, nonatomic) IBOutlet UIImageView *headImageView;
//昵称
@property (strong, nonatomic) IBOutlet UILabel *nickLabel;
//日期
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
//内容
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UILabel *numLabel;
@end
