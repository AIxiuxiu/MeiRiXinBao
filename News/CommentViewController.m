//
//  CommentViewController.m
//  News
//
//  Created by ink on 15/1/30.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import "CommentViewController.h"
#import "LoginViewController.h"
#import "BaseNavigationController.h"
@interface CommentViewController ()
{
    NSArray *_dataArray;
    UIView *buttonView;
    DXPopover *popover;
}
@end

@implementation CommentViewController
- (void)UIConfig {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 30);
    [button addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"icon_neirongxiangqing_1"] forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftItem;
}
- (void)backButtonClicked {
    if (self.isFromPic) {
        [self dismissViewControllerAnimated:YES completion:^{
        
        }];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark -change by zhang
//举报类型选择
-(void)reportUIConfig
{
    //欺骗
    self.qiPianBtn.tag = 100;
    [self.qiPianBtn setImage:[UIImage imageNamed:@"bt_neirongxiangqing_3_1"] forState:UIControlStateNormal];
    [self.qiPianBtn addTarget:self action:@selector(reportBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    //色情
    self.seQingBtn.tag = 101;
    [self.seQingBtn setImage:[UIImage imageNamed:@"bt_neirongxiangqing_3_1"] forState:UIControlStateNormal];
    [self.seQingBtn addTarget:self action:@selector(reportBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    //攻击
    self.gongJiBtn.tag = 102;
    [self.gongJiBtn setImage:[UIImage imageNamed:@"bt_neirongxiangqing_3_1"] forState:UIControlStateNormal];
    [self.gongJiBtn addTarget:self action:@selector(reportBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    //其它
    self.qiTaBtn.tag = 103;
    [self.qiTaBtn setImage:[UIImage imageNamed:@"bt_neirongxiangqing_3_1"] forState:UIControlStateNormal];
    [self.qiTaBtn addTarget:self action:@selector(reportBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
 
    self.title = @"跟帖";
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
        [self UIConfig];
    
#pragma mark -change by zhang
    [self reportUIConfig];
    self.reportView.hidden = YES;
    
    [self createPopupView];
    [self getData];
    // Do any additional setup after loading the view from its nib.
}

- (void)createPopupView {

}
- (void)getData {
    if (_manager) {
        _manager = nil;
    }
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//如果报接口类型不一致请替换
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *dic = @{@"news_id":self.newsId};
    NSString *token = [CustomEncrypt jiamiWithDictionary:dic];
    NSDictionary *dict = @{@"news_id":self.newsId,
                           @"token":token};
    [_manager POST:kComment parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"aaaaaa = %@",responseObject);
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([[result objectForKey:@"ret"] intValue] == 1) {
            _dataArray = [result objectForKey:@"data"];
            [self.tableView reloadData];
        }else {
           // NSString *msg = [result objectForKey:@"msg"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"暂时没有人跟帖" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error.description);
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *dict = [_dataArray objectAtIndex:section];
    NSString *child = [NSString stringWithFormat:@"%@",[dict objectForKey:@"child"]];
    if ([child isEqualToString:@"<null>"]) {
        return 0;
    }else {
        NSArray *arr = (NSArray *)[dict objectForKey:@"child"];
        return arr?arr.count:0;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray?_dataArray.count:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"commentCell";
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CommentCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dict = [_dataArray objectAtIndex:indexPath.section];
    NSArray *arr = (NSArray *)[dict objectForKey:@"child"];
    NSDictionary *dic = [arr objectAtIndex:indexPath.row];
    cell.nickLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"username"]];
    //
    cell.numLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"like"]];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[NSString stringWithFormat:@"%@",[dic objectForKey:@"time"]] intValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [formatter stringFromDate:date];
    //
    cell.dateLabel.text = dateStr;
    cell.contentLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"content"]];
#pragma mark -change by changpeng
    CGRect frame = cell.contentLabel.frame;
    frame.size.height = [self getHeightWithString:cell.contentLabel.text andFont:[UIFont systemFontOfSize:17] andWidth:225.0];
    cell.contentLabel.frame = frame;
#pragma mark -change by zhang
    NSString *imgUrlStr = [dic objectForKey:@"avatar"];
    NSURL *imgURL = [NSURL URLWithString:imgUrlStr];
    [cell.headImageView setImageWithURL:imgURL placeholderImage:[UIImage imageNamed:@"jpg_gerenzhuye_2"]];
    return cell;
}

#pragma mark +++++
#pragma mark -change by changpeng
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = [_dataArray objectAtIndex:indexPath.section];
    NSArray *arr = (NSArray *)[dict objectForKey:@"child"];
    NSDictionary *dic = [arr objectAtIndex:indexPath.row];
    NSString *content = [NSString stringWithFormat:@"%@",[dic objectForKey:@"content"]];
    CGFloat heightOfContent = [self getHeightWithString:content andFont:[UIFont systemFontOfSize:17] andWidth:225.0];
    return 100-20+heightOfContent;
}

#pragma mark +++++
#pragma mark -change by changpeng
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSDictionary *dic = [_dataArray objectAtIndex:section];
    NSString *content = [NSString stringWithFormat:@"%@",[dic objectForKey:@"content"]];
    CGFloat heightOfContent = [self getHeightWithString:content andFont:[UIFont systemFontOfSize:17] andWidth:250.0];
    return 100-20+heightOfContent;
}
#pragma mark +++++
#pragma mark -change by changpeng
- (CGFloat)getHeightWithString:(NSString *)content andFont:(UIFont *)font andWidth:(CGFloat)width {
    CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(width, 9999) lineBreakMode:NSLineBreakByWordWrapping];
    return size.height;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSDictionary *dic = [_dataArray objectAtIndex:section];
    SectionView *view = [[[NSBundle mainBundle] loadNibNamed:@"SectionView" owner:self options:nil] lastObject];
//    SectionView *view = [[SectionView alloc] init];
    view.delegate = self;
    view.nickLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"username"]];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[NSString stringWithFormat:@"%@",[dic objectForKey:@"time"]] intValue]];
    view.infoDic = dic;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [formatter stringFromDate:date];
    view.dateLabel.text = dateStr;
    view.numLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"like"]];
