//
//  MsgBackView.m
//  News
//
//  Created by ink on 15/2/14.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import "MsgBackView.h"

@implementation MsgBackView
{
    NSMutableArray *_dataArray1;
    NSInteger _pageNum;
    BOOL _isFreshing;
}
- (instancetype)init {
    if (self = [super init]) {
        
//
    }
    return self;
}
- (void)awakeFromNib {
    _dataArray1 = [[NSMutableArray alloc] init];
    [self.tableView1 addHeaderWithTarget:self action:@selector(refresh)];
    [self.tableView1 addFooterWithTarget:self action:@selector(freshMore)];
    _pageNum = 1;
    [self.tableView1 headerBeginRefreshing];
    [self.tableView1 footerBeginRefreshing];
    _isFreshing = YES;
    self.tableView1.delegate =self;
    self.tableView1.dataSource = self;
    [self getMsgData];
}
- (void)refresh {
    if (_isFreshing) {
        return;
    }
    _isFreshing = YES;
    _pageNum = 1;
    
    [self getMsgData];
}
- (void)freshMore {
    if (_isFreshing) {
        return;
    }
    _isFreshing = YES;
    _pageNum ++;
    [self getMsgData];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)getMsgData {
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
    [_manager POST:kMyBack parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _isFreshing  = NO;
        [self.tableView1 headerEndRefreshing];
        [self.tableView1 footerEndRefreshing];
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([[result objectForKey:@"ret"] intValue] == 1) {
            NSLog(@"result = %@",result);
            NSArray *array = [result objectForKey:@"data"];
            if (_pageNum == 1) {
                [_dataArray1 removeAllObjects];
            }
            [_dataArray1 addObjectsFromArray:array];
            [self.tableView1 reloadData];
        }else {
            NSString *msg = [result objectForKey:@"msg"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error.description);
        _isFreshing = NO;
        [self.tableView1 headerEndRefreshing];
        [self.tableView1 footerEndRefreshing];
    }];

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray1.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"msgBackCell";
    MsgBackCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MsgBackCell" owner:self options:nil] lastObject];
    }
    [self loadCellContent:cell indexPath:indexPath];
    [cell layoutIfNeeded];
    [cell updateConstraintsIfNeeded];
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    return height;
}

- (void)loadCellContent:(MsgBackCell*)cell indexPath:(NSIndexPath*)indexPath
{
    //这里把数据设置给Cell
    NSDictionary *dict = [_dataArray1 objectAtIndex:indexPath.row];
    NSString *nickStr = [USER_DEFAULT objectForKey:@"userNick"];
    cell.dataDic = dict;
    [cell.headTopImage setImage:[UIImage imageNamed:@"icon_youbianlan_1"]];
    [cell.headTopImage setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"icon_youbianlan_1"]];
    cell.otherNickLabel.text = [dict objectForKey:@"re_username"];
    cell.timeLabel.text = [dict objectForKey:@"time"];
    cell.contentLabel.text = [dict objectForKey:@"re_content"];
    [cell.newsPic setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"picture"]] placeholderImage:[UIImage imageNamed:@"jpg_shouye_1"]];
    cell.newsTitle.text = [dict objectForKey:@"title"];
    cell.myNickLabel.text = [NSString stringWithFormat:@"%@:",@"我"];
    cell.myCommentLabel.text = [dict objectForKey:@"content"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"msgBackCell";
    MsgBackCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MsgBackCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.otherNickLabel.textColor = [UIColor colorWithRed:0.29f green:0.01f blue:0.00f alpha:1.00f];
        cell.myNickLabel.textColor = [UIColor colorWithRed:0.29f green:0.01f blue:0.00f alpha:1.00f];
        cell.headTopImage.layer.masksToBounds = YES;
        cell.headTopImage.layer.cornerRadius = 25;
    }
    [self loadCellContent:cell indexPath:indexPath];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = [_dataArray1 objectAtIndex:indexPath.row];
    NSString *newsId = [NSString stringWithFormat:@"%@",[dict objectForKey:@"news_id"]];
    [self.delegate commentVC:newsId];
}

#pragma mark - MsgCellDelegate
- (void)msgCellNewsViewClicked:(NSDictionary *)dic {
    [self.delegate newsViewClicked:dic];
}
@end
