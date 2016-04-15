//
//  LoadingViewController.m
//  News
//
//  Created by mac pro on 15/2/5.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import "LoadingViewController.h"
#import "AppDelegate.h"
#import "RecordViewController.h"
@interface LoadingViewController ()

@end

@implementation LoadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *ad = [NSString stringWithFormat:@"%@",[USER_DEFAULT objectForKey:@"loadingAd"]];
    [self.imageView setImageWithURL:[NSURL URLWithString:ad]];
    
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(toMainVC) object:nil];
    [thread start];
    // Do any additional setup after loading the view from its nib.
}
- (void)toMainVC {
    sleep(5);
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate] ;
    [delegate mainVCConfig];
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

@end
