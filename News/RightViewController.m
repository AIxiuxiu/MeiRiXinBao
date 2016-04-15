//
//  RightViewController.m
//  News
//
//  Created by ink on 15/1/14.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import "RightViewController.h"

@interface RightViewController ()

@end

@implementation RightViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSString *userId = [USER_DEFAULT objectForKey:@"userId"];
    if (userId) {
        NSString *imgStr = [NSString stringWithFormat:@"%@",[USER_DEFAULT objectForKey:@"headImageStr"]];
        NSString *nick = [NSString stringWithFormat:@"%@",[USER_DEFAULT objectForKey:@"userNick"]];
        [self.headImageView setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:@"icon_youbianlan_1.png"]];
        [self.nickBtn setTitle:nick forState:UIControlStateNormal];
    }else {
        [self.headImageView setImage:[UIImage imageNamed:@"icon_youbianlan_1.png"]];
        [self.nickBtn setTitle:@"立即登录" forState:UIControlStateNormal];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    /*
     [USER_DEFAULT setObject:[dictionary objectForKey:@"avatar"] forKey:@"headImageStr"];
     [USER_DEFAULT setObject:[dictionary objectForKey:@"id"] forKey:@"userId"];
     [USER_DEFAULT setObject:[dictionary objectForKey:@"openid"] forKey:@"userOpenId"];
     [USER_DEFAULT setObject:[dictionary objectForKey:@"time"] forKey:@"userTime"];
     [USER_DEFAULT setObject:[dictionary objectForKey:@"type"] forKey:@"userType"];
     [USER_DEFAULT setObject:[dictionary objectForKey:@"username"] forKey:@"userNick"];
     */
    
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.borderColor = [[UIColor clearColor] CGColor];
    self.headImageView.layer.cornerRadius = 6.0;
    self.headImageView.layer.borderWidth = 1.0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:@"loginSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutSuccess) name:@"logoutSuccess" object:nil];
    [self addGesture];
    // Do any additional setup after loading the view from its nib.
}
- (void)loginSuccess {
    NSString *imgStr = [NSString stringWithFormat:@"%@",[USER_DEFAULT objectForKey:@"headImageStr"]];
    NSString *nick = [NSString stringWithFormat:@"%@",[USER_DEFAULT objectForKey:@"userNick"]];
    [self.headImageView setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:@"icon_youbianlan_1.png"]];
    [self.nickBtn setTitle:nick forState:UIControlStateNormal];
}
- (void)logoutSuccess {
    [self.headImageView setImage:[UIImage imageNamed:@"icon_youbianlan_1.png"]];
    [self.nickBtn setTitle:@"立即登录" forState:UIControlStateNormal];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 添加点击手势
- (void)addGesture {
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClicked:)];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClicked:)];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClicked:)];
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClicked:)];
    
    [self.discloseView  addGestureRecognizer:tap1];
    [self.helpView      addGestureRecognizer:tap2];
    [self.researchView  addGestureRecognizer:tap3];
    [self.voteView      addGestureRecognizer:tap4];
}
- (void)viewClicked:(UITapGestureRecognizer *)tap {
    UIView *view = [tap view];
    if (view == self.discloseView) {
        DiscloseViewController *discloseVC = [[DiscloseViewController alloc] init];
        discloseVC.isHelp = NO;
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:discloseVC];
        discloseVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:nav animated:YES completion:^{
            
        }];
    }else if (view == self.helpView) {
        DiscloseViewController *discloseVC = [[DiscloseViewController alloc] init];
        discloseVC.isHelp = YES;
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:discloseVC];
        discloseVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:nav animated:YES completion:^{
            
        }];
    }else if (view == self.researchView) {
        NSLog(@"这里是参与调查view");
        NSString *userId = [USER_DEFAULT objectForKey:@"userId"];
        if (userId) {
            DrawViewController *drawVc = [[DrawViewController alloc] init];
            drawVc.userId = userId;
            BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:drawVc];
            drawVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:nav animated:YES completion:^{
                
            }];
        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请登录后再抽奖" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }else if (view == self.voteView) {
        NSLog(@"这里是参与投票抽奖view");
        
    }
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)messageBtnClicked:(id)sender {
    NSLog(@"message");
    RecordViewController *recordVC = [[RecordViewController alloc] init];
    recordVC.isPush = NO;
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:recordVC];
    recordVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:nav animated:YES completion:^{
        
    }];
}

- (IBAction)commentBtnClicked:(id)sender {
    NSLog(@"comment");
    NSString *userId = [USER_DEFAULT objectForKey:@"userId"];
    if (userId) {
        MyCommentViewController *vc = [[MyCommentViewController alloc] init];
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:nav animated:YES completion:^{
            
        }];
    }else {
        LoginViewController *log = [[LoginViewController alloc] init];
        BaseNavigationController *nav =[[BaseNavigationController alloc] initWithRootViewController:log];
        log.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:nav animated:YES completion:nil];
    }
}

- (IBAction)collectBtnClicked:(id)sender {
    NSLog(@"collect");
    NSString *userId = [USER_DEFAULT objectForKey:@"userId"];
    if (userId) {
        CollectionViewController *collectionVC = [[CollectionViewController alloc] init];
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:collectionVC];
        collectionVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:nav animated:YES completion:^{
        
        }];
    }else {
        LoginViewController *log = [[LoginViewController alloc] init];
        BaseNavigationController *nav =[[BaseNavigationController alloc] initWithRootViewController:log];
        log.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:nav animated:YES completion:nil];
    }
    
}

- (IBAction)loginBtnClicked:(id)sender {
    //登录前：跳转登录页面
    //登陆后：跳转个人主页
    NSString *userId = [USER_DEFAULT objectForKey:@"userId"];
    if (userId) {
        ZhuyeViewController *zhuye = [[ZhuyeViewController alloc] init];
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:zhuye];
        zhuye.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:nav animated:YES completion:nil];
    }else {
        LoginViewController *log = [[LoginViewController alloc] init];
        BaseNavigationController *nav =[[BaseNavigationController alloc] initWithRootViewController:log];
        log.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:nav animated:YES completion:nil];
    }
}
@end
