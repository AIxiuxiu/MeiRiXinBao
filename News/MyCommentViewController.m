//
//  MyCommentViewController.m
//  News
//
//  Created by ink on 15/2/13.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import "MyCommentViewController.h"

@interface MyCommentViewController ()
{
    NSMutableArray *_dataArray;
    NSInteger _pageNum;
    BOOL _isFreshing;
    NSString *_replyID;
}
@end

@implementation MyCommentViewController
- (void)UIConfig
{
    self.title = @"我的跟帖";
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 30);
    [button addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"icon_neirongxiangqing_1"] forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftItem;
}
#pragma mark -返回按钮
- (void)backButtonClicked {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commentBack:) name:@"myCommentBack" object:nil];
    
    
    self.selectSeg.center = self.segView.center;
    
    [self.tableView addHeaderWithTarget:self action:@selector(refresh)];
    [self.tableView addFooterWithTarget:self action:@selector(freshMore)];
    _pageNum = 1;
    _dataArray = [[NSMutableArray alloc] init];
    [self UIConfig];
        [self.tableView headerBeginRefreshing];
        [self.tableView footerBeginRefreshing];
    _isFreshing = YES;
    [self getMyComments];
    // Do any additional setup after loading the view from its nib.
}


- (void)refresh {
    if (_isFreshing) {
        return;
    }
    _isFreshing = YES;
    _pageNum = 1;
    
    [self getMyComments];
}
- (void)freshMore {
    if (_isFreshing) {
        return;
    }
    _isFreshing = YES;
    _pageNum ++;
    [self getMyComments];
}

