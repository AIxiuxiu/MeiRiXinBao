//
//  AboutUsViewController.h
//  MedicineHall
//
//  Created by ink on 14/11/19.
//  Copyright (c) 2014年 ink. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutUsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@end
