//
//  MyDiscloseCell.m
//  News
//
//  Created by ink on 15/4/8.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import "MyDiscloseCell.h"

@implementation MyDiscloseCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)fillData {
    self.titleLabel.text = [NSString stringWithFormat:@"%@",[self.dataDic objectForKey:@"title"]];
    
    NSString *sta = [NSString stringWithFormat:@"%@",[self.dataDic objectForKey:@"state"]];
    if ([sta isEqualToString:@"1"]) {
        self.stateLabel.text = @"审核通过";
    }else if ([sta isEqualToString:@"2"]){
        self.stateLabel.text = @"等待审核";
    }else if ([sta isEqualToString:@"3"]){
        self.stateLabel.text = @"拒绝";
    }
    NSArray *arr = [self.dataDic objectForKey:@"content"];
    //[imageView setImageWithURL:[NSURL URLWithString:[dictionary objectForKey:@"src"]] placeholderImage:[UIImage imageNamed:@"jpg_shouye_2"]];
    NSString *str1 = [[arr objectAtIndex:0] objectForKey:@"picture"];
    NSString *str2 = [[arr objectAtIndex:1] objectForKey:@"picture"];
    NSString *str3 = [[arr objectAtIndex:2] objectForKey:@"picture"];
    [self.fistImage setImageWithURL:[NSURL URLWithString:str1] placeholderImage:[UIImage imageNamed:@""]];//jpg_shouye_2
    [self.secondImage setImageWithURL:[NSURL URLWithString:str2] placeholderImage:[UIImage imageNamed:@""]];
    [self.thirdImage setImageWithURL:[NSURL URLWithString:str3] placeholderImage:[UIImage imageNamed:@""]];
}
@end
