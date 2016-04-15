//
//  MyBackCell.m
//  News
//
//  Created by ink on 15/2/13.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import "MyBackCell.h"

@implementation MyBackCell

- (void)awakeFromNib {
    // Initialization code
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(newsViewTap)];
    [self.newsView addGestureRecognizer:tap];
}

#pragma mark - newsView点击
- (void)newsViewTap {
    [self.delegate newsViewClicked:self.dataDic];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
