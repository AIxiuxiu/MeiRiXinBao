//
//  ChannelBtn.h
//  News
//
//  Created by ink on 15/1/21.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import <UIKit/UIKit.h>
enum ChannelBtnType {
    ChannelBtnNormal = 0,
    ChannelBtnSelected,
    ChannelBtnEditting
};

typedef enum ChannelBtnType ChannelBtnType;

@protocol ChannelBtnDelegate <NSObject>

- (void)deleteWithTag:(NSInteger)tag;
- (void)longPressWithTag:(NSInteger)tag;

- (void)panBtnWithFrame:(CGRect)frame;

@end

@interface ChannelBtn : UIButton<UIGestureRecognizerDelegate>

@property (assign, nonatomic) ChannelBtnType channelBtnType;
@property (weak, nonatomic) id<ChannelBtnDelegate>delegate;
- (void)setDelegate:(id<ChannelBtnDelegate>)delegate andTag:(NSInteger)tag andTitle:(NSString *)title;
@end
