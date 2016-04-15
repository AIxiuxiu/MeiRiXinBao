//
//  Connect.m
//  News
//
//  Created by ink on 15/2/6.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import "Connect.h"

@implementation Connect
+ (BOOL)canLoadImage {
    NSString *wifi = [USER_DEFAULT objectForKey:@"wifi"];
    if (wifi) {
        Reachability *r = [Reachability reachabilityForInternetConnection];
        [r startNotifier];
        if (r.currentReachabilityStatus == ReachableViaWiFi) {
            return YES;
        }else {
            return NO;
        }
    }else {
        return YES;
    }
}
@end
