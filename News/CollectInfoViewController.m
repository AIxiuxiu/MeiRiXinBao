//
//  CollectInfoViewController.m
//  News
//
//  Created by iyoudoo on 15/2/6.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import "CollectInfoViewController.h"

@interface CollectInfoViewController ()
{
    NSInteger _pageNum;
}
@end

@implementation CollectInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isFirstCollect = YES;
    
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_HUD];
    dataDic = [[NSMutableArray alloc] init];
    
    [self.collectTableView addHeaderWithTarget:self action:@selector(refresh)];
    [self.collectTableView addFooterWithTarget:self action:@selector(freshMore)];
    self.editing = NO;
    [self addObserver:self forKeyPath:@"editing" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}
- (void)dealloc {
    [self removeObserver:self forKeyPath:@"editing" context:nil];
}
#pragma mark -监听“垃圾桶”事件
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    NSLog(@"editing = %d",self.editing);
    if (self.editing) {
        //编辑状态
        [self.collectTableView setEditing:YES animated:YES];
    }else {
        //正常状态
        [self.collectTableView setEditing:NO animated:YES];
    }
}

#pragma mark - 删除Cell
//单元格返回的编辑风格，包括删除 添加 和 默认  和不可编辑三种风格
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        [self deleteCellWithIndexPath:indexPath];
        
        
    }
}
#pragma mark - 删除功能
- (void)deleteCellWithIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *collectDic = [dataDic objectAtIndex:indexPath.row];
    NSString *collectId = [collectDic objectForKey:@"collect_id"];
    
    if (_manager) {
        _manager = nil;
    }
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//如果报接口类型不一致请替换
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *dic = @{@"id":collectId};
    NSString *token = [CustomEncrypt jiamiWithDictionary:dic];
    NSDictionary *dict = @{@"id":collectId,
                           @"token":token};
    [_manager POST:kDeleteCollection parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([[result objectForKey:@"ret"] intValue] == 1) {
            //        获取选中删除行索引值
            NSInteger row = [indexPath row];
            //        通过获取的索引值删除数组中的值
            [dataDic removeObjectAtIndex:row];
            //        删除单元格的某一行时，在用动画效果实现删除过程
            [self.collectTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }else {
            [self displayNotification:nil titleStr:@"操作失败" Duration:0.5 time:0.2];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error.description);
    }];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  @"     删除";
}
#pragma mark -上下拉刷新
- (void)refresh {
//    if (self.editing) {
//        [self displayNotification:nil titleStr:@"正在编辑,请先退出编辑" Duration:0.5 time:0.2];
//        [self.collectTableView headerEndRefreshing];
//        return;
//    }
    _pageNum = 1;
    
    [self getNewsInfo];
}
- (void)freshMore {
//    if (self.editing) {
//        [self displayNotification:nil titleStr:@"正在编辑,请先退出编辑" Duration:0.5 time:0.2];
//        [self.collectTableView footerEndRefreshing];
//        return;
//    }
    _pageNum++;
    [self getNewsInfo];
}

- (void)viewDidCurrentViewCollect {
    if (self.isFirstCollect) {
        _isFirstCollect = NO;
        _pageNum = 1;
        [self getNewsInfo];
    }
    
}

