//
//  BannerCell.m
//  News
//
//  Created by ink on 15/1/26.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import "BannerCell.h"
#define K_GETSIZE(_info_) CGSize size = [_info_ boundingRectWithSize:CGSizeMake(300, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size;
@implementation BannerCell
- (void)fillData {

    [self freshView];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)awakeFromNib {
    self.scrollView.delegate = self;
    self.scrollView.userInteractionEnabled = YES;
}
- (void)freshView {
    if (self.banners.count == 0) {
        self.textLabel1.text = @"";
        return;
    }
       if (self.banners.count == 1) {
        
           self.textLabel1.frame = CGRectMake(self.textLabel1.frame.origin.x, self.textLabel1.frame.origin.y, SCREEN_W-8, self.textLabel1.frame.size.height);
    }else
    {
        [self.banners insertObject:[self.banners lastObject] atIndex:0];
        [self.banners insertObject:[self.banners objectAtIndex:1] atIndex:self.banners.count];
    }
    self.scrollView.contentSize = CGSizeMake(self.banners.count*SCREEN_W, 0);
    self.scrollView.pagingEnabled = YES;
    self.pageControl.numberOfPages = self.banners.count-2;
    self.pageControl.currentPage = 0;
    self.scrollView.contentOffset = CGPointMake(SCREEN_W, 0);;
    self.scrollView.showsHorizontalScrollIndicator = NO;

    NSLog(@" self.banners===%@",self.banners);
  //  self.PictureArray = [dic objectForKey:@"picture"];
    for (int i=0; i<self.banners.count; i++) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped:)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_W*i, 0, SCREEN_W, 190)];
        imageView.userInteractionEnabled = YES;
        NSDictionary *dic = [self.banners objectAtIndex:i];
        NSString *picStr = [dic objectForKey:@"picture"];
        [imageView setImageWithURL:[NSURL URLWithString:picStr] placeholderImage:[UIImage imageNamed:@"jpg_shouye_1"]];
        imageView.tag = 100+i;
        [imageView addGestureRecognizer:tap];
        [self.scrollView addSubview:imageView];
    }
    NSDictionary *dic;
    if (self.banners.count == 1) {
         dic = [self.banners objectAtIndex:0];
    }else
    {
         dic = [self.banners objectAtIndex:1];
    }
   
    self.textLabel1.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"text"]];
    self.textLabel1.numberOfLines = 1;

}

- (void)imageViewTapped:(UITapGestureRecognizer *)tap {
    if (self.banners.count == 0) {
        return;
    }
    UIView *view = tap.view;
    NSDictionary *dic = [self.banners objectAtIndex:view.tag-100];
    NSLog(@"tap on %@",[dic objectForKey:@"news_id"]);
    NSDictionary *dict = @{@"id":[dic objectForKey:@"news_id"],
                           @"type":[dic objectForKey:@"type"]};
    if ([self.delegate respondsToSelector:@selector(clickedWithNewsDic:)]) {
        [self.delegate clickedWithNewsDic:dict];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //    NSLog(@"scrollview.x = %f",scrollView.contentOffset.x);
    NSDictionary *dic = [self.banners objectAtIndex:self.scrollView.contentOffset.x/SCREEN_W];
    self.textLabel1.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"text"]];
    if (self.banners.count != 1) {

        if (self.scrollView.contentOffset.x/SCREEN_W == self.banners.count-1) {
            self.scrollView.contentOffset = CGPointMake(SCREEN_W, 0);
            
        }else if(self.scrollView.contentOffset.x/SCREEN_W == 0)
        {
            self.scrollView.contentOffset = CGPointMake((self.banners.count-2)* SCREEN_W, 0);

        }

    }
       self.pageControl.currentPage = (self.scrollView.contentOffset.x/SCREEN_W-1);
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (IBAction)pageChange:(id)sender {
    [UIView animateWithDuration:0.25 animations:^{
        NSDictionary *dic = [self.banners objectAtIndex:self.pageControl.currentPage];
        self.textLabel1.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"text"]];
        self.scrollView.contentOffset = CGPointMake(self.pageControl.currentPage*SCREEN_W, 0);
    }];
}

@end
