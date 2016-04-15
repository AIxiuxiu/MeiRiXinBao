//
//  PicturesViewController.m
//  News
//
//  Created by ink on 15/1/28.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import "PicturesViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
@interface PicturesViewController ()
{
    NSArray *_dataArray;
    NSString *_newsId;
    NSString *_currentUrl;
}
@end

@implementation PicturesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    _HUD.labelText = @"loading...";
    [self.view addSubview:_HUD];
       //    if (self.getFileData) {
//        [self fillData:self.fileData];
//    }else {
//    [self getData];
//    }
    [self getData];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getData {
    if (_manager) {
        _manager = nil;
    }
    NSString *infoId = [self.infoDic objectForKey:@"id"];
    NSDictionary *dic = @{@"id":infoId};
    NSString *token = [CustomEncrypt jiamiWithDictionary:dic];
    NSDictionary *dict = @{@"id":infoId,
                           @"token":token};
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//如果报接口类型不一致请替换
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [_HUD show:YES];
    [_manager POST:knewsDetails parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        [_HUD hide:YES];
        NSLog(@"result = %@",result);
        if ([[result objectForKey:@"ret"] intValue] == 1) {
            if ([[result objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dictionary = [result objectForKey:@"data"];
                currentTitle = [dictionary objectForKey:@"title"];
               
                _newsId = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"id"]];
                //[self.commentBtn setTitle:[NSString stringWithFormat:@"%@",[dictionary objectForKey:@"comment"]] forState:UIControlStateNormal];
                can_comment = [dictionary objectForKey:@"can_comment"];
                NSLog(@"can_comment=%@",can_comment);
                if ([can_comment intValue] == 0) {
                    self.commentBtn.hidden = YES;
                    NSLog(@"aaaaaaaaa");
                }

                _dataArray = [dictionary objectForKey:@"content"];
                if (_dataArray==nil||_dataArray.count==0) {
                    return;
                }
                [self refreshView];
            }
        }else {
            NSString *msg = [result objectForKey:@"msg"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_HUD hide:YES];
        NSLog(@"error:%@",error.description);
    }];
}
- (void)fillData:(NSDictionary *)dictionary {
    _newsId = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"id"]];
    [self.commentBtn setTitle:[NSString stringWithFormat:@"%@",[dictionary objectForKey:@"comment"]] forState:UIControlStateNormal];
    _dataArray = [dictionary objectForKey:@"content"];
    if (_dataArray==nil||_dataArray.count==0) {
        return;
    }
    [self refreshView];
}
- (void)refreshView {
    if (_dataArray.count>1) {
        self.backScrollView.contentSize = CGSizeMake(_dataArray.count*SCREEN_W, 0);
        self.backScrollView.pagingEnabled = YES;
        self.backScrollView.delegate = self;
        for (int i=0; i<_dataArray.count; i++) {
            if (i==0) {
                NSDictionary *dic = [_dataArray objectAtIndex:0];
                [self.firstImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"picture"]]] placeholderImage:[UIImage imageNamed:@"jpg_neirongxiangqing_1"]];
                _currentUrl = [NSString stringWithFormat:@"%@",[dic objectForKey:@"picture"]];
                self.textView.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"text"]];
                
            }else {
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.firstImageView.frame];
                imageView.contentMode = UIViewContentModeScaleAspectFit;
                UITextView *textView1 = [[UITextView alloc] initWithFrame:self.textView.frame];
                textView1.backgroundColor = [UIColor clearColor];
                textView1.textColor = [UIColor whiteColor];
                textView1.editable = NO;
                CGRect frame = imageView.frame;
                frame.origin.x = i*SCREEN_W;
                imageView.frame = frame;
                CGRect frame1 = textView1.frame;
                frame1.origin.x = i*SCREEN_W;
                textView1.frame = frame1;
                [self.backScrollView addSubview:imageView];
                [self.backScrollView addSubview:textView1];
                NSDictionary *dic = [_dataArray objectAtIndex:i];
                [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"picture"]]] placeholderImage:[UIImage imageNamed:@"jpg_neirongxiangqing_1"]];
                textView1.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"text"]];
            }
        }
    }else {
        NSDictionary *dic = [_dataArray objectAtIndex:0];
        [self.firstImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"picture"]]] placeholderImage:[UIImage imageNamed:@"jpg_neirongxiangqing_1"]];
        _currentUrl = [NSString stringWithFormat:@"%@",[dic objectForKey:@"picture"]];
        self.textView.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"text"]];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x/SCREEN_W;
    NSDictionary *dic = [_dataArray objectAtIndex:index];
    _currentUrl = [NSString stringWithFormat:@"%@",[dic objectForKey:@"picture"]];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backBtnClicked:(id)sender {
    if (self.isPush) {
        AppDelegate *dele = APPDELEGATE;
        [dele mainVCConfig];
    }else{
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

- (IBAction)commentBtnClicked:(id)sender {
    NSString *userId = [USER_DEFAULT objectForKey:@"userId"];
    if (!userId) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        BaseNavigationController *base = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:base animated:YES completion:nil];
        return;
    }
    if (_newsId) {
        CommentViewController *commentVC = [[CommentViewController alloc] init];
        commentVC.isFromPic = YES;
        commentVC.newsId = _newsId;
        commentVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        BaseNavigationController *base = [[BaseNavigationController alloc] initWithRootViewController:commentVC];
        [self presentViewController:base animated:YES completion:nil];
    }
}
#pragma mark - 分享
- (IBAction)shareBtnClicked:(id)sender {
//    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"icon" ofType:@"png"];
    NSString *url = [NSString stringWithFormat:@"http://news.iyousoon.com/Api/Show/share/id/%@",[self.infoDic objectForKey:@"id"]];
//    //构造分享内容
//    id<ISSContent> publishContent = [ShareSDK content:self.textView.text
//                                       defaultContent:nil
//                                                image:[ShareSDK imageWithUrl:_currentUrl]
//                                                title:@"每日新报"
//                                                  url:url
//                                          description:nil
//                                            mediaType:SSPublishContentMediaTypeNews];
    
    //1、创建分享参数
    NSLog(@"_currentUrl=%@",_currentUrl);
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"180" ofType:@"png"];
    NSArray* imageArray = @[[UIImage imageNamed:imagePath]];
    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:self.textView.text
                                         images:imageArray
                                            url:[NSURL URLWithString:url]
                                          title:currentTitle
                                           type:SSDKContentTypeAuto];
        [shareParams SSDKSetupSinaWeiboShareParamsByText:[NSString stringWithFormat:@"%@%@",currentTitle,[NSURL URLWithString:url]] title:self.textView.text
 image:imageArray url:[NSURL URLWithString:url] latitude:0 longitude:0 objectID:nil type:SSDKContentTypeAuto];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];}
    //创建弹出菜单容器
