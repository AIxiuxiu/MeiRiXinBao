//
//  MyBackCell.h
//  News
//
//  Created by ink on 15/2/13.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MyBackCellDelegate;
@interface MyBackCell : UITableViewCell

//cell的数据
@property (strong, nonatomic) NSDictionary *dataDic;

//头像
@property (strong, nonatomic) IBOutlet UIImageView *headTopImage;

//昵称
@property (strong, nonatomic) IBOutlet UILabel *nickLabel;

//时间
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

//内容的Label
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
//新闻的view
@property (strong, nonatomic) IBOutlet UIView *newsView;

//新闻的图片
@property (strong, nonatomic) IBOutlet UIImageView *newsPic;

//新闻标题
@property (strong, nonatomic) IBOutlet UILabel *newsTitle;

//代理
@property (weak, nonatomic) id<MyBackCellDelegate>delegate;
@end

@protocol MyBackCellDelegate <NSObject>

- (void)newsViewClicked:(NSDictionary *)dic;

@end