//    if ([view.numLabel.text isEqualToString:@"0"]) {
//        view.numLabel.text = @"";
//    }
    view.contentLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"content"]];
#pragma mark -change by changpeng
    CGRect frame = view.contentLabel.frame;
    frame.size.height = [self getHeightWithString:view.contentLabel.text andFont:[UIFont systemFontOfSize:17] andWidth:250.0];
    view.contentLabel.frame = frame;

#pragma mark -change by zhang
    NSString *imgUrlStr = [dic objectForKey:@"avatar"];
    NSURL *imgURL = [NSURL URLWithString:imgUrlStr];
    [view.headImageView setImageWithURL:imgURL placeholderImage:[UIImage imageNamed:@"jpg_gerenzhuye_2"]];    return view;
}

- (void)createButtonsView {
    buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W-20, 60)];
    NSArray *titles = @[@" 回复",@" 收藏",@" 赞",@" 举报"];
    NSArray *images = @[@"icon_gentiebianji_1",@"icon_gentiebianji_2",@"icon_remengentie_1",@"icon_gentiebianji_4"];
    buttonView.userInteractionEnabled = YES;
    for (int i = 0; i<4; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*((SCREEN_W-20)/4), 0, (SCREEN_W-20)/4, 60);
        button.tag = 1000+i;
        [button setImage:[UIImage imageNamed:[images objectAtIndex:i]] forState:UIControlStateNormal];
        [button setTitle:[titles objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [buttonView addSubview:button];
    }
}
- (void)buttonClicked :(UIButton *)button {
    [popover dismiss];
    switch (button.tag) {
        case 1000:
        {//回复
            NSString *str = [USER_DEFAULT objectForKey:@"userId"];
            if (!str) {
                LoginViewController *logVC = [[LoginViewController alloc] init];
                BaseNavigationController *base = [[BaseNavigationController alloc] initWithRootViewController:logVC];
                [self presentViewController:base animated:YES completion:nil];
                return;
            }
            [self showCommentText];
        }
            break;
        case 1001:
        {//收藏
            NSString *uid = [USER_DEFAULT objectForKey:@"userId"];
            if (!uid) {
                LoginViewController *loginVC = [[LoginViewController alloc] init];
                BaseNavigationController *base = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
                [self presentViewController:base animated:YES completion:nil];
                return;
            }
            if (_manager) {
                _manager = nil;
            }
            _manager = [AFHTTPRequestOperationManager manager];
            _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//如果报接口类型不一致请替换
            _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            NSDictionary *dic = @{@"type":@"2",
                                  @"news_id":_replyId,
                                  @"user_id":uid};
            NSString *token = [CustomEncrypt jiamiWithDictionary:dic];
            NSDictionary *dict = @{@"type":@"2",
                                   @"news_id":_replyId,
                                   @"user_id":uid,
                                   @"token":token};
            [_manager POST:kcollectAdd parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"result = %@",responseObject);
                NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                if ([[result objectForKey:@"ret"] intValue] == 1) {
                    [self displayNotification:nil titleStr:@"收藏成功" Duration:0.8 time:0.2];
                }else {
                    [self displayNotification:nil titleStr:@"收藏失败" Duration:0.8 time:0.2];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"error:%@",error.description);
            }];
        }
            break;
        case 1002:
        {//赞
            
        }
            break;
        case 1003:
        {//举报
            
        }
            break;
        default:
            break;
    }
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
        reviewView.backgroundColor = [UIColor colorWithRed:180 green:180 blue:180 alpha:1];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    if (!buttonView) {
//        [self createButtonsView];
//        popover = [DXPopover popover];
//        popover.cornerRadius = 4.0;
//    }
//    NSDictionary *dict = [_dataArray objectAtIndex:indexPath.section];
//    NSArray *arr = (NSArray *)[dict objectForKey:@"child"];
//    NSDictionary *dic = [arr objectAtIndex:indexPath.row];
//    _replyId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
//    [popover showAtView:cell withContentView:buttonView inView:self.tableView];
    NSDictionary *dict = [_dataArray objectAtIndex:indexPath.section];
    NSArray *arr = (NSArray *)[dict objectForKey:@"child"];
    NSDictionary *dic = [arr objectAtIndex:indexPath.row];
    _replyId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
    //    [popover showAtView:cell withContentView:buttonView inView:self.view];
    [self replayThread];
}