- (void)getNewsInfo {
    if (_manager) {
        _manager = nil;
    }
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//如果报接口类型不一致请替换
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    NSString *collectionUserId = [USER_DEFAULT objectForKey:@"userId"];
//    NSDictionary *dic = @{@"user_id":collectionUserId};

    collectType = [NSString stringWithFormat:@"%@",[self.collectDic objectForKey:@"type"]];
    NSString *userId = [USER_DEFAULT objectForKey:@"userId"];
    
    NSDictionary *dic = @{@"type":collectType,
                          @"user_id":userId,
                          @"p":[NSString stringWithFormat:@"%ld",(long)_pageNum]};
    NSString *token = [CustomEncrypt jiamiWithDictionary:dic];
    NSDictionary *dictionary = @{@"type":collectType,
                                 @"user_id":userId,
                                 @"p":[NSString stringWithFormat:@"%ld",(long)_pageNum],
                                 @"token":token};
    [_HUD show:YES];
    [_manager POST:kCollect parameters:dictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"newsInfo确定 = %@",responseObject);
        [_HUD hide:YES];
        [self.collectTableView headerEndRefreshing];
        [self.collectTableView footerEndRefreshing];
        if (_pageNum==1) {
            [dataDic removeAllObjects];
        }
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([[result objectForKey:@"ret"] intValue] == 1) {
            //            NSDictionary *data = [result objectForKey:@"data"];
            NSArray *array = [result objectForKey:@"data"];
            [dataDic addObjectsFromArray:array];
//            newsId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"news_id"]];
            [self.collectTableView reloadData];
            
        }else {
            NSString *msg = [result objectForKey:@"msg"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_HUD hide:YES];
        [self.collectTableView headerEndRefreshing];
        [self.collectTableView footerEndRefreshing];
        NSLog(@"error:%@",error.description);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 列表代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataDic.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID=@"resultTableCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    
    if(cell == nil)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
    }
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    self.collectTableView.separatorStyle = UITableViewCellSeparatorStyleNone;//隐藏分割线
//     NSDictionary *dic = [dataDic objectAtIndex:indexPath.row];
        //1新闻 2跟帖 3图片
//        if ([[dic objectForKey:@"type"] intValue] == 1) {
         if([collectType intValue]== 1){
             UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W-10, 160)];
             view.backgroundColor = [UIColor whiteColor];
             [cell.contentView addSubview:view];
             
            UIImageView *viewImageOne = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, SCREEN_W-20, 150)];
            UIImage *imageOne = [UIImage imageNamed:@"bg_shoucangxinwen_1"];
            viewImageOne.image = imageOne;
            [cell.contentView addSubview:viewImageOne];
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, SCREEN_W-40, 30)];
            titleLabel.textColor = [UIColor whiteColor];
            [titleLabel setFont:[UIFont fontWithName:nil size:19]];
            //            titleLabel.backgroundColor = [UIColor yellowColor];
            titleLabel.text = [[dataDic objectAtIndex:indexPath.row] objectForKey:@"title"];
            [cell.contentView addSubview:titleLabel];
            
            UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 65, SCREEN_W-40, 50)];
            contentLabel.textColor = [UIColor grayColor];
            [contentLabel setFont:[UIFont fontWithName:nil size:17]];
            //            contentLabel.backgroundColor = [UIColor greenColor];
            contentLabel.text = [[dataDic objectAtIndex:indexPath.row] objectForKey:@"content"];
            contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            contentLabel.numberOfLines = 0;
            [cell.contentView addSubview:contentLabel];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 125, 20, 20)];
            UIImage *image = [UIImage imageNamed:@"icon_wodebaoliao_1"];
            imageView.image = image;
            [cell.contentView addSubview:imageView];
            
            UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 120, SCREEN_W-40,30)];
            timeLabel.textColor = [UIColor colorWithRed:0.501 green:0.524 blue:0.581 alpha:0.5];
#pragma mark +++++
#pragma mark -change by zhang
             NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[NSString stringWithFormat:@"%@",[[dataDic objectAtIndex:indexPath.row] objectForKey:@"time"]] intValue]];
             NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
             [formatter setDateFormat:@"yyyy-MM-dd"];
             NSString *dateStr = [formatter stringFromDate:date];
             timeLabel.text = dateStr;

            [timeLabel setFont:[UIFont fontWithName:nil size:15]];
            [cell.contentView addSubview:timeLabel];

        // 2跟帖
//        }else if ([[dic objectForKey:@"type"] intValue] == 2) {
         }else if([collectType intValue]== 2){
             UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W-10, 150)];
             view.backgroundColor = [UIColor whiteColor];
             [cell.contentView addSubview:view];
             
             NSDictionary *dict = [dataDic objectAtIndex:indexPath.row];
             
             UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, SCREEN_W-20, 140)];
             backImage.image = [UIImage imageNamed:@"bg_wodebaoliao_1"];
             [cell.contentView addSubview:backImage];
             
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, SCREEN_W-80, 30)];
             titleLabel.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"title"]];
            titleLabel.font = [UIFont fontWithName:nil size:20];
            titleLabel.textColor = [UIColor redColor];
            [cell.contentView addSubview:titleLabel];
//            titleLabel.backgroundColor = [UIColor yellowColor];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_W-46, 12, 26, 26)];
            UIImage *image = [UIImage imageNamed:@"icon_shoucanggentie_1"];
            imageView.image = image;
            [cell.contentView addSubview:imageView];
            
             
            UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 45, SCREEN_W-40, 60)];
            [cell.contentView addSubview:contentLabel];
             contentLabel.numberOfLines = 2;
             contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
            contentLabel.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"content"]];
//            contentLabel.backgroundColor = [UIColor greenColor];
            
             UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 115, 20, 20)];
             UIImage *image1 = [UIImage imageNamed:@"icon_wodebaoliao_1"];
             imageView1.image = image1;
             [cell.contentView addSubview:imageView1];
             
            UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 110, SCREEN_W-70,30)];
            titleLabel.textColor = [UIColor colorWithRed:0.501 green:0.524 blue:0.581 alpha:0.5];
//            timeLabel.backgroundColor = [UIColor blueColor];
            timeLabel.text = @"";
            [cell.contentView addSubview:timeLabel];
             
        // 3图片
