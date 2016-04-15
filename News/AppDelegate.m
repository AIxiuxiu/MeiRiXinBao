//
//  AppDelegate.m
//  News
//
//  Created by ink on 15/1/8.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import "AppDelegate.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"
#import "MobClick.h"



@interface AppDelegate ()
{
    NSDictionary *_launch;
}
@end
//552b3562fd98c5f56a0019c7
@implementation AppDelegate
//com.iyoudoo.dailyNews

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [XGPush handleLaunching: launchOptions];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    [MobClick startWithAppkey:@"552b3562fd98c5f56a0019c7" reportPolicy:BATCH   channelId:nil];
    
    [ShareSDK registerApp:@"59d6846ff96c"
     
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
                    default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"2395234916"
                                           appSecret:@"b4feb56ec00a68a1b8ccec2853a9202e"
                                         redirectUri:@"https://api.weibo.com/oauth2/default.html"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wx167b0b9cce61780a"
                                       appSecret:@"a98794b78f3a96589023aa84d929130e"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"1104106490"
                                      appKey:@"GfXxtZPLxdzKZUuw"
                                    authType:SSDKAuthTypeBoth];
                 break;
                    default:
                 break;
         }
     }];
      self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoginRequest:) name:@"LoginRequest" object:nil];
    [application setStatusBarHidden:NO];
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    NSString *tuisongOff = [USER_DEFAULT objectForKey:@"tuisongOff"];
    if (!tuisongOff) {
        [self XGpush:launchOptions];
    }
    
    NSString *font = [USER_DEFAULT objectForKey:@"systemFont"];
    if (!font) {
        [USER_DEFAULT setObject:@"小号字" forKey:@"systemFont"];
    }
    

    NSString * loadAd = [USER_DEFAULT objectForKey:@"loadingAd"];
    if (loadAd) {
        NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (userInfo) {
            
        }else {
            [self loadingShow];
        }
    }else {
        [self mainVCConfig];
    }
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}
- (void)jinruXG {
    [self XGpush:_launch];
}
#pragma mark - 信鸽
/*------------------------------------------------*/
/*-------------------信鸽--------------------*/
/*------------------------------------------------*/
- (void)XGpush:(NSDictionary *)launchOptions {
    [XGPush startApp:2200094803 appKey:@"I815PG52AYBL"];
    [XGPush setAccount:@"1134538430"];
    void (^successCallback)(void) = ^(void){
        //如果变成需要注册状态
        if(![XGPush isUnRegisterStatus])
        {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
            if (IOS8) {
                [self registerPushForIOS8];
            }else {
                [self registerPush];
            }
#else
       [self registerPush];     
#endif
        }
    };
    [XGPush initForReregister:successCallback];
    [XGPush handleLaunching: launchOptions];
    NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        [self handleWithUserInfo:userInfo];
    }


    //推送反馈回调版本示例
    void (^successBlock)(void) = ^(void){
        //成功之后的处理
        NSLog(@"[XGPush]handleLaunching's successBlock");
        NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (userInfo) {
            [self handleWithUserInfo:userInfo];
        }
    };
    void (^errorBlock)(void) = ^(void){
        //失败之后的处理
        NSLog(@"[XGPush]handleLaunching's errorBlock");
    };
   

    [XGPush handleLaunching:launchOptions successCallback:successBlock errorCallback:errorBlock];
}
#pragma mark -注册推送服务
- (void)registerPushForIOS8{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    
    //Types
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    //Actions
    UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
    
    acceptAction.identifier = @"ACCEPT_IDENTIFIER";
    acceptAction.title = @"Accept";
    acceptAction.activationMode = UIUserNotificationActivationModeForeground;
    acceptAction.destructive = NO;
    acceptAction.authenticationRequired = NO;
    
    //Categories
    UIMutableUserNotificationCategory *inviteCategory = [[UIMutableUserNotificationCategory alloc] init];
    
    inviteCategory.identifier = @"INVITE_CATEGORY";
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextDefault];
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextMinimal];
    NSSet *categories = [NSSet setWithObjects:inviteCategory, nil];
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
}