#pragma mark - SectionViewDelegate
- (void)sectionView:(SectionView *)sectionView andInfoDictionary:(NSDictionary *)infoDic {
//    if (!buttonView) {
//        [self createButtonsView];
//        popover = [DXPopover popover];
//        popover.cornerRadius = 4.0;
//    }
//    _replyId = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"id"]];
//    [popover showAtView:sectionView withContentView:buttonView inView:self.tableView];
    _replyId = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"id"]];
    //    [popover showAtView:sectionView withContentView:buttonView inView:self.view];
    [self replayThread];
    
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
    [popOverView removeFromSuperview];
    [reviewTextView resignFirstResponder];
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
    
    //    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    //    NSUInteger num= (NSUInteger)indexPath;
    //    _Id = [NSString stringWithFormat:@"%@",[[_dataArray objectAtIndex:num] objectForKey:@"id"]];
    
    NSString *personId = _replyId;
    NSLog(@"_replyId原本===%@",_replyId);
    //    NSDictionary *dic = @{@"user_id":_userId,
    //                          @"content":commentString,
    //                          @"news_id":newsId};
    NSString *userId = [USER_DEFAULT objectForKey:@"userId"];
    NSDictionary *dic = @{@"user_id":userId,
                          @"content":commentString,
                          @"id":personId};
    NSString *token = [CustomEncrypt jiamiWithDictionary:dic];
    NSDictionary *dictionary = @{@"user_id":userId,
                                 @"content":commentString,
                                 @"id":personId,
                                 @"token":token};
    [_HUD show:YES];
    [_reviewManager POST:kCommentAdd parameters:dictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"新闻评论返回结果==%@",responseObject);
        [_HUD hide:YES];
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([[result objectForKey:@"ret"] intValue] == 1) {
            NSLog(@"personId数据成功");
            [self displayNotification:nil titleStr:@"回复成功" Duration:0.8 time:0.2];
            
//            [self.tableView reloadData];
            [self getData];
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

#pragma mark +++++
#pragma mark -change by zhang
//回复跟帖
-(void)replayThread
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"回复",@"收藏",@"赞",@"举报",nil];
    actionSheet.actionSheetStyle = UIBarStyleDefault;
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){
        //回复
        NSString *str = [USER_DEFAULT objectForKey:@"userId"];
        if (!str) {
            LoginViewController *logVC = [[LoginViewController alloc] init];
            BaseNavigationController *base = [[BaseNavigationController alloc] initWithRootViewController:logVC];
            [self presentViewController:base animated:YES completion:nil];
            return;
        }
        [self showCommentText];
    }else if (buttonIndex==1){
        //收藏
        NSString *uid = [USER_DEFAULT objectForKey:@"userId"];
        if (!uid) {
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            BaseNavigationController *base = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
            [self presentViewController:base animated:YES completion:nil];
            return;
        }
        if (_manager) {
            _manager = nil;
        }
        _manager = [AFHTTPRequestOperationManager manager];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//如果报接口类型不一致请替换
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        NSDictionary *dic = @{@"type":@"2",
                              @"news_id":_replyId,
                              @"user_id":uid};
        NSString *token = [CustomEncrypt jiamiWithDictionary:dic];
        NSDictionary *dict = @{@"type":@"2",
                               @"news_id":_replyId,
                               @"user_id":uid,
                               @"token":token};
        [_manager POST:kcollectAdd parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"result = %@",responseObject);
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            if ([[result objectForKey:@"ret"] intValue] == 1) {
                [self displayNotification:nil titleStr:@"收藏成功" Duration:0.8 time:0.2];
            }else {
                [self displayNotification:nil titleStr:@"收藏失败" Duration:0.8 time:0.2];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error:%@",error.description);
        }];
    }else if (buttonIndex==2){
        //赞
        NSString *uid = [USER_DEFAULT objectForKey:@"userId"];
                if (!uid) {
                    LoginViewController *loginVC = [[LoginViewController alloc] init];
                    BaseNavigationController *base = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
                    [self presentViewController:base animated:YES completion:nil];
                    return;
                }
        if (_manager) {
            _manager = nil;
        }
        NSString *userId = [USER_DEFAULT objectForKey:@"userId"];
        _manager = [AFHTTPRequestOperationManager manager];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//如果报接口类型不一致请替换
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        NSDictionary *dic = @{@"comment_id":_replyId,
                              @"user_id":userId};
        NSString *token = [CustomEncrypt jiamiWithDictionary:dic];
        NSDictionary *dict = @{@"comment_id":_replyId,
                               @"user_id":userId,
                               @"token":token};
        [_manager POST:kLike parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"赞result = %@",responseObject);
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            if ([[result objectForKey:@"ret"] intValue] == 1) {
                [self displayNotification:nil titleStr:@"点赞成功" Duration:0.8 time:0.2];
            }else {
                [self displayNotification:nil titleStr:@"您已经点赞过了" Duration:0.8 time:0.2];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error:%@",error.description);
        }];
    }else if (buttonIndex==3){
        //举报
        [self selectReport];
    }else if (buttonIndex==4){
        //取消
        return;
    }
    
}