//    id<ISSContainer> container = [ShareSDK container];
//    [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
//    
    //弹出分享菜单
//    [ShareSDK showShareActionSheet:container
//                         shareList:nil
//                           content:publishContent
//                     statusBarTips:YES
//                       authOptions:nil
//                      shareOptions:nil
//                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//                                
//                                if (state == SSResponseStateSuccess)
//                                {
//                                    NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
//                                    
//                                    [self displayNotification:nil titleStr:@" 分享成功 " Duration:0.8 time:0.2];
//                                    
//                                }
//                                else if (state == SSResponseStateFail)
//                                {
//                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
//                                    
//                                    [self displayNotification:nil titleStr:@" 分享失败 " Duration:0.8 time:0.2];
//                                }
//                            }];

}
#pragma mark - 下载
- (IBAction)loadBtnClicked:(id)sender {
    [_HUD show:YES];
    [self test];
}

-(void)test{
    // Get an image from the URL below
    UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_currentUrl]]];
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *pngFilePath = [NSString stringWithFormat:@"%@/test.png",docDir];
    NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation(image)];
    [data1 writeToFile:pngFilePath atomically:YES];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error != NULL) {
        [_HUD hide:YES];
        [self displayNotification:nil titleStr:@"保存失败" Duration:0.8 time:0.2];
    }else {
        [_HUD hide:YES];
        [self displayNotification:nil titleStr:@"保存成功" Duration:0.8 time:0.2];
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
//添加评论/跟帖
- (IBAction)commentAddClicked:(id)sender {
    NSString *str = [USER_DEFAULT objectForKey:@"userId"];
    if (!str) {
        LoginViewController *logVC = [[LoginViewController alloc] init];
        BaseNavigationController *base = [[BaseNavigationController alloc] initWithRootViewController:logVC];
        [self presentViewController:base animated:YES completion:nil];
        return;
    }
    [self showCommentText];
}
#pragma mark -change by zhang
-(void)showCommentText
{
    [self createCommentsView];
    [reviewTextView becomeFirstResponder];
}
#pragma mark -change by zhang
-(void)createCommentsView
{
    popOverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    popOverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self.view.window addSubview:popOverView];
    //    UIGestureRecognizer *touchDown = [[UIGestureRecognizer alloc] initWithTarget:self action:@selector(touchreportViewDown)];
    //    touchDown.delegate = self;
    //    [reviewView addGestureRecognizer:touchDown];
    
    if(!reviewView){
        reviewView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 160)];
        //        reviewView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
        reviewView.backgroundColor = [UIColor lightGrayColor];
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 50, 30)];
        //        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, SCREEN_H-150, 50, 30)];
        //        cancelBtn.backgroundColor = [UIColor blueColor];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [reviewView addSubview:cancelBtn];
        
        UILabel *reviewTitle = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_W/2-40, 10, 80, 30)];
        //        UILabel *reviewTitle = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_W/2-40, SCREEN_H-150, 80, 30)];
        reviewTitle.text = @"添加评论";
        reviewTitle.textAlignment = NSTextAlignmentCenter;
        [reviewView addSubview:reviewTitle];
        
        UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_W-60, 10, 50, 30)];
        //        UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_W-60, SCREEN_H-150, 50, 30)];
        [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        //        confirmBtn.backgroundColor = [UIColor blueColor];
        [confirmBtn addTarget:self action:@selector(doneBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [reviewView addSubview:confirmBtn];
        
        reviewTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 50, SCREEN_W-20, 100)];
        //        reviewTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, SCREEN_H-110, SCREEN_W-20, 100)];
        reviewTextView.backgroundColor = [UIColor whiteColor];
        
        reviewTextView.inputAccessoryView = reviewView;
        reviewTextView.delegate = self;
        //    reviewTextView.inputView = reviewView;
        [reviewView addSubview:reviewTextView];
    }
    [self.view.window addSubview:reviewView];
    [reviewTextView becomeFirstResponder];
}

