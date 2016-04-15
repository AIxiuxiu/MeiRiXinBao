//
//  CommentCell.m
//  News
//
//  Created by ink on 15/1/30.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import "CommentCell.h"

@implementation CommentCell

- (void)awakeFromNib {
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.borderColor = [[UIColor clearColor] CGColor];
    self.headImageView.layer.cornerRadius = 23;
    self.headImageView.layer.borderWidth = 1.0;
    self.nickLabel.textColor = [UIColor colorWithRed:0.41f green:0.15f blue:0.13f alpha:1.00f];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@end
