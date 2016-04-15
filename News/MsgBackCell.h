//
//  MsgBackCell.h
//  News
//
//  Created by ink on 15/2/14.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MsgBackCellDelegate <NSObject>

- (void)msgCellNewsViewClicked:(NSDictionary *)dic;

@end
@interface MsgBackCell : UITableViewCell
@property (strong, nonatomic) NSDictionary *dataDic;
@property (weak, nonatomic) id<MsgBackCellDelegate>delegate;
//头像
@property (strong, nonatomic) IBOutlet UIImageView *headTopImage;
//别人昵称
@property (strong, nonatomic) IBOutlet UILabel *otherNickLabel;
//日期
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
//内容
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;

@property (strong, nonatomic) IBOutlet UIImageView *newsPic;
@property (strong, nonatomic) IBOutlet UILabel *newsTitle;
@property (strong, nonatomic) IBOutlet UILabel *myNickLabel;
@property (strong, nonatomic) IBOutlet UILabel *myCommentLabel;
@property (strong, nonatomic) IBOutlet UIView *newsView;

//回复按钮click
- (IBAction)backBtnClicked:(id)sender;


@end
