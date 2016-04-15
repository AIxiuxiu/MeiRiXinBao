//
//  ContentViewController.h
//  News
//
//  Created by ink on 15/2/12.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentViewController : UIViewController<UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UITextView *textView;

@property (copy, nonatomic) NSString *content;

@end
