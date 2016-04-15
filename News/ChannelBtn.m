//
//  ChannelBtn.m
//  News
//
//  Created by ink on 15/1/21.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import "ChannelBtn.h"

@implementation ChannelBtn
{
    UIButton *deleteBtn;
    UIPanGestureRecognizer *pan;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createBtn];
    }
    return self;
}
- (void)awakeFromNib {
    [self createBtn];
}
- (void)createBtn {
    UILongPressGestureRecognizer *longP = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressClicked)];
    longP.delegate = self;
    [self addGestureRecognizer:longP];
    
    deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = CGRectMake(35, -10, 40, 30);
    [deleteBtn setImage:[UIImage imageNamed:@"bt_yeka_4(1)"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    deleteBtn.hidden = YES;
    [self addSubview:deleteBtn];
    self.highlighted = NO;
    [self setBackgroundImage:[UIImage imageNamed:@"bt_yeka_2"] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:@"bt_yeka_1"] forState:UIControlStateSelected];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    self.channelBtnType = ChannelBtnNormal;
    [self addObserver:self forKeyPath:@"channelBtnType" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}
- (void)longPressClicked {
    [self.delegate longPressWithTag:self.tag];
}
- (void)deleteBtnClicked {
    [self.delegate deleteWithTag:self.tag];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    NSLog(@"change = %@",change);
    NSInteger type = [[change objectForKey:@"new"] integerValue];
    switch (type) {
        case ChannelBtnNormal:
        {
            deleteBtn.hidden = YES;
            self.selected = NO;
//            [self removeGestureRecognizer:pan];
        }
            break;
        case ChannelBtnSelected:
        {
            deleteBtn.hidden = YES;
            self.selected = YES;
//            [self removeGestureRecognizer:pan];
        }
            break;
        case ChannelBtnEditting:
        {
            self.selected = NO;
            deleteBtn.hidden = NO;
//            if (!pan) {
//                pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerDo:)];
//                pan.delegate = self;
//            }
//            [self addGestureRecognizer:pan];
        }
            break;
        default:
            break;
    }
}

- (void)panGestureRecognizerDo:(UIPanGestureRecognizer *)panG {
    [self.superview bringSubviewToFront:self];
    
    CGPoint pt=[pan translationInView:self];
    
    pan.view.center=CGPointMake(pan.view.center.x+pt.x, pan.view.center.y+pt.y);
    
    [pan setTranslation:CGPointMake(0, 0) inView:self];
    
    [self.delegate panBtnWithFrame:self.frame];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)dealloc {
    [self removeObserver:self forKeyPath:@"channelBtnType" context:nil];
}
- (void)setDelegate:(id<ChannelBtnDelegate>)delegate andTag:(NSInteger)tag andTitle:(NSString *)title {
    self.delegate = delegate;
    self.tag = tag;
    [self setTitle:title forState:UIControlStateNormal];
}
#pragma mark - 允许同时
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
