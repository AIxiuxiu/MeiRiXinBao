//
//  MyDiscloseCell.h
//  News
//
//  Created by ink on 15/4/8.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyDiscloseCell : UITableViewCell
@property (strong, nonatomic) NSDictionary *dataDic;

//标题
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
//
@property (strong, nonatomic) IBOutlet UIImageView *fistImage;
//
@property (strong, nonatomic) IBOutlet UIImageView *secondImage;
//
@property (strong, nonatomic) IBOutlet UIImageView *thirdImage;
//状态
@property (strong, nonatomic) IBOutlet UILabel *stateLabel;

- (void)fillData;


@end
