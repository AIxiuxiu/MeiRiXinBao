//
//  SectionView.m
//  News
//
//  Created by ink on 15/1/30.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import "SectionView.h"

@implementation SectionView
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"key = %@",key);
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
- (void)awakeFromNib {
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.borderColor = [[UIColor clearColor] CGColor];
    self.headImageView.layer.cornerRadius = 23;
    self.headImageView.layer.borderWidth = 1.0;
    self.nickLabel.textColor = [UIColor colorWithRed:0.41f green:0.15f blue:0.13f alpha:1.00f];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClicked)];
    [self addGestureRecognizer:tap];
}
- (void)viewClicked {
    [self.delegate sectionView:self andInfoDictionary:self.infoDic];
}
@end