//        }else if ([[dic objectForKey:@"type"] intValue] == 3) {
        }else if([collectType intValue]== 3){
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W-10, 200)];
            view.backgroundColor = [UIColor whiteColor];
            [cell.contentView addSubview:view];
            
            //下面
            UIImageView *imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, SCREEN_W-40, 150)];
            //imageView2.backgroundColor = [UIColor greenColor];
            NSURL *url=[NSURL URLWithString:[[dataDic objectAtIndex:indexPath.row] objectForKey:@"url"]];
            [imageView2 setImageWithURL:url placeholderImage:nil];
            
            //添加边框
            CALayer * layer = [imageView2 layer];
            layer.borderColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f].CGColor;
            layer.borderWidth = 5.0f;
            
            [cell.contentView addSubview:imageView2];
            
            //上面边框
            UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(10, 20, SCREEN_W-20, 175)];
            bottomView.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
            [cell.contentView addSubview:bottomView];
            
            //上面
            UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, SCREEN_W-30, 130)];
            //imageView1.backgroundColor = [UIColor redColor];
            [imageView1 setImageWithURL:url placeholderImage:nil];
            [bottomView addSubview:imageView1];
            
            
            //标题
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 140, SCREEN_W-100, 30)];
//            titleLabel.backgroundColor = [UIColor yellowColor];
            titleLabel.font = [UIFont fontWithName:nil size:17];
            titleLabel.text = [[dataDic objectAtIndex:indexPath.row] objectForKey:@"title"];
            [bottomView addSubview:titleLabel];
            
            //共多少张
            UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_W-85, 140, 40, 30)];
//            numLabel.backgroundColor = [UIColor blueColor];
            //            numLabel.text = [NSString stringWithFormat:@"%@张",[]];
            numLabel.text = [NSString stringWithFormat:@"%@",[[dataDic objectAtIndex:indexPath.row] objectForKey:@"count"]];
            numLabel.font = [UIFont fontWithName:nil size:17];
            numLabel.textColor = [UIColor redColor];
            numLabel.textAlignment =  NSTextAlignmentCenter;
            [bottomView addSubview:numLabel];
            
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_W-45, 140, 20, 30)];
//            nameLabel.backgroundColor = [UIColor yellowColor];
            //            numLabel.text = [NSString stringWithFormat:@"%@张",[]];
            //            numLabel.text = @"165 ";
            nameLabel.text = @"张";
            nameLabel.textColor = [UIColor grayColor];
            nameLabel.textAlignment =  NSTextAlignmentCenter;
            [bottomView addSubview:nameLabel];
        }
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//        NSDictionary *dic = [dataDic objectAtIndex:indexPath.row];
//        //1新闻 2跟帖 3图片
//        if ([[dic objectForKey:@"type"] intValue] == 1) {
//            return 160;
//        }else if([[dic objectForKey:@"type"] intValue] == 2){
//            return 150;
//        }else if([[dic objectForKey:@"type"] intValue] == 3){
//            return 200;
//        }else{
//            return 0;
//        }
    if([collectType intValue]== 1){
        return 160;
    }else if([collectType intValue]== 2){
        return 150;
    }else if([collectType intValue]== 3){
        return 200;
    }else{
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [dataDic objectAtIndex:indexPath.row];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValuesForKeysWithDictionary:dic];
    [dict setObject:[dic objectForKey:@"news_id"] forKey:@"id"];
//    NSDictionary *dic = [dataDic objectAtIndex:indexPath.row];
//    //1新闻 2跟帖 3图片
//    if ([[dic objectForKey:@"type"] intValue] == 1) {
//        NSLog(@"新闻");
//    }else if([[dic objectForKey:@"type"] intValue] == 2){
//        NSLog(@"跟帖");
//    }else if([[dic objectForKey:@"type"] intValue] == 3){
//        NSLog(@"图片");
//    }
    if([collectType intValue]== 1){
        NSLog(@"新闻");
        
        if ([[dict objectForKey:@"type"] intValue] == 1) {
            //只有文本
            [self.delegate pushToType:1 andObject:dict];
        }else if ([[dict objectForKey:@"type"] intValue] == 2) {
            //图文
            [self.delegate pushToType:2 andObject:dict];
        }
        
    }else if([collectType intValue]== 2){
        NSLog(@"跟帖");
//        CommentViewController *commentVC = [[CommentViewController alloc] init];
//        BaseNavigationController *base = [[BaseNavigationController alloc] initWithRootViewController:commentVC];
//        base.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//        [self presentViewController:base animated:YES completion:nil];
        [self.delegate pushToType:4 andObject:dict];
    }else if([collectType intValue]== 3){
        NSLog(@"图片");
//        PicturesViewController *picturesVC = [[PicturesViewController alloc] init];
//        picturesVC.infoDic = [dataDic objectAtIndex:indexPath.row];
//        BaseNavigationController *base = [[BaseNavigationController alloc] initWithRootViewController:picturesVC];
//        base.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//        [self presentViewController:base animated:YES completion:nil];
//        [self presentViewController:picturesVC animated:YES completion:nil];
        //只有图
        [self.delegate pushToType:0 andObject:dict];
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
@end
