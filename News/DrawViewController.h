//
//  DrawViewController.h
//  News
//
//  Created by ink on 15/2/12.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawViewController : UIViewController<UIWebViewDelegate>
{
    MBProgressHUD *_HUD;
}

@property (copy,nonatomic)NSString *userId;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@end