- (void)registerPush{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString * deviceTokenStr = [XGPush registerDevice:deviceToken];
   
    void (^successBlock)(void) = ^(void){
        //成功之后的处理
        NSLog(@"[XGPush]register successBlock ,deviceToken: %@",deviceTokenStr);
    };
    
    void (^errorBlock)(void) = ^(void){
        //失败之后的处理
        NSLog(@"[XGPush]register errorBlock");
    };
    //注册设备
    [[XGSetting getInstance] setChannel:@"appstore"];
    [[XGSetting getInstance] setGameServer:@"11"];
    [XGPush registerDevice:deviceToken successCallback:successBlock errorCallback:errorBlock];
    
    //如果不需要回调
    //[XGPush registerDevice:deviceToken];
    
    //打印获取的deviceToken的字符串
    NSLog(@"deviceTokenStr is %@",deviceTokenStr);
}
//设备的token值获取不到进入此函数
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSLog(@"来这里了啊啊");
    NSString *str = [NSString stringWithFormat: @"Error: %@",err];
    
    NSLog(@"%@",str);
    
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo{
    //推送反馈(app运行时)
    [XGPush handleReceiveNotification:userInfo];
   
    if (userInfo) {
        [self handleWithUserInfo:userInfo];
    }
}
- (void)handleWithUserInfo:(NSDictionary *)userInfo {
    NSLog(@"userInfo = %@",userInfo);
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
   
//    RecordViewController *recordVC = [[RecordViewController alloc] init];
//    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:recordVC];
//    recordVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    recordVC.isPush = YES;
//    self.window.rootViewController = nav;]
    NSInteger type = [[userInfo objectForKey:@"type"] integerValue];
    NSDictionary *dictionary = @{@"id":[userInfo objectForKey:@"id"]};
    if (type == 1) {
        //只有文本
        DetailViewController *detailVC = [[DetailViewController alloc] init];
        detailVC.isPush = YES;
        detailVC.isWithPic = NO;
        detailVC.infoDic = dictionary;
        BaseNavigationController *base = [[BaseNavigationController alloc] initWithRootViewController:detailVC];
        self.window.rootViewController = base;
    }else if (type == 2) {
        //图文
        DetailViewController *detailVC = [[DetailViewController alloc] init];
        detailVC.isWithPic = YES;
        detailVC.isPush = YES;
        detailVC.infoDic = dictionary;
        BaseNavigationController *base = [[BaseNavigationController alloc] initWithRootViewController:detailVC];
        self.window.rootViewController = base;
    }else if (type == 0) {
        //只有图
        PicturesViewController *picVC = [[PicturesViewController alloc] init];
        picVC.infoDic = dictionary;
        picVC.isPush = YES;
        self.window.rootViewController = picVC;
    }
}

/*------------------------------------------------*/
/*----------------------end-----------------------*/
/*------------------------------------------------*/
#pragma mark - load广告页面
- (void)loadingShow {
    LoadingViewController  *loadVC = [[LoadingViewController alloc] init];
    self.window.rootViewController = loadVC;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

#pragma mark - 登陆的请求
- (void)LoginRequest:(NSNotification *)notification {
    NSDictionary *dataDic = (NSDictionary *)notification.object;
    NSString *imgStr = [dataDic objectForKey:@"headImage"];
    NSString *nickName = [dataDic objectForKey:@"nickName"];
    NSString *openId = [dataDic objectForKey:@"openId"];
    NSString *type = [dataDic objectForKey:@"type"];
    if (_manager) {
        _manager = nil;
    }
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//如果报接口类型不一致请替换
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *dic = @{@"openid":openId,
                          @"username":nickName,
                          @"avatar":imgStr,
                          @"type":type};
    NSString *token = [CustomEncrypt jiamiWithDictionary:dic];
    NSDictionary *dict = @{@"openid":openId,
                           @"username":nickName,
                           @"avatar":imgStr,
                           @"type":type,
                           @"token":token};
    [_manager POST:kLogin parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"login = %@",responseObject);
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([[result objectForKey:@"ret"]intValue] ==1) {
            NSDictionary *dictionary = [result objectForKey:@"data"];
            [USER_DEFAULT setObject:[dictionary objectForKey:@"avatar"] forKey:@"headImageStr"];
            [USER_DEFAULT setObject:[dictionary objectForKey:@"id"] forKey:@"userId"];
            [USER_DEFAULT setObject:[dictionary objectForKey:@"openid"] forKey:@"userOpenId"];
            [USER_DEFAULT setObject:[dictionary objectForKey:@"time"] forKey:@"userTime"];
            [USER_DEFAULT setObject:[dictionary objectForKey:@"type"] forKey:@"userType"];
            [USER_DEFAULT setObject:[dictionary objectForKey:@"username"] forKey:@"userNick"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:nil];
        }else {
            NSString *msg = [result objectForKey:@"msg"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@,%s",error.description,__FUNCTION__);
    }];
}

#pragma mark -重写fangfa


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    NSLog(@"qqqqqqqqqqqqqqqqqqqqq");
    NSString *string =[url absoluteString];
    if([string rangeOfString:@"2395234916"].location !=NSNotFound)//_roaldSearchText
    {
        return [WeiboSDK handleOpenURL:url delegate:nil];
        
    }else if ([string rangeOfString:@"wx167b0b9cce61780a"].location !=NSNotFound)
    {
        return [WXApi handleOpenURL:url delegate:nil];
        
    }else if([string rangeOfString:@"MyApp"].location !=NSNotFound)
    {
        NSLog(@"过来刁我把1");

        [application setApplicationIconBadgeNumber:10];

        return YES;
        
    }else
    {
        return [QQApiInterface handleOpenURL:url delegate:nil];
    }
   
}

- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary *)options
{
    NSString *string =[url absoluteString];
    if([string rangeOfString:@"2395234916"].location !=NSNotFound)//_roaldSearchText
    {
        return [WeiboSDK handleOpenURL:url delegate:nil];

    }else if ([string rangeOfString:@"wx167b0b9cce61780a"].location !=NSNotFound)
    {
        return [WXApi handleOpenURL:url delegate:nil];

    }else if([string rangeOfString:@"com.iyoudoo.dailyNews://"].location !=NSNotFound)
    {
        NSLog(@"过来刁我把2");
        [app setApplicationIconBadgeNumber:10];
        return YES;
        
    }else
    {
        return [QQApiInterface handleOpenURL:url delegate:nil];

    }
    

}
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    NSLog(@"wwwwwwwwww");
     NSString *URLString = [url absoluteString];
    if([URLString rangeOfString:@"com.iyoudoo.dailyNews://"].location !=NSNotFound)
    {
        NSLog(@"过来刁我把2222222");
        [application setApplicationIconBadgeNumber:10];
        return YES;
        
    }else
    {
       return NO;
    }
}
/*
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
//        NSString *title = NSLocalizedString(@"认证结果", nil);
//        NSString *message = [NSString stringWithFormat:@"%@: %d\nresponse.userId: %@\nresponse.accessToken: %@\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode,[(WBAuthorizeResponse *)response userID], [(WBAuthorizeResponse *)response accessToken],  NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil), response.requestUserInfo];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
//                                                        message:message
//                                                       delegate:nil
//                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
//                                              otherButtonTitles:nil];
        
        self.wbtoken = [(WBAuthorizeResponse *)response accessToken];
        self.wbCurrentUserID = [(WBAuthorizeResponse *)response userID];
//        [alert show];
        NSMutableDictionary * param = [[NSMutableDictionary alloc]initWithCapacity:2];
        
        [param setObject:self.wbtoken forKey:@"access_token"];
        [param setObject:self.wbCurrentUserID forKey:@"uid"];
        NSString * userInfoUrl = @"https://api.weibo.com/2/users/show.json";
        [WBHttpRequest requestWithAccessToken:self.wbtoken url:userInfoUrl httpMethod:@"GET" params:param delegate:self withTag:@"userInfo"];
    }
}
- (void)request:(WBHttpRequest *)request didFinishLoadingWithDataResult:(NSData *)data
{
    id ob = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if ([ob isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary * dict =  (NSDictionary *)ob;
        NSLog(@"dict = %@",dict);
        NSString *headImageStr = [dict objectForKey:@"profile_image_url"];
        NSString *openId = [dict objectForKey:@"idstr"];
        NSString *nickName = [dict objectForKey:@"name"];
        NSDictionary *dic = @{@"headImage":headImageStr,
                              @"nickName":nickName,
                              @"openId":openId,
                              @"type":@"0"};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginRequest" object:dic];
    }
}
 */
#pragma mark -主界面
- (void)mainVCConfig {
    if (!_silder) {
        _leftVC = [[LeftViewController alloc] init];
        _rightVC = [[RightViewController alloc] init];
        _silder = [[MMDrawerController alloc] initWithCenterViewController:_leftVC.centerVC leftDrawerViewController:_leftVC rightDrawerViewController:_rightVC];
        [_silder setMaximumLeftDrawerWidth:220.0];
        [_silder setMaximumRightDrawerWidth:220.0];
        [_silder setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
        [_silder setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
        [_silder setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
            MMDrawerControllerDrawerVisualStateBlock block;
            block = [MMDrawerVisualState parallaxVisualStateBlockWithParallaxFactor:2.0];
            block(drawerController, drawerSide, percentVisible);
        }];
    }
    self.window.rootViewController = _silder;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}



- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
