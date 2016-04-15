//
//  SettingViewController.m
//  News
//
//  Created by ink on 15/1/15.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()
{
    NSDictionary *_dataDic;
}
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self UIConfig];
    [self addGesture];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark - 创建UI
- (void)UIConfig {
    NSString *wifi = [USER_DEFAULT objectForKey:@"wifi"];
    if (wifi) {
        self.loadPicBtn.selected = NO;
    }else {
        self.loadPicBtn.selected = YES;
    }
    
    
    NSString *string = [USER_DEFAULT objectForKey:@"systemFont"];
    self.fontLabel.text  = string;
    
    self.title = @"设置";
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
        
    }];
}

#pragma  mark - 手势
- (void)addGesture {
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClicked:)];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClicked:)];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClicked:)];
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClicked:)];
    UITapGestureRecognizer *tap5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClicked:)];
    
    [_fontView addGestureRecognizer:tap1];
    [_cachView addGestureRecognizer:tap2];
    [_adviceBackView addGestureRecognizer:tap3];
    [_aboutView addGestureRecognizer:tap5];
}
- (void)viewClicked:(UITapGestureRecognizer *)tap {
    UIView *view = [tap view];
    if (view == _fontView) {
        _fontVC = [[FontViewController alloc] init];
        _fontVC.delegate = self;
        [self.navigationController pushViewController:_fontVC animated:YES];
    }else if (view == _cachView){
        NSLog(@"缓存");
        NSFileManager *fileManger = [NSFileManager defaultManager];
        NSString *path = [NSString stringWithFormat:@"%@/Library/imgs",NSHomeDirectory()];
        long long size = [[fileManger attributesOfItemAtPath:path error:nil] fileSize];
        NSString *msg = [NSString stringWithFormat:@"共%.2fM缓存,确定清除?",size/1024.0];
        if ([msg isEqualToString:@"共0.00M缓存,确定清除?"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有缓存,不用清理" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        } 
        
    }else if (view == _adviceBackView){
         NSLog(@"意见反馈");
        YijianViewController *yijianVC = [[YijianViewController alloc] init];
        [self.navigationController pushViewController:yijianVC animated:YES];
    }else if (view == _aboutView){
         NSLog(@"关于");
        AboutUsViewController *aboutVC = [[AboutUsViewController alloc] init];
        [self.navigationController pushViewController:aboutVC animated:YES];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSFileManager *fileManger = [NSFileManager defaultManager];
        NSString *path = [NSString stringWithFormat:@"%@/Library/imgs",NSHomeDirectory()];
        NSString *path1 = [NSString stringWithFormat:@"%@/Library/newsFile.plist",NSHomeDirectory()];
        [fileManger removeItemAtPath:path error:nil];
        [fileManger removeItemAtPath:path1 error:nil];
        NSString *imagePath = [NSString stringWithFormat:@"%@/Library/imgs",NSHomeDirectory()];
        [fileManger createDirectoryAtPath:imagePath withIntermediateDirectories:NO attributes:nil error:nil];
        NSLog(@"删除成功");
    }
}
#pragma mark -FontViewControllerDelegate
- (void)selectFontWithString:(NSString *)font {
    self.fontLabel.text = font;
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

- (IBAction)wifiLoadBtnClicked:(id)sender {
    _autoLoadBtn.selected = !_autoLoadBtn.selected;
    
    NSLog(@"wifi自动离线");
}

- (IBAction)noWifiNopicBtnClicked:(id)sender {
    _loadPicBtn.selected = !_loadPicBtn.selected;
    if (_loadPicBtn.selected == YES) {
        [USER_DEFAULT setObject:nil forKey:@"wifi"];
    }else {
        [USER_DEFAULT setObject:@"yes" forKey:@"wifi"];
    }
    NSLog(@"WiFi下下载图片");
}
@end
