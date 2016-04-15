//
//  downLoadNews.h
//  News
//
//  Created by ink on 15/2/25.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NewsLoadPath [NSString stringWithFormat:@"%@/Library/newsFile.plist",NSHomeDirectory()]

@interface downLoadNews : NSObject
@property (nonatomic,retain) NSFileManager *fileManager;
//保存
- (void)saveWithArray:(NSArray *)array;
//取出来
- (NSArray *)getOutWithFile;
//

- (BOOL)isExistWithOutNet;
- (BOOL)isExistWithNet;
//包含以上两种
- (BOOL) isExist;



//单例--下载管理
+ (downLoadNews *) sharedLoadManager;


@end
