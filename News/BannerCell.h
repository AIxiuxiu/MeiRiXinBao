//
//  BannerCell.h
//  News
//
//  Created by ink on 15/1/26.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BannerCellDelegate <NSObject>

- (void) clickedWithNewsDic:(NSDictionary *)dic;

@end

@interface BannerCell : UITableViewCell<UIScrollViewDelegate>

@property (strong, nonatomic) NSMutableArray *banners;

@property (strong, nonatomic) NSMutableArray *PictureArray;


@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *textLabel1;

@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
//代理
@property (weak, nonatomic) id<BannerCellDelegate>delegate;
- (IBAction)pageChange:(id)sender;
- (void)fillData;
@end
