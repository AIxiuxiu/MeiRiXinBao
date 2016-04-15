//
//  SearchViewController.h
//  News
//
//  Created by iyoudoo on 15/2/3.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import <UIKit/UIKit.h>

//文字+图片+图文混排
#import "NewListCell.h"
#import "NoPicCell.h"
#import "PicCell.h"

//列表详情页面
#import "DetailViewController.h"
#import "BaseNavigationController.h"
#import "PicturesViewController.h"

#pragma mark -change by zhang
#import "MJRefresh.h"

//@protocol searchViewControllerDelegate;

@interface SearchViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    MBProgressHUD *_HUD;
    AFHTTPRequestOperationManager *_searchManager;
    
    //NSMutableDictionary *dataDic;
   
    NSArray *dataDic;
    
    NSArray *_dataArray;
    
    //热点列表
    UITableView *hotTableView;
    UIButton *leftHotButton;
    UIButton *rightHotButton;
    
    #pragma mark -change by zhang
    NSInteger _pageNum;
}

//@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
//输入的搜索字符串
@property (copy, nonatomic) NSString *searchStr;

@property (strong,nonatomic) NSMutableDictionary *searchDict;
@property (strong,nonatomic) IBOutlet UITableView *searchTableView;
//@property (weak,nonatomic) id<searchViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITextField *searchTF;

- (IBAction)searchBtnClicked:(id)sender;
@end

//@protocol searchViewControllerDelegate <NSObject>
//
//-(void)pushToType:(NSInteger)type andObject:(id)object;
//
//@end