#pragma mark - 获取网络数据
- (void)getMyComments {
    NSString *userId = [USER_DEFAULT objectForKey:@"userId"];
    if (_manager) {
        _manager = nil;
    }
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//如果报接口类型不一致请替换
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *dic = @{@"user_id":userId,
                          @"p":[NSString stringWithFormat:@"%ld",(long)_pageNum]};
    NSString *token = [CustomEncrypt jiamiWithDictionary:dic];
    NSDictionary *dict = @{@"user_id":userId,
                           @"p":[NSString stringWithFormat:@"%ld",(long)_pageNum],
                           @"token":token};
    [_manager POST:kMyComment parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _isFreshing  = NO;
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([[result objectForKey:@"ret"] intValue] == 1) {
            NSLog(@"result = %@",result);
            NSArray *array = [result objectForKey:@"data"];
            if (_pageNum == 1) {
                [_dataArray removeAllObjects];
            }
            [_dataArray addObjectsFromArray:array];
            [self.tableView reloadData];
        }else {
            NSString *msg = [result objectForKey:@"msg"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error.description);
        _isFreshing = NO;
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"myBackCell";
    MyBackCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyBackCell" owner:self options:nil] lastObject];
    }
    [self loadCellContent:cell indexPath:indexPath];
    [cell layoutIfNeeded];
    [cell updateConstraintsIfNeeded];
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    return height;
}

- (void)loadCellContent:(MyBackCell*)cell indexPath:(NSIndexPath*)indexPath
{
    //这里把数据设置给Cell
    NSDictionary *dict = [_dataArray objectAtIndex:indexPath.row];
    NSString *headStr = [USER_DEFAULT objectForKey:@"headImageStr"];
    NSString *nickStr = [USER_DEFAULT objectForKey:@"userNick"];
    cell.dataDic = dict;
    [cell.headTopImage setImageWithURL:[NSURL URLWithString:headStr] placeholderImage:[UIImage imageNamed:@"icon_youbianlan_1.png"]];
    cell.nickLabel.text = nickStr;
    cell.timeLabel.text = [dict objectForKey:@"time"];
    cell.contentLabel.text = [dict objectForKey:@"content"];
    //
    [cell.newsPic setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"picture"]] placeholderImage:[UIImage imageNamed:@"jpg_shouye_1"]];
    cell.newsTitle.text = [dict objectForKey:@"title"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"myBackCell";
    MyBackCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyBackCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.nickLabel.textColor = [UIColor colorWithRed:0.29f green:0.01f blue:0.00f alpha:1.00f];
        cell.headTopImage.layer.masksToBounds = YES;
        cell.headTopImage.layer.cornerRadius = 25;
    }
    [self loadCellContent:cell indexPath:indexPath];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = [_dataArray objectAtIndex:indexPath.row];
    NSString *newsId = [NSString stringWithFormat:@"%@",[dict objectForKey:@"news_id"]];
    CommentViewController *commentVC = [[CommentViewController alloc] init];
    commentVC.newsId = newsId;
    commentVC.isFromPic = NO;//不是从图片的页面
    [self.navigationController pushViewController:commentVC animated:YES];
}
- (void)commentVC:(NSString *)commentId {
    CommentViewController *commentVC = [[CommentViewController alloc] init];
    commentVC.newsId = commentId;
    commentVC.isFromPic = NO;//不是从图片的页面
    [self.navigationController pushViewController:commentVC animated:YES];
}
#pragma mark - MyBackCellDelegate
- (void)newsViewClicked:(NSDictionary *)dic {
    NSInteger type = [[dic objectForKey:@"type"] intValue];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValuesForKeysWithDictionary:dic];
    [dictionary removeObjectForKey:@"id"];
    [dictionary setObject:[dictionary objectForKey:@"news_id"] forKey:@"id"];
    if (type == 1) {
        //只有文本
        DetailViewController *detailVC = [[DetailViewController alloc] init];
        detailVC.isWithPic = NO;
        detailVC.infoDic = dictionary;
        BaseNavigationController *base = [[BaseNavigationController alloc] initWithRootViewController:detailVC];
        base.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:base animated:YES completion:nil];
    }else if (type == 2) {
        //图文
        DetailViewController *detailVC = [[DetailViewController alloc] init];
        detailVC.isWithPic = YES;
        detailVC.infoDic = dictionary;
        BaseNavigationController *base = [[BaseNavigationController alloc] initWithRootViewController:detailVC];
        base.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:base animated:YES completion:nil];
    }else if (type == 0) {
        //只有图
        PicturesViewController *picVC = [[PicturesViewController alloc] init];
        picVC.infoDic = dictionary;
        [self presentViewController:picVC animated:YES completion:nil];
    }

    NSLog(@"%@",[dic objectForKey:@"news_id"]);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)selectSegChange:(id)sender {
    if (self.selectSeg.selectedSegmentIndex == 0) {
        self.tableView.hidden = NO;
        _secondView.hidden = YES;
    }else{
        self.tableView.hidden = YES;
        if (!_secondView) {
//            _secondView = [[MsgBackView alloc] init];
            _secondView = [[[NSBundle mainBundle] loadNibNamed:@"MsgBackView" owner:self options:nil] lastObject];
            _secondView.delegate = self;
            _secondView.frame = self.tableView.frame;
            [self.view addSubview:_secondView];
        }
        _secondView.hidden = NO;
    }
}
#pragma mark - commentBack
- (void)commentBack:(NSNotification *)notification {
    NSLog(@"notification= %@     ====    %@",notification.userInfo,notification.object);
    NSDictionary *dict = (NSDictionary *)notification.object;
    _replyID = [dict objectForKey:@"comment_id"];
    NSString *str = [USER_DEFAULT objectForKey:@"userId"];
    if (!str) {
        LoginViewController *logVC = [[LoginViewController alloc] init];
        BaseNavigationController *base = [[BaseNavigationController alloc] initWithRootViewController:logVC];
        [self presentViewController:base animated:YES completion:nil];
        return;
    }
    [self showCommentText];
}
#pragma mark - 回复的方法
-(void)cancelBtnClicked
{
    [popOverView removeFromSuperview];
    [reviewTextView resignFirstResponder];
    reviewTextView.text = @"";
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
    
    NSString *personId = _replyID;
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
    if (!_HUD) {
        _HUD = [[MBProgressHUD alloc] initWithView:self.view];
        _HUD.labelText = @"loading...";
        [self.view addSubview:_HUD];
    }
    [_HUD show:YES];
    [_reviewManager POST:kCommentAdd parameters:dictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        reviewTextView.text = @"";
        NSLog(@"新闻评论返回结果==%@",responseObject);
        [_HUD hide:YES];
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([[result objectForKey:@"ret"] intValue] == 1) {
            NSLog(@"personId数据成功");
            [self displayNotification:nil titleStr:@"回复成功" Duration:0.8 time:0.2];
            [self.tableView reloadData];
        }else {
            NSString *msg = [result objectForKey:@"msg"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_HUD hide:YES];
        reviewTextView.text = @"";
        NSLog(@"error:%@",error.description);
    }];
    
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

@end
