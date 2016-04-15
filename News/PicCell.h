//
//  PicCell.h
//  News
//
//  Created by ink on 15/1/26.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PicCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *firstImageView;
@property (strong, nonatomic) IBOutlet UIImageView *secondImageView;
@property (strong, nonatomic) IBOutlet UIImageView *thirdImageView;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@end
