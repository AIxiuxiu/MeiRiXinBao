//
//  QuestionViewController.h
//  News
//
//  Created by ink on 15/2/11.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionViewController : UIViewController<UIWebViewDelegate>
{
    MBProgressHUD *_HUD;
}
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@property (copy, nonatomic) NSString *urlStr;
@end
