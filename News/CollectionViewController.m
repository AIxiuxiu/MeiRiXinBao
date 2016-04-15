//
//  CollectionViewController.m
//  News
//
//  Created by iyoudoo on 15/2/5.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import "CollectionViewController.h"

@interface CollectionViewController ()
{
    UIButton *_deleBtn;
}
@end

@implementation CollectionViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    vcArray = [[NSMutableArray alloc] init];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCollectionView) name:@"refreshCollectionView" object:nil];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self UIConfig];
}

#pragma mark - 创建UI
- (void)UIConfig
{
    self.title = @"我的收藏";
    
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 30);
    [button addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"icon_neirongxiangqing_1"] forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    _deleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleBtn.frame = CGRectMake(0, 0, 60, 30);
//    [_deleBtn setImage:[UIImage imageNamed:@"bt_wodeshoucang"] forState:UIControlStateNormal];
    [_deleBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [_deleBtn addTarget:self action:@selector(deleteCell) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_deleBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
//    NSArray *segmentedArray=[[NSArray alloc] init];
//    segmentedArray = [NSArray arrayWithObjects:@"新闻",@"图片",@"跟帖",nil];
//    //初始化UISegmentedControl
//    segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
////    segmentedControl.frame = CGRectMake(337.0, 84, 350.0, 29);
//    segmentedControl.frame = CGRectMake(0, 70, SCREEN_W, 40);
//    segmentedControl.selectedSegmentIndex = 0;//设置默认选择项索引
//    [segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
//    [self.view addSubview:segmentedControl];
    
    self.collectionSlideSwitchView.tabItemNormalColor = [SUNSlideSwitchView colorFromHexRGB:@"868686"];
    self.collectionSlideSwitchView.tabItemSelectedColor = [SUNSlideSwitchView colorFromHexRGB:@"bb0b15"];
    self.collectionSlideSwitchView.shadowImage = [[UIImage imageNamed:@"red_line_and_shadow.png"]
                                        stretchableImageWithLeftCapWidth:63.0f topCapHeight:0.0f];
    self.collectionSlideSwitchView.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    [self.collectionSlideSwitchView buildUI];//创建子视图UI

}

//- (void)backButtonClicked {
//    [self dismissViewControllerAnimated:YES completion:^{
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMainView" object:nil];
//    }];
//}

- (void)backButtonClicked {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - 右边删除按钮
- (void)deleteCell {
    if (vcArray.count == 0) {
        return;
    }
    _deleBtn.selected = !_deleBtn.selected;
    if (_deleBtn.selected) {
        [_deleBtn setTitle:@"完成" forState:UIControlStateNormal];
    }else {
        [_deleBtn setTitle:@"编辑" forState:UIControlStateNormal];
    }
    for (CollectInfoViewController *vc in vcArray) {
        vc.editing = _deleBtn.selected;
    }
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

//- (void)refreshCollectionView {
//    self.collectionSlideSwitchView.userSelectedChannelID = 100;
//    [vcArray removeAllObjects];
//    [self.collectionSlideSwitchView buildUI];//创建子视图UI
//}

// ********   SUNSlideSwitchView
- (NSUInteger)numberOfTab:(SUNSlideSwitchView *)view{
    return 3;
}
- (void)slideSwitchView:(SUNSlideSwitchView *)view panLeftEdge:(UIPanGestureRecognizer *)panParam
{
    MMDrawerController *drawerController = (MMDrawerController *)self.navigationController.mm_drawerController;
    [drawerController panGestureCallback:panParam];
}
- (void)slideSwitchView:(SUNSlideSwitchView *)view panRightEdge:(UIPanGestureRecognizer*) panParam {
    MMDrawerController *drawerController = (MMDrawerController *)self.navigationController.mm_drawerController;
    [drawerController panGestureCallback:panParam];
}
- (UIViewController *)slideSwitchView:(SUNSlideSwitchView *)view viewOfTab:(NSUInteger)number
{
//    NSArray *array = [[NSArray alloc] initWithObjects:@"新闻",@"图片",@"跟帖",nil];
    NSDictionary *dictionary1 = @{@"title":@"新闻",@"type":@"1"};
    NSDictionary *dictionary2 = @{@"title":@"图片",@"type":@"3"};
    NSDictionary *dictionary3 = @{@"title":@"跟帖",@"type":@"2"};
    NSArray *array = [[NSArray alloc] initWithObjects:dictionary1,dictionary2,dictionary3,nil];
//    NSDictionary *dict = [array objectAtIndex:number];
//    ListViewController *listVc = [[ListViewController alloc] init];
//    listVc.delegate = self;
//    listVc.dict = dict;
//    listVc.title = (NSString *)[dict objectForKey:@"title"];
    NSDictionary *dict = [array objectAtIndex:number];
    CollectInfoViewController *collectInfoVC = [[CollectInfoViewController alloc] init];
    collectInfoVC.delegate = self;
    collectInfoVC.collectDic = dict;
    NSLog(@"尚赫字典===%@",dict);
    NSString *collectType = [NSString stringWithFormat:@"%@",[dict objectForKey:@"type"]];
    NSLog(@"尚赫===%@",collectType);
    
    collectInfoVC.title = [[array objectAtIndex:number] objectForKey:@"title"];
    NSLog(@"尚赫铺床标题==%@",collectInfoVC.title);
    [vcArray addObject:collectInfoVC];
    return collectInfoVC;
}
- (void)slideSwitchView:(SUNSlideSwitchView *)view didselectTab:(NSUInteger)number
{
    CollectInfoViewController *collectVC = [vcArray objectAtIndex:number];
    [collectVC viewDidCurrentViewCollect];
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

- (void)pushToType:(NSInteger)type andObject:(id)object {
    NSDictionary *dictionary = (NSDictionary *)object;
    
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
    }else if (type == 4) {
        //跟帖页面
        CommentViewController *commentVC = [[CommentViewController alloc] init];
        commentVC.newsId = [dictionary objectForKey:@"id"];
        commentVC.isFromPic = NO;//不是从图片的页面
        [self.navigationController pushViewController:commentVC animated:YES];
    }
}



@end
