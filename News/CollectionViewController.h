//
//  CollectionViewController.h
//  News
//
//  Created by iyoudoo on 15/2/5.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SUNSlideSwitchView.h"
#import "MMDrawerController.h"
#import "MMDrawerController+Subclass.h"
//#import "ListViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "BaseNavigationController.h"

#import "CollectInfoViewController.h"

#import "CommentViewController.h"
@interface CollectionViewController : UIViewController<SUNSlideSwitchViewDelegate,collectViewControllerDelegate>
{
//    UISegmentedControl *segmentedControl;
    NSInteger selectNum;
    NSMutableArray *vcArray;
    
    AFHTTPRequestOperationManager *_AFManager;
    AFHTTPRequestOperationManager *_manager;

}

@property (strong, nonatomic) IBOutlet SUNSlideSwitchView *collectionSlideSwitchView;






@end
