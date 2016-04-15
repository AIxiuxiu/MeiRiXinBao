//
//  CollectInfoViewController.h
//  News
//
//  Created by iyoudoo on 15/2/6.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import "XinwenTableViewCell.h"
//#import "GentieTableViewCell.h"
//#import "TupianTableViewCell.h"
//#import "BaseNavigationController.h"

//新闻
#import "DetailViewController.h"
//图片
#import "PicturesViewController.h"
//跟帖
#import "CommentViewController.h"
//刷新
#import "MJRefresh.h"
@protocol collectViewControllerDelegate;
@interface CollectInfoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    AFHTTPRequestOperationManager *_manager;
    MBProgressHUD *_HUD;
    
    NSMutableArray *dataDic;
    
    //新闻
    NSString *newsId;//跟帖   新闻 ID 号
    NSDictionary *typeOneDic;
    
    //跟帖
    NSDictionary *typeTwoDic;
    
    //图片
    NSDictionary *typeThreeDic;
    
    //收藏
    NSString *collectType;
}

@property (assign, nonatomic) BOOL editing;
@property (strong, nonatomic) NSDictionary *collectDic;
@property (strong, nonatomic) IBOutlet UITableView *collectTableView;
@property (weak, nonatomic) id<collectViewControllerDelegate> delegate;
@property (assign,nonatomic) BOOL isFirstCollect;
- (void)viewDidCurrentViewCollect;
@end


@protocol collectViewControllerDelegate <NSObject>

- (void)pushToType:(NSInteger)type andObject:(id)object;

@end