//举报
//选择举报类型
-(void)selectReport
{
    self.reportView.hidden = NO;
    [self reportUIConfig];
}

-(void)reportBtnClicked:(UIButton *)button
{
    if(button.tag == 100){
        [self.seQingBtn setImage:[UIImage imageNamed:@"bt_neirongxiangqing_3_1"] forState:UIControlStateNormal];
        [self.gongJiBtn setImage:[UIImage imageNamed:@"bt_neirongxiangqing_3_1"] forState:UIControlStateNormal];
        [self.qiTaBtn setImage:[UIImage imageNamed:@"bt_neirongxiangqing_3_1"] forState:UIControlStateNormal];
        [self.qiPianBtn setImage:[UIImage imageNamed:@"bt_neirongxiangqing_3"] forState:UIControlStateNormal];
        reportType = @"1";
    }else if (button.tag == 101){
        [self.qiPianBtn setImage:[UIImage imageNamed:@"bt_neirongxiangqing_3_1"] forState:UIControlStateNormal];
        [self.gongJiBtn setImage:[UIImage imageNamed:@"bt_neirongxiangqing_3_1"] forState:UIControlStateNormal];
        [self.qiTaBtn setImage:[UIImage imageNamed:@"bt_neirongxiangqing_3_1"] forState:UIControlStateNormal];
        [self.seQingBtn setImage:[UIImage imageNamed:@"bt_neirongxiangqing_3"] forState:UIControlStateNormal];
        reportType = @"2";
    }else if (button.tag == 102){
        [self.qiPianBtn setImage:[UIImage imageNamed:@"bt_neirongxiangqing_3_1"] forState:UIControlStateNormal];
        [self.qiTaBtn setImage:[UIImage imageNamed:@"bt_neirongxiangqing_3_1"] forState:UIControlStateNormal];
        [self.seQingBtn setImage:[UIImage imageNamed:@"bt_neirongxiangqing_3_1"] forState:UIControlStateNormal];
        [self.gongJiBtn setImage:[UIImage imageNamed:@"bt_neirongxiangqing_3"] forState:UIControlStateNormal];
        reportType = @"3";
    }else if (button.tag == 103){
        [self.qiPianBtn setImage:[UIImage imageNamed:@"bt_neirongxiangqing_3_1"] forState:UIControlStateNormal];
        [self.seQingBtn setImage:[UIImage imageNamed:@"bt_neirongxiangqing_3_1"] forState:UIControlStateNormal];
        [self.gongJiBtn setImage:[UIImage imageNamed:@"bt_neirongxiangqing_3_1"] forState:UIControlStateNormal];
        [self.qiTaBtn setImage:[UIImage imageNamed:@"bt_neirongxiangqing_3"] forState:UIControlStateNormal];
        reportType = @"0";
    }
}

