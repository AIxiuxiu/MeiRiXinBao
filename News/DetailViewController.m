//
//  DetailViewController.m
//  News
//
//  Created by ink on 15/1/26.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import "DetailViewController.h"
#import "AppDelegate.h"
#import "ZImageBrowser.h"
@interface DetailViewController ()<ZImageBrowserDelegate>
{
    NSArray *_voteArray;
    NSMutableArray *_answerArray;
    BOOL isSingle;
    NSString *_answerStr;
    UIButton *rightBtn;
    NSString *_newsId;
    
    //广告位
    UIImageView *imageView;
    //点击广告跳转的地址
    NSString *adUrl;
    
    NSString *picStr;
    
    BOOL hasVote;
    BOOL hasInput;
    BOOL hasAd;
    UIView *voteView;
    UIButton *ibutton;
    
    NSString *wordFont;
    
    NSString *currentTitle;
    NSString *curretIntro;
    NSString *currentContent;
    //投票的内容
    NSString *voteTitle1;
    
    UIImage *_currentImage;
}
@end

@implementation DetailViewController
- (void)UIConfig {
    self.title = @"详情";
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 30);
    [button addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"icon_neirongxiangqing_1"] forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 70, 30);
    [rightBtn addTarget:self action:@selector(rightBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"bt_neirongxiangqing_1"] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"icon_neirongxiangqing_6"] forState:UIControlStateNormal];
    [rightBtn setTitle:@" 跟帖" forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}
