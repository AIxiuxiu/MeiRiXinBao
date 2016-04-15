//
//  LoginViewController.m
//  News
//
//  Created by ink on 15/1/19.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import "LoginViewController.h"
#import "WeiboSDK.h"
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>
@interface LoginViewController ()
{
    NSString *_openId;
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSString *stutes = [[NSUserDefaults standardUserDefaults]objectForKey:@"status"];
//    if ([stutes isEqualToString:@"0"]) {
//        self.weiboBtn.hidden = YES;
//        self.qqBtn.hidden = YES;
//    }

    self.logBtn.layer.cornerRadius = 6.0;
    self.registerBtn.layer.cornerRadius = 6.0;
    self.logBtn.layer.borderWidth = 0.5;
    self.registerBtn.layer.borderWidth = 0.5;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1, 0, 0, 1 });
    self.logBtn.layer.borderColor = colorref;
    self.registerBtn.layer.borderColor = colorref;
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:@"loginSuccess" object:nil];
    self.title = @"登录";
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 30);
    [button addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"icon_neirongxiangqing_1"] forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftItem;

    
    // Do any additional setup after loading the view from its nib.
}

- (void)loginSuccess {
    [self backButtonClicked];
}
- (void)backButtonClicked {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)loginBtnClicked:(id)sender {
    BaseLogViewController *baseLog = [[BaseLogViewController alloc] init];
    [self.navigationController pushViewController:baseLog animated:YES];
}

- (IBAction)resignBtnClicked:(id)sender {
    ResignViewController *resignVc = [[ResignViewController alloc] init];
    [self.navigationController pushViewController:resignVc animated:YES];
}

- (void)weiboBtnClicked:(id)sender {
    NSLog(@"点击微博按钮了");
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    NSInvocationOperation *invocation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(banZhuanPlus) object:nil];
    [invocation start];
    [queue setMaxConcurrentOperationCount:1];//设置最大并行数;

//    [WeiboSDK enableDebugMode:YES];
//    [ShareSDK ssoEnabled:YES];
    

//        [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
//            NSLog(@"aaaaaaaa");
//            if (result) {
//                
//                //打印输出用户uid：
//                NSLog(@"uid = %@",[userInfo uid]);
//                //打印输出用户昵称：
//                NSLog(@"name = %@",[userInfo nickname]);
//                //打印输出用户头像地址：
//                NSLog(@"icon = %@",[userInfo profileImage]);
//                
//                NSDictionary *dic = @{@"headImage":[userInfo profileImage],
//                                      @"nickName":[userInfo nickname],
//                                      @"openId":[userInfo uid],
//                                      @"type":@"1"};
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginRequest" object:dic];
//            }else {
//                NSLog(@"授权失败!error code == %ld, error code == %@", (long)[error errorCode], [error errorDescription]);
//            }
//        }];
 
    [ShareSDK getUserInfo:SSDKPlatformTypeSinaWeibo
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             
             NSLog(@"uid=%@",user.uid);
             NSLog(@"%@",user.credential);
             NSLog(@"token=%@",user.credential.token);
             NSLog(@"nickname=%@",user.nickname);
             NSDictionary *dic = @{@"headImage":user.credential,
                                     @"nickName":user.nickname,
                                     @"openId":user.uid,
                                     @"type":@"1"};
               [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginRequest" object:dic];

         }
         
         else
         {
             NSLog(@"%@",error);
         }
         
     }];
}

- (void)qqBtnClicked:(id)sender {
//    [ShareSDK getUserInfoWithType:ShareTypeQQSpace authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
//        if (result) {
//            
//        //打印输出用户uid：
//        NSLog(@"uid = %@",[userInfo uid]);
//        //打印输出用户昵称：
//        NSLog(@"name = %@",[userInfo nickname]);
//        //打印输出用户头像地址：
//        NSLog(@"icon = %@",[userInfo profileImage]);
//        
//        NSDictionary *dic = @{@"headImage":[userInfo profileImage],
//                              @"nickName":[userInfo nickname],
//                              @"openId":[userInfo uid],
//                              @"type":@"0"};
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginRequest" object:dic];
//        }else {
//            NSLog(@"授权失败!error code == %ld, error code == %@", (long)[error errorCode], [error errorDescription]);
//        }
//    }];
    
    [ShareSDK getUserInfo:SSDKPlatformTypeQQ
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             
             NSLog(@"uid=%@",user.uid);
             NSLog(@"%@",user.credential);
             NSLog(@"token=%@",user.credential.token);
             NSLog(@"nickname=%@",user.nickname);
             NSDictionary *dic = @{@"headImage":user.credential,
                                   @"nickName":user.nickname,
                                   @"openId":user.uid,
                                   @"type":@"0"};
             [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginRequest" object:dic];
         }
         
         else
         {
             NSLog(@"%@",error);
         }
         
     }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//- (IBAction)weiboBtnClicked:(id)sender {
//    if (![WeiboSDK isWeiboAppInstalled]) {
//        NSURL *url = [NSURL URLWithString:[WeiboSDK getWeiboAppInstallUrl]];
//        [[UIApplication sharedApplication] openURL:url];
//        return;
//    }
//    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
//    request.shouldShowWebViewForAuthIfCannotSSO = YES;
//    request.redirectURI = weibo_redirectURL;
//    request.scope = @"all";
////    request.userInfo = @{@"SSO_From": @"LoginViewController",
////                         @"Other_Info_1": [NSNumber numberWithInt:123],
////                         @"Other_Info_2": @[@"obj1", @"obj2"],
////                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
//    [WeiboSDK sendRequest:request];
//}
//
//- (IBAction)qqBtnClicked:(id)sender {
//    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1104106490" andDelegate:self];
//    NSArray *permissions = [NSArray arrayWithObjects:
//                     kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
//                            kOPEN_PERMISSION_GET_USER_INFO,
//                    nil];
//    [_tencentOAuth authorize:permissions inSafari:NO];
//}
//- (void)tencentDidLogin {
//    if (_tencentOAuth.accessToken && 0 != [_tencentOAuth.accessToken length]){
////        NSLog(@"%@",_tencentOAuth.openId);
//        _openId = _tencentOAuth.openId;
//    }
//    BOOL getInfo = [_tencentOAuth getUserInfo];
//    if (getInfo) {
//        
//    }else {
//        
//    }
//
//}
//- (void)getUserInfoResponse:(APIResponse*) response{
////    NSLog(@"1111  %@",response.jsonResponse);
////    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoginRequest:) name:@"LoginRequest" object:nil];
//    NSString *nickName = [response.jsonResponse objectForKey:@"nickname"];
//    NSString *headImageStr = [response.jsonResponse objectForKey:@"figureurl_qq_1"];
//    NSDictionary *dic = @{@"headImage":headImageStr,
//                          @"nickName":nickName,
//                          @"openId":_openId,
//                          @"type":@"1"};
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginRequest" object:dic];
//}
//- (void)tencentDidLogout {
//    //退出登录
//}
@end
