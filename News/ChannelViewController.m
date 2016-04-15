//
//  ChannelViewController.m
//  News
//
//  Created by ink on 15/1/21.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import "ChannelViewController.h"
#import "BDKNotifyHUD.h"
@interface ChannelViewController ()
{
    NSMutableArray *_upArray;
    NSMutableArray *_moreArray;
    NSArray *allControls;
}
@end

@implementation ChannelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self UIConfig];
    allControls = [USER_DEFAULT objectForKey:@"allControls"];
    NSArray *a = [USER_DEFAULT objectForKey:@"selectControls"];
    NSArray *b = [USER_DEFAULT objectForKey:@"moreControls"];
    _upArray = [[NSMutableArray alloc] init];
    _moreArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in a) {
        [_upArray addObject:[dic objectForKey:@"title"]];
    }
    for (NSDictionary *dic in b) {
        [_moreArray addObject:[dic objectForKey:@"title"]];
    }
    /*
    int lie = 4;
    int hang = _upArray.count/4;
    if (_upArray.count%4 != 0) {
        hang += 1;
    }
    int hengxi = (SCREEN_W-60*4)/5;
    int shuxi = 10;
    for (int i=0; i<hang; i++) {
        for (int j=0; j<lie; j++) {
            if (i*4+j<_upArray.count) {
                ChannelBtn *btn = [[ChannelBtn alloc] initWithFrame:CGRectMake(hengxi+(60+hengxi)*j, 50+(shuxi+31)*i, 60, 30)];
                [btn setDelegate:self andTag:500+i*4+j andTitle:[_upArray objectAtIndex:i*4+j]];
                [self.selectedView addSubview:btn];
            }else {
                return;
            }
        }
    }
     */
    for (int i = 0; i<_upArray.count; i++) {
        ChannelBtn *button = (ChannelBtn *)[self.selectedView viewWithTag:500+i];
        [button setDelegate:self andTag:500+i andTitle:[_upArray objectAtIndex:i]];
        button.hidden = NO;
    }
    [self createMoreChannel];

}
- (void)createMoreChannel {
    int lie = 4;
    int hang = _moreArray.count/4;
    if (_moreArray.count%4 != 0) {
        hang += 1;
    }
    
    int hengxi = (SCREEN_W-60*4)/5;
    int shuxi = 10;
    self.moreView.contentSize = CGSizeMake(0, 41+shuxi*(hang+1)+30*hang);
    for (int i=0; i<hang; i++) {
        for (int j=0; j<lie; j++) {
            if (i*4+j<_moreArray.count) {
                UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(hengxi+(60+hengxi)*j, 50+(shuxi+31)*i, 60, 30)];
                btn.tag = 600+i*4+j;
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [btn setTitle:[_moreArray objectAtIndex:i*4+j] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageNamed:@"bt_yeka_2"] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(moreBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                [self.moreView addSubview:btn];
            }else {
                return;
            }
        }
    }
}

- (void)moreBtnClicked:(UIButton *)button {
    if (_upArray.count == 16) {
        [self displayNotification:nil titleStr:@" 不能在添加更多了 " Duration:0.8 time:0.2];
        return;
    }
    CGRect frame = button.frame;
    [UIView animateWithDuration:0.5 animations:^{
        button.frame = CGRectMake((SCREEN_W-60)/2, 0, 60, 30);
        button.alpha = 0.1;
    } completion:^(BOOL finished) {
        button.hidden = YES;
        button.frame = frame;
        [self moreViewDeleteBtn:button];
    }];
}
- (void)moreViewDeleteBtn:(UIButton *)button {
    for (int i=0; i<_moreArray.count; i++) {
        UIButton *btn = (UIButton *)[self.moreView viewWithTag:600+i];
        [btn removeFromSuperview];
    }
    NSString *string = button.titleLabel.text;
    [_moreArray removeObject:string];
    NSMutableArray *array = [self getDicArrayWithArray:_moreArray];
    [USER_DEFAULT setObject:array forKey:@"moreControls"];
    [_upArray addObject:string];
    NSMutableArray *array1 = [self getDicArrayWithArray:_upArray];
    [USER_DEFAULT setObject:array1 forKey:@"selectControls"];
    [self selectViewReLoad];
    [self createMoreChannel];
}
- (void)buttonTag:(NSInteger)tag andType:(ChannelBtnType)type {
    ChannelBtn *button = (ChannelBtn *)[self.selectedView viewWithTag:tag];
    button.channelBtnType = type;
}
#pragma mark - 创建UI
- (void)UIConfig {
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"频道订制";
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 30);
    [button addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"icon_neirongxiangqing_1"] forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftItem;
}
- (void)backButtonClicked {
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMainView" object:nil];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)buttonClicked:(id)sender {
    ChannelBtn *button1 = (ChannelBtn *)[self.selectedView viewWithTag:501];
    if (button1.channelBtnType == ChannelBtnEditting) {
        return;
    }
    for (int i=0; i<16; i++) {
        ChannelBtn *button = (ChannelBtn *)[self.selectedView viewWithTag:500+i];
        button.channelBtnType = ChannelBtnNormal;
    }
    ChannelBtn *btn = (ChannelBtn *)sender;
    btn.channelBtnType = ChannelBtnSelected;
}
#pragma mark - ChannelBtnDelegate