#pragma mark -change by zhang
-(void)cancelBtnClicked
{
    //    popOverView.hidden = YES;
    [popOverView removeFromSuperview];
    [reviewTextView resignFirstResponder];
}
#pragma mark -change by zhang
-(void)doneBtnClicked
{
    NSString *userId = [USER_DEFAULT objectForKey:@"userId"];
    if (!userId) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        BaseNavigationController *base = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:base animated:YES completion:nil];
        return;
    }
    if ([reviewTextView.text isEqualToString:@""]) {
        [self displayNotification:nil titleStr:@"内容不能为空" Duration:0.5 time:0.2];
        return;
    }
    //    popOverView.hidden = YES;
    [popOverView removeFromSuperview];
    [reviewTextView resignFirstResponder];
    
    [self commentsAddInterface];
}

#pragma mark -change by zhang
-(void)commentsAddInterface
{
    if (_reviewManager) {
        _reviewManager = nil;
    }
    _reviewManager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//如果报接口类型不一致请替换
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *commentString = reviewTextView.text;
    NSString *newsId = [NSString stringWithFormat:@"%@",[self.infoDic objectForKey:@"id"]];
    //    NSDictionary *dic = @{@"user_id":_userId,
    //                          @"content":commentString,
    //                          @"news_id":newsId};
    NSString *userId = [USER_DEFAULT objectForKey:@"userId"];
    NSDictionary *dic = @{@"user_id":userId,
                          @"content":commentString,
                          @"news_id":newsId};
    NSString *token = [CustomEncrypt jiamiWithDictionary:dic];
    NSDictionary *dictionary = @{@"user_id":userId,
                                 @"content":commentString,
                                 @"news_id":newsId,
                                 @"token":token};
    [_HUD show:YES];
    [_reviewManager POST:kCommentAdd parameters:dictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"新闻评论返回结果==%@",responseObject);
        [_HUD hide:YES];
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([[result objectForKey:@"ret"] intValue] == 1) {
            NSLog(@"数据成功");
            reviewTextView.text = @"";
            [self displayNotification:nil titleStr:@"评论成功" Duration:0.5 time:0.2];
        }else {
            NSString *msg = [result objectForKey:@"msg"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_HUD hide:YES];
        NSLog(@"error:%@",error.description);
    }];
    
}

//收藏
- (IBAction)collectionBtnClicked:(id)sender {
    NSString *userId = [USER_DEFAULT objectForKey:@"userId"];
    if (!userId) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        BaseNavigationController *base = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:base animated:YES completion:nil];
        return;
    }
    //    if (_isLogin) {
    if (_manager) {
        _manager = nil;
    }
    
    NSLog(@"self.infoDic5555infoId====%@",self.infoDic);
    
    NSString *collectionNewsId = [NSString stringWithFormat:@"%@",[self.infoDic objectForKey:@"id"]];
    //    NSString *collectionImageUrl = [[[self.infoDic objectForKey:@"content"] objectAtIndex:0] objectForKey:@"picture"];
    //    NSString *collectionUserId = [USER_DEFAULT objectForKey:@"userId"];
//    NSString *collectionUserId = @"4";
    NSDictionary *dic = @{@"type":@"3",
                          @"news_id":collectionNewsId,
                          @"url":_currentUrl,
                          @"user_id":userId};
    NSString *token = [CustomEncrypt jiamiWithDictionary:dic];
    NSDictionary *dict = @{@"type":@"3",
                           @"news_id":collectionNewsId,
                           @"url":_currentUrl,
                           @"user_id":userId,
                           @"token":token};
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//如果报接口类型不一致请替换
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [_HUD show:YES];
    [_manager POST:kcollectAdd parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        [_HUD hide:YES];
        NSLog(@"动漫result = %@",result);
        
        if ([[result objectForKey:@"ret"] intValue] == 1) {
            //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"收藏成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            //            [alert show];
            [self displayNotification:nil titleStr:@" 收藏成功 " Duration:0.8 time:0.2];
        }else {
            NSString *msg = [result objectForKey:@"msg"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_HUD hide:YES];
        NSLog(@"error:%@",error.description);
    }];
    //    }else{
    //        NSLog(@"需要登录");
    //    }

}
@end
