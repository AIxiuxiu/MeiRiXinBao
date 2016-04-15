//
//  SectionView.h
//  News
//
//  Created by ink on 15/1/30.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SectionViewDelegate;


@interface SectionView : UIView

@property (strong, nonatomic) NSDictionary *infoDic;

//头像
@property (strong, nonatomic) IBOutlet UIImageView *headImageView;
//昵称
@property (strong, nonatomic) IBOutlet UILabel *nickLabel;
//日期
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
//内容
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;

@property (strong, nonatomic) IBOutlet UILabel *numLabel;

@property (weak, nonatomic) id<SectionViewDelegate> delegate;

@end


@protocol SectionViewDelegate <NSObject>

- (void)sectionView:(SectionView *)sectionView andInfoDictionary:(NSDictionary *)infoDic;

@end