- (void)longPressWithTag:(NSInteger)tag {
    self.doneBtn.selected = YES;
    for (int i=0; i<16; i++) {
        if (i==0) {
            ChannelBtn *button = (ChannelBtn *)[self.selectedView viewWithTag:500+i];
            button.channelBtnType = ChannelBtnSelected;
        }else{
            ChannelBtn *button = (ChannelBtn *)[self.selectedView viewWithTag:500+i];
            button.channelBtnType = ChannelBtnEditting;
        }
    }
}
- (void)deleteWithTag:(NSInteger)tag {
    ChannelBtn *button = (ChannelBtn *)[self.selectedView viewWithTag:tag];
    NSString *string = button.titleLabel.text;
    [_upArray removeObject:string];
    NSMutableArray *array = [self getDicArrayWithArray:_upArray];
    [USER_DEFAULT setObject:array forKey:@"selectControls"];
    [self selectViewReLoad];
    [self moreViewAddBtnWithTitle:string];
}
- (void)panBtnWithFrame:(CGRect)frame {

}


- (void)moreViewAddBtnWithTitle:(NSString *)string {
    for (int i=0; i<_moreArray.count; i++) {
        UIButton *btn = (UIButton *)[self.moreView viewWithTag:600+i];
        [btn removeFromSuperview];
    }
    [_moreArray addObject:string];
    NSMutableArray *array1 = [self getDicArrayWithArray:_moreArray];
    [USER_DEFAULT setObject:array1 forKey:@"moreControls"];
    [self createMoreChannel];
}
- (IBAction)doneBtnClicked:(id)sender {
    if (self.doneBtn.selected == NO) {
        return;
    }else {
        self.doneBtn.selected = NO;
        for (int i=0; i<16; i++) {
            if (i==0) {
                ChannelBtn *button = (ChannelBtn *)[self.selectedView viewWithTag:500+i];
                button.channelBtnType = ChannelBtnSelected;
            }else{
                ChannelBtn *button = (ChannelBtn *)[self.selectedView viewWithTag:500+i];
                button.channelBtnType = ChannelBtnNormal;
            }
        }
    }
}

#pragma mark - selectedView reload
- (void)selectViewReLoad {
    for (int i = 0; i<_upArray.count; i++) {
        ChannelBtn *button = (ChannelBtn *)[self.selectedView viewWithTag:500+i];
        [button setDelegate:self andTag:500+i andTitle:[_upArray objectAtIndex:i]];
        button.hidden = NO;
    }
    for (int i=_upArray.count; i<16; i++) {
        ChannelBtn *button = (ChannelBtn *)[self.selectedView viewWithTag:500+i];
        button.hidden = YES;
    }
}


#pragma mark 提示
- (void)displayNotification:(NSString *)imageStr  titleStr:(NSString *)title Duration:(float)Duration time:(float)time
{
    //Duration展示之间 time消失动画时间
    BDKNotifyHUD *notify = [BDKNotifyHUD notifyHUDWithImage:[UIImage imageNamed:imageStr] text:title];
    CGFloat centerX= self.view.bounds.size.width/2;
    CGFloat centerY= self.view.bounds.size.height/2;
    notify.center = CGPointMake(centerX ,centerY);
    [self.view addSubview:notify];
    [notify presentWithDuration:Duration speed:time inView:self.view completion:^{
        [notify removeFromSuperview];
    }];
}

#pragma mark - 添加或者删除
- (NSMutableArray *)getDicArrayWithArray:(NSMutableArray *)muArray {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSString *str in muArray) {
        for (NSDictionary *dic in allControls) {
            if ([str isEqualToString:[dic objectForKey:@"title"]]) {
                [array addObject:dic];
                break;
            }
        }
    }
    return array;
}


@end