//确定举报
- (IBAction)quedingClicked:(UIButton *)sender {
    NSString *userId = [USER_DEFAULT objectForKey:@"userId"];
    if (!userId) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        BaseNavigationController *base = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:base animated:YES completion:nil];
        return;
    }
    if (_manager) {
        _manager = nil;
    }
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//如果报接口类型不一致请替换
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *dic = @{@"comment_id":_replyId,
                          @"user_id":userId,
                          @"type":reportType};
    NSString *token = [CustomEncrypt jiamiWithDictionary:dic];
    NSDictionary *dict = @{@"comment_id":_replyId,
                           @"user_id":userId,
                           @"type":reportType,
                           @"token":token};
    [_manager POST:kReport parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"举报result = %@",responseObject);
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([[result objectForKey:@"ret"] intValue] == 1) {
            [self displayNotification:nil titleStr:@"举报成功" Duration:0.8 time:0.2];
        }else {
            //            [self displayNotification:nil titleStr:@"举报失败" Duration:0.8 time:0.2];
            NSString *msg = [result objectForKey:@"msg"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error.description);
    }];
    
    //隐藏举报 View
    reportType = @"";
    self.reportView.hidden = YES;
}
- (IBAction)cancelBtnClicked:(UIButton *)sender {
    self.reportView.hidden = YES;
}


@end
