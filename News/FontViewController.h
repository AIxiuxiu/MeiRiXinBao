//
//  FontViewController.h
//  News
//
//  Created by ink on 15/1/27.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FontViewControllerDelegate<NSObject>

- (void)selectFontWithString:(NSString *)font;

@end
@interface FontViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) id<FontViewControllerDelegate>delegate;

@end