#pragma mark - 跟帖按钮
- (void)rightBtnClicked {
    if (_newsId) {
        CommentViewController *commentVC = [[CommentViewController alloc] init];
        commentVC.newsId = _newsId;
        commentVC.isFromPic = NO;//不是从图片的页面
        [self.navigationController pushViewController:commentVC animated:YES];
    }
}
- (void)backButtonClicked {
    if (self.isPush) {
        AppDelegate *dele = APPDELEGATE;
        [dele mainVCConfig];
    }else{
        [self dismissViewControllerAnimated:YES completion:^{
        
        }];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    isSingle = YES;
    hasAd = NO;
    hasVote = NO;
    hasInput = NO;
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    _HUD.labelText = @"loading...";
    [self.view addSubview:_HUD];
    
    _userId = [USER_DEFAULT objectForKey:@"userId"];
    if (_userId) {
        _isLogin = YES;
    }else {
        _isLogin = NO;
    }
    
    
    [self UIConfig];
    [self createCommentsView];//评论
    NSString *font = [USER_DEFAULT objectForKey:@"systemFont"];
    if ([font isEqualToString:@"小号字"]) {
        wordFont = @"17";
    }else if ([font isEqualToString:@"中号字"]) {
        wordFont = @"20";
    }else if ([font isEqualToString:@"大号字"]) {
        wordFont = @"25";
    }
    //给webView赋值
    self.webView.scrollView.scrollEnabled = NO;
    NSString *urlStr = [NSString stringWithFormat:@"http://news.iyousoon.com/Api/Show/share/id/%@",[self.infoDic objectForKey:@"id"]];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    

    // Do any additional setup after loading the view from its nib.
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *urlStr = [request.URL absoluteString];
    if ([urlStr rangeOfString:@"testapp"].location != NSNotFound) {
        [_HUD show:YES];
        NSLog(@"url = %@",urlStr);
        NSRange range = [urlStr rangeOfString:@"Public"];
        NSRange rr;
        rr.location = 0;
        rr.length = range.location;
        NSString *path = [urlStr stringByReplacingCharactersInRange:rr withString:@""];
       
        NSString *picUrl = [NSString stringWithFormat:@"%@/%@",@"http://news.iyousoon.com",path];
        NSMutableArray *images = [NSMutableArray array];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:picUrl]]];
        [images addObject:image];
        ZImageBrowser *browser = [[ZImageBrowser alloc] init];
        browser.enableDoubleTapZoom = YES;
        browser.enableTapGesture = YES;
        browser.enableLongPress = YES;
        browser.delegate = self;
        browser.doubleTapSclaeZoom = @(1.5);
        //    browser.maxDragScaleZoom = @(3.0);
        browser.images = images;
        [self presentViewController:browser animated:YES completion:^{
           [_HUD hide:YES];
        }];
        return NO;
    }
    return YES;
}
#pragma mark - 图片查看器delegate
- (void)imageBroser:(ZImageBrowser *)broswer didTapImageAtIndex:(NSInteger)index {
    NSLog(@"%zd", index);
    [broswer dismissViewControllerAnimated:YES completion:nil];
}
- (void)imageBroser:(ZImageBrowser *)broswer didLongPressImageAtIndex:(NSInteger)index {
    _currentImage = [broswer.images objectAtIndex:index];
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存到手机", nil];
    [sheet showInView:broswer.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSLog(@"baocun");
        [self saveImageToPhotos:_currentImage];
    }else {
        _currentImage = nil;
    }
}
//保存图片
- (void)saveImageToPhotos:(UIImage*)savedImage
{    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
    [alert show];
}
-(void)cancelBtnClicked
{
    [popOverView removeFromSuperview];
    [reviewTextView resignFirstResponder];
}
-(void)doneBtnClicked
{
    if ([reviewTextView.text isEqualToString:@""]) {
        [self displayNotification:nil titleStr:@"内容不能为空" Duration:0.5 time:0.2];
        return;
    }
    [reviewTextView resignFirstResponder];
    [popOverView removeFromSuperview];
    [self commentsAddInterface];
}
//点击"完成"按钮，提交评论
-(void)commentsAddInterface
{
    if (_reviewManager) {
        _reviewManager = nil;
    }
    _reviewManager = [AFHTTPRequestOperationManager manager];
    _reviewManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//如果报接口类型不一致请替换
    _reviewManager.responseSerializer = [AFHTTPResponseSerializer serializer];
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
#pragma mark -UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
        [webView stringByEvaluatingJavaScriptFromString:
         @"var script = document.createElement('script');"
         "script.type = 'text/javascript';"
         "script.text = \"function ResizeImages() { "
         "var myimg,oldwidth,oldheight;"
         "var maxwidth=300;" //缩放系数
         "for(i=0;i <document.images.length;i++){"
         "myimg = document.images[i];"
         "if(myimg.width > maxwidth){"
         "oldwidth = myimg.width;"
         "oldheight = myimg.height;"
         "myimg.width = maxwidth;"
         "myimg.height = oldheight * ( myimg.width /oldwidth );"
         "}"
         "}"
         "}\";"
         "document.getElementsByTagName('head')[0].appendChild(script);"];
        [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];


    NSString *str = [NSString stringWithFormat:@"fontSize(%@)",wordFont];
    [webView stringByEvaluatingJavaScriptFromString:str];
    
    CGFloat documentHeight = [[webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"] floatValue];
    CGRect frame = webView.frame;
    frame.size.height = documentHeight;
    self.webView.frame = frame;
    [self getData];
}

#pragma mark -创建广告位
- (void)createAdImageView {
    if (hasAd == NO) {
        CGFloat y;
        if (hasInput) {
            y = ibutton.frame.size.height+ibutton.frame.origin.y;
        }else if (hasVote){
            y = voteView.frame.origin.y+voteView.frame.size.height;
        }else {
            y = self.webView.frame.size.height+self.webView.frame.origin.y;
        }
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, y+10, SCREEN_W, 1)];
        imageView.hidden = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.userInteractionEnabled = YES;
        [self.backScrollView addSubview:imageView];
        [self backScrollViewGetFit];
        
    }else {
        CGFloat y;
        if (hasInput) {
            y = ibutton.frame.size.height+ibutton.frame.origin.y;
        }else if (hasVote){
            y = voteView.frame.origin.y+voteView.frame.size.height;
        }else {
            y = self.webView.frame.size.height+self.webView.frame.origin.y;
        }
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, y+10, SCREEN_W, 150)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(adImageViewClicked)];
        [imageView addGestureRecognizer:tap];
        [self.backScrollView addSubview:imageView];
        [self backScrollViewGetFit];
    }
}
#pragma mark - 点击imageView
- (void)adImageViewClicked {
    if (![adUrl isEqualToString:@""]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:adUrl]];
    }
}

