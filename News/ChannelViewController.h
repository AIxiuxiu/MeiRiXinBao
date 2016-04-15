//
//  ChannelViewController.h
//  News
//
//  Created by ink on 15/1/21.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChannelBtn.h"

@interface ChannelViewController : UIViewController<ChannelBtnDelegate>
@property (strong, nonatomic) IBOutlet UIView *selectedView;
- (IBAction)buttonClicked:(id)sender;

//长按排序或删除
@property (strong, nonatomic) IBOutlet UIButton *doneBtn;
- (IBAction)doneBtnClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *moreView;

@end
