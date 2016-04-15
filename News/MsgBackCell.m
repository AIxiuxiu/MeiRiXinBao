//
//  MsgBackCell.m
//  News
//
//  Created by ink on 15/2/14.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import "MsgBackCell.h"

@implementation MsgBackCell

- (void)awakeFromNib {
    // Initialization code
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(newsViewTap)];
    [self.newsView addGestureRecognizer:tap];
}
#pragma mark - newsView点击
- (void)newsViewTap {
    [self.delegate msgCellNewsViewClicked:self.dataDic];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)backBtnClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"myCommentBack" object:self.dataDic];
}
@end