#pragma mark - 获取广告
- (void)getAdImage {
    if (_adManager) {
        _adManager = nil;
    }
    _adManager = [AFHTTPRequestOperationManager manager];
    _adManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//如果报接口类型不一致请替换
    _adManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *dic = @{@"type":@"2"};
    NSString *token = [CustomEncrypt jiamiWithDictionary:dic];
    NSDictionary *dict = @{@"type":@"2",
                           @"token":token};
    [_adManager POST:kAdvert parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"xialaAd = %@",responseObject);
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([[result objectForKey:@"ret"] intValue]==1) {
            
            hasAd = YES;
            [self createAdImageView];
            NSDictionary *dictionary = [result objectForKey:@"data"];
            [imageView setImageWithURL:[NSURL URLWithString:[dictionary objectForKey:@"src"]] placeholderImage:[UIImage imageNamed:@"jpg_neirongxiangqing_1"]];
            adUrl = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"src"]];
            
        }else {
            hasAd = NO;
            [self createAdImageView];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@  ,  %s",error.description,__FUNCTION__);
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



- (void)createVoteView {
    
//    NSDictionary *dic = @{@"image":@"",
//                          @"text":@"1"};
//    NSDictionary *dic1 = @{@"image":@"",
//                          @"text":@"2"};
//    _voteArray = @[dic,dic1];
    //最后的投票结果
    _answerArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSDictionary *dd in _voteArray) {
        NSString *imaged = [NSString stringWithFormat:@"%@",[dd objectForKey:@"image"]];
        NSString *textd = [NSString stringWithFormat:@"%@",[dd objectForKey:@"text"]];
        if ([imaged isEqualToString:@""]&&[textd isEqualToString:@""]) {
            
        }else {
            [array addObject:dd];
        }
    }
    _voteArray = [NSArray arrayWithArray:array];
    BOOL hasPic = YES;
    NSDictionary *dict = [_voteArray objectAtIndex:0];
    if ([[NSString stringWithFormat:@"%@",[dict objectForKey:@"image"]] isEqualToString:@"<null>"]||[[NSString stringWithFormat:@"%@",[dict objectForKey:@"image"]] isEqualToString:@""]) {
        hasPic = NO;
    }
    
    CGFloat y = self.webView.frame.size.height;
    CGFloat width = self.backScrollView.frame.size.width;
    CGFloat height = 30+_voteArray.count*40+40;
    if (hasPic) {
        height = 30+_voteArray.count*100+40;
    }
    voteView = [[UIView alloc] initWithFrame:CGRectMake(10, y+5, width-20, height)];
    //---line
    UILabel *label_line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width-20, 1)];
    label_line.backgroundColor = [UIColor colorWithRed:212/255.0 green:212/255.0 blue:212/255.0 alpha:1.0];
    [voteView addSubview:label_line];
    
    UILabel *label_line1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1, height)];
    label_line1.backgroundColor = [UIColor colorWithRed:212/255.0 green:212/255.0 blue:212/255.0 alpha:1.0];
    [voteView addSubview:label_line1];
    
    UILabel *label_line2 = [[UILabel alloc] initWithFrame:CGRectMake(0, height-1, width-20, 1)];
    label_line2.backgroundColor = [UIColor colorWithRed:212/255.0 green:212/255.0 blue:212/255.0 alpha:1.0];
    [voteView addSubview:label_line2];
    
    UILabel *label_line3 = [[UILabel alloc] initWithFrame:CGRectMake(width-21, 0, 1, height)];
    label_line3.backgroundColor = [UIColor colorWithRed:212/255.0 green:212/255.0 blue:212/255.0 alpha:1.0];
    [voteView addSubview:label_line3];
    //over
    UILabel *voteTitle = [[UILabel alloc] initWithFrame:CGRectMake(2, 5, width, 20)];
    voteTitle.text = voteTitle1;
    [voteView addSubview:voteTitle];
    for (int i=0; i<_voteArray.count; i++) {
        
        NSDictionary *dic = [_voteArray objectAtIndex:i];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 30+40*i, width, 40)];
        if (hasPic) {
            view.frame = CGRectMake(0, 30+100*i, width, 100);
        }
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(5, 0, 30, 20);
        button.tag = 51+i;
        [button setImage:[UIImage imageNamed:@"bt_neirongxiangqing_3_1"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"bt_neirongxiangqing_3"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *answerLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, 250, 20)];
        answerLabel.text = [dic objectForKey:@"text"];
        answerLabel.tag = 101+i;
        UIImageView *imageView1;
        if (hasPic) {
            imageView1 = [[UIImageView alloc] init];
            imageView1.frame = CGRectMake(35, 20, 80, 60);
            [imageView1 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"image"]]]];
            [view addSubview:imageView1];
        }
        
        [view addSubview:button];
        [view addSubview:answerLabel];
        view.userInteractionEnabled = YES;
        view.tag = 501+i;
        [voteView addSubview:view];
    }
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake((width-120)/2, height-38, 120, 36);
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"bt_neirongxiangqing_2"] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitVote) forControlEvents:UIControlEventTouchUpInside];
    [voteView addSubview:submitBtn];
    voteView.userInteractionEnabled = YES;
    voteView.tag = 200;
    [self.backScrollView addSubview:voteView];
    CGFloat HH = voteView.frame.origin.y+voteView.frame.size.height +170;
    imageView.frame = CGRectMake(10, HH-160, SCREEN_W-20, 150);
//    self.backScrollView.contentSize = CGSizeMake(0, HH);
//    [self backScrollViewGetFit];
    isSingle = YES;
   
}

#pragma mark - 提交我的投票
- (void)buttonClicked:(UIButton *)button {
    if (isSingle) {
        [_answerArray removeAllObjects];
        UIView *voteView = [self.backScrollView viewWithTag:200];
        for (UIView *view in voteView.subviews) {
            if (view.subviews.count>1) {
                UIButton *button1 = (UIButton *)[view viewWithTag:view.tag-500+50];
                button1.selected = NO;
            }
        }
        button.selected = YES;
        UIView *view = [button superview];
        UILabel *label = (UILabel *)[view viewWithTag:view.tag-500+100];
//        NSLog(@"111  %@",label.text);
        [_answerArray addObject:[NSString stringWithFormat:@"%ld",(long)(label.tag-100)]];
        _answerStr = [_answerArray objectAtIndex:0];
        NSLog(@"%@",_answerStr);
    }else {
        button.selected = !button.selected;
        UIView *view = [button superview];
        UILabel *label = (UILabel *)[view viewWithTag:view.tag-500+100];
//        NSLog(@"111  %@",label.text);
        if (button.selected) {
            [_answerArray addObject:[NSString stringWithFormat:@"%ld",(long)(label.tag-100)]];
        }else {
            [_answerArray removeObject:[NSString stringWithFormat:@"%ld",(long)(label.tag-100)]];
        }
//        NSLog(@"count = %d",_answerArray.count);
        _answerStr = [_answerArray componentsJoinedByString:@","];
        NSLog(@"%@",_answerStr);
    }
}
- (void)submitVote {
    if (_manager) {
        _manager = nil;
    }
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//如果报接口类型不一致请替换
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *userId = [USER_DEFAULT objectForKey:@"userId"];
    if (!userId) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        BaseNavigationController *base = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:base animated:YES completion:nil];
        return;
    }
    if (!_newsId) {
        return;
    }
    if ([_answerStr isEqualToString:@""]||!_answerStr) {
        [self displayNotification:nil titleStr:@"请先选择" Duration:0.8 time:0.2];
        return;
    }
    NSDictionary *dic = @{@"user_id":userId,
                          @"news_id":_newsId,
                          @"opti":_answerStr};
    NSString *token = [CustomEncrypt jiamiWithDictionary:dic];
    NSDictionary *dict = @{@"user_id":userId,
                           @"news_id":_newsId,
                           @"opti":_answerStr,
                           @"token":token};
    [_manager POST:kVoteAdd parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([[result objectForKey:@"ret"] intValue] == 1) {
            [self displayNotification:nil titleStr:@"已投票" Duration:0.5 time:0.2];
        }else {
            NSString *msg = [result objectForKey:@"msg"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error.description);
    }];
}
#pragma mark - 网络请求
- (void)getData {
    if (_manager) {
        _manager = nil;
    }
    NSString *infoId = [self.infoDic objectForKey:@"id"];
    NSDictionary *dic = @{@"id":infoId};
    NSString *token = [CustomEncrypt jiamiWithDictionary:dic];
    NSDictionary *dict = @{@"id":infoId,
                           @"token":token};
    NSLog(@"dict====%@",dict);
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//如果报接口类型不一致请替换
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [_HUD show:YES];
    [_manager POST:knewsDetails parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [_HUD hide:YES];
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"result = %@",result);
        if ([[result objectForKey:@"ret"] intValue] == 1) {
            if ([[result objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic1 = [result objectForKey:@"data"];
                can_comment = [dic1 objectForKey:@"can_comment"];
                NSLog(@"can_comment==%@",can_comment);
                if ([can_comment intValue] == 0) {
                    self.reviewBtn.hidden = YES;
                }

                currentTitle = [dic1 objectForKey:@"title"];
                curretIntro = [dic1 objectForKey:@"sharedesc"];
                currentContent = [dic1 objectForKey:@"content"];
                _newsId = [NSString stringWithFormat:@"%@",[dic1 objectForKey:@"id"]];
                //+++
                NSString *isVote = [NSString stringWithFormat:@"%@",[dic1 objectForKey:@"isvote"]];
                //+++
                if ([isVote isEqualToString:@"1"]) {
                    hasVote = YES;
                    NSArray *arr = (NSArray *)[dic1 objectForKey:@"vote"];
                    _voteArray = [NSArray arrayWithArray:arr];
                    voteTitle1 = [dic1 objectForKey:@"votetitle"];
                    [self createVoteView];
                }
                NSString *isInput = [NSString stringWithFormat:@"%@",[dic1 objectForKey:@"isquestionary"]];
                if ([isInput isEqualToString:@"1"]) {
                    hasInput = YES;
                    [self createInputView];
                }
                    
                [self getAdImage];
                /*
                NSDictionary *dic1 = (NSDictionary *)[result objectForKey:@"data"];
                self.titleLabel.text = [dic1 objectForKey:@"title"];
                
                
                [rightBtn setTitle:[NSString stringWithFormat:@"%@",[dic1 objectForKey:@"comment"]] forState:UIControlStateNormal];
                
                NSString *string = [NSString stringWithFormat:@"%@",[dic1 objectForKey:@"time"]];
                NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:[string integerValue]];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSString *dateStr = [formatter stringFromDate:date];
                self.dateLabel.text = dateStr;
                NSString *str = [NSString stringWithFormat:@"%@",[dic1 objectForKey:@"content"]];
                str = [str stringByReplacingOccurrencesOfString:@"/n" withString:@"\n"];
                self.contentLabel.text = str;
                
                picStr =[NSString stringWithFormat:@"%@",[dic1 objectForKey:@"illustrated"]];
                [self.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dic1 objectForKey:@"illustrated"]]] placeholderImage:[UIImage imageNamed:@"jpg_neirongxiangqing_1"]];

#pragma mark - changeByChangpeng
                //+++
                NSString *isVote = [NSString stringWithFormat:@"%@",[dic1 objectForKey:@"isvote"]];
                //+++
                if ([isVote isEqualToString:@"0"]) {
                    [self contentLabelFitSelf:NO];
                }else if ([isVote isEqualToString:@"1"]) {
                    _voteArray = (NSArray *)[dic1 objectForKey:@"vote"];
                    [self contentLabelFitSelf:YES];
                }
#pragma mark - changeByChangpeng
                //+++
                NSString *isInput = [NSString stringWithFormat:@"%@",[dic1 objectForKey:@"isquestionary"]];
                if ([isInput isEqualToString:@"1"]) {
                    [self createInputView];
                }
                //+++
                 */
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

- (void)fillData:(NSDictionary *)dic1 {
}


#pragma mark - changByChangpeng
//+++
#pragma mark - 创建inputView
- (void)createInputView {
    ibutton = [UIButton buttonWithType:UIButtonTypeCustom];
    ibutton.backgroundColor = [UIColor redColor];
    [ibutton setTitle:@"报名填表" forState:UIControlStateNormal];
    [ibutton addTarget:self action:@selector(inputVC) forControlEvents:UIControlEventTouchUpInside];
    CGFloat y;
    if (hasVote) {
        y = voteView.frame.size.height+voteView.frame.origin.y;
    }else {
        y = self.webView.frame.size.height;
    }
    CGFloat height = 30;
    ibutton.frame = CGRectMake(10, y+10, SCREEN_W-20, height);
    CGSize size = self.backScrollView.contentSize;
    size.height += height+20;
    [self.backScrollView addSubview:ibutton];
}
- (void)backScrollViewGetFit {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (UIView *view in self.backScrollView.subviews) {
        CGFloat hh = view.frame.origin.y+view.frame.size.height;
        NSNumber *num = [NSNumber numberWithFloat:hh];
        [arr addObject:num];
    }
    CGFloat max = 0.0 ;
    for (int i = 0; i+1<arr.count; i++) {
        CGFloat  num = [[arr objectAtIndex:i] floatValue];
        CGFloat num1 = [[arr objectAtIndex:i+1] floatValue];
        max = num>num1?num:num1;
    }
    self.backScrollView.contentSize = CGSizeMake(0, max+10.0);
}
- (void)inputVC {
    QuestionViewController *questionVC = [[QuestionViewController alloc] init];
    questionVC.urlStr = [NSString stringWithFormat:@"http://news.iyousoon.com/Api/Show/vote/id/%@",_newsId];
    [self.navigationController pushViewController:questionVC animated:YES];
}

//+++


- (IBAction)shareBtnClicked:(id)sender {
    
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"180" ofType:@"png"];
    NSString *url = [NSString stringWithFormat:@"http://news.iyousoon.com/Api/Show/share/id/%@",[self.infoDic objectForKey:@"id"]];
    //构造分享内容
//    id<ISSContent> publishContent = [ShareSDK content:[NSString stringWithFormat:@"#%@#",currentTitle]
//                                       defaultContent:@"-每日新报"
//                                                image:[ShareSDK imageWithPath:imagePath]
//                                                title:currentTitle
//                                                  url:url
//                                          description:@"每日新报"
//                                            mediaType:SSPublishContentMediaTypeNews];
//    //创建弹出菜单容器
//    id<ISSContainer> container = [ShareSDK container];
//    [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
//    
//    //弹出分享菜单
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
//    
   
    NSLog(@"点击分享了");
    //1、创建分享参数
    NSArray* imageArray = @[[UIImage imageNamed:imagePath]];
    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:curretIntro
                                         images:imageArray
                                            url:[NSURL URLWithString:url]
                                          title:currentTitle
                                           type:SSDKContentTypeAuto];
        [shareParams SSDKSetupSinaWeiboShareParamsByText:[NSString stringWithFormat:@"%@%@",currentTitle,[NSURL URLWithString:url]] title:curretIntro image:imageArray url:[NSURL URLWithString:url] latitude:0 longitude:0 objectID:nil type:SSDKContentTypeAuto];
        
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


- (IBAction)collectBtnClicked:(id)sender {
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
    //    NSString *collectionUserId = [USER_DEFAULT objectForKey:@"userId"];
//    NSString *collectionUserId = @"4";
    //        NSLog(@"collectionNewsId==%@",collectionNewsId);//  52
    //        NSLog(@"collectionImageUrl==%@",collectionImageUrl);//  http://news.iyousoon.com/Public/Home/picture/20150128/1422415324299320.jpg
    //        NSLog(@"collectionUserId==%@",collectionUserId);//    4
    NSDictionary *dict;
    if (self.isWithPic) {
        NSString *collectionImageUrl = picStr;
        NSDictionary *dic = @{@"type":@"1",
                              @"news_id":collectionNewsId,
                              @"url":@"",
                              @"user_id":userId};
        NSString *token = [CustomEncrypt jiamiWithDictionary:dic];
        dict = @{@"type":@"1",
                 @"news_id":collectionNewsId,
                 @"url":@"",
                 @"user_id":userId,
                 @"token":token};
    }else{
        NSDictionary *dic = @{@"type":@"1",
                              @"news_id":collectionNewsId,
                              @"user_id":userId};
        NSString *token = [CustomEncrypt jiamiWithDictionary:dic];
        dict = @{@"type":@"1",
                 @"news_id":collectionNewsId,
                 @"user_id":userId,
                 @"token":token};
    }
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//如果报接口类型不一致请替换
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [_HUD show:YES];
    [_manager POST:kcollectAdd parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        [_HUD hide:YES];
        NSLog(@"详情result = %@",result);
        //        {
        //        msg = "\U6dfb\U52a0\U6210\U529f";
        //        ret = 1;
        //        }
        
        
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
- (IBAction)reviewBtnClicked:(UIButton *)sender {
    //    reviewView.hidden = NO;
    //    [reviewTextView becomeFirstResponder];
    //    reviewTextView.inputAccessoryView = reviewView;
//    sender.userInteractionEnabled = NO;
//    [sender performSelector:@selector(setUserInteractionEnabled:) withObject:@YES afterDelay:1];
    NSString *str = [USER_DEFAULT objectForKey:@"userId"];
    if (!str) {
        LoginViewController *logVC = [[LoginViewController alloc] init];
        BaseNavigationController *base = [[BaseNavigationController alloc] initWithRootViewController:logVC];
        [self presentViewController:base animated:YES completion:nil];
        return;
    }
    [self showCommentText];
}
-(void)showCommentText
{
    [self createCommentsView];
    [reviewTextView becomeFirstResponder];
}

//评论
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

@end
