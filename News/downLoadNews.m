//
//  downLoadNews.m
//  News
//
//  Created by ink on 15/2/25.
//  Copyright (c) 2015年 ink. All rights reserved.
//

#import "downLoadNews.h"
#import "Reachability.h"
@implementation downLoadNews
- (instancetype)init {
    if (self = [super init]) {
        self.fileManager = [NSFileManager defaultManager];
        NSString *imagePath = [NSString stringWithFormat:@"%@/Library/imgs",NSHomeDirectory()];
        [self.fileManager createDirectoryAtPath:imagePath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    return self;
}

//判断文件是否存在并且有没有过期
//一个小时自动删除
//@param
//@return:yes,存在并且没有过期..no,不存在或者过期了（过期自动删除）
//yes就是有。。no就是没有
- (BOOL)isExistWithNet{
    BOOL isExist = [self.fileManager fileExistsAtPath:NewsLoadPath];
    if (isExist) {
        NSDate *nowDate = [NSDate date];
        NSDictionary *fileDic = [self.fileManager attributesOfItemAtPath:NewsLoadPath error:nil];
        NSDate *creationDate = [fileDic objectForKey:NSFileCreationDate];
        NSInteger time = [nowDate timeIntervalSinceDate:creationDate];
        if (time>1200) {//20分钟就过期了1200
            [self.fileManager removeItemAtPath:NewsLoadPath error:nil];
            return NO;
        }else {
            return YES;
        }
    }else {
        return NO;
    }
}
//没有网络就不用判断是否过期。。有就有，没有就没有
- (BOOL)isExistWithOutNet {
    BOOL isExist = [self.fileManager fileExistsAtPath:NewsLoadPath];
    if (isExist) {
        return YES;
    }
    return NO;
}
//单例
+ (downLoadNews *)sharedLoadManager {
    static downLoadNews *loadManger;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loadManger = [[downLoadNews alloc] init];
    });
    return loadManger;
}
//保存
- (void)saveWithArray:(NSArray *)array {
    if (![self isExistWithNet]) {
        if ([NSKeyedArchiver archiveRootObject:array toFile:NewsLoadPath]) {
            NSLog(@"---保存成功---");
        }else {
            NSLog(@"---保存失败---");
        }
        //后期加上下载图片
        NSMutableArray *muArray = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in array) {
            NSString *str = [NSString stringWithFormat:@"%@",[dic objectForKey:@"banner"]];
            NSString *str2 = [NSString stringWithFormat:@"%@",[dic objectForKey:@"info"]];
            
            if (![str isEqualToString:@""]) {
                NSArray *a = [dic objectForKey:@"banner"];
                for (NSDictionary *dd in a) {
                    NSString *string = [dd objectForKey:@"picture"];
                    if (![string isEqualToString:@""]) {
                        [muArray addObject:string];
                    }
                }
            }
            if (![str2 isEqualToString:@""]&&![str2 isEqualToString:@"<null>"]) {
                NSArray *b = [dic objectForKey:@"info"];
                for (NSDictionary *dd in b) {
                    NSString *string = [dd objectForKey:@"illustrated"];
                    if (![string isEqualToString:@""]) {
                        [muArray addObject:string];
                    }
                    id content = [dd objectForKey:@"content"];
                    if ([content isKindOfClass:[NSArray class]]) {
                        NSArray *c = (NSArray *)content;
                        for (NSDictionary *cc in c) {
                            NSString *stt = [cc objectForKey:@"picture"];
                            if (![stt isEqualToString:@""]) {
                                [muArray addObject:stt];
                            }
                        }
                    }
                }
            }
            
            
        }
        for (int i=0; i<muArray.count; i++) {
            NSString *str = [muArray objectAtIndex:i];
            [self savePicWithUrlStr:str];
            NSString *string = [NSString stringWithFormat:@"%.2f",i+1/(float)muArray.count];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"freshAlertMsg" object:string];
//            if (i==muArray.count-1) {
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"finishDown" object:string];
//            }
        }
    }
}
//取出
- (NSArray *)getOutWithFile {
    if ([self isExist]) {
        NSArray *array = [NSArray arrayWithContentsOfFile:NewsLoadPath];
        return array;
    }else {
        return nil;
    }
}
//判断是否存在，分为有网络和没有网络两种情况
- (BOOL) isExist {
    Reachability *r = [Reachability reachabilityForInternetConnection];
    [r startNotifier];
    if (r.currentReachabilityStatus == NotReachable) {
        return [self isExistWithOutNet];
    }else {
        return [self isExistWithNet];
    }
}

/**
 * 保存图片
 */
- (void)savePicWithUrlStr:(NSString *)picStr {
    NSURL *url = [NSURL URLWithString:picStr];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSArray *arr = [picStr componentsSeparatedByString:@"/"];
    NSString *lastName = [arr lastObject];
    NSArray *aa = [lastName componentsSeparatedByString:@"."];
    lastName = [aa firstObject];
    NSString *imgName = [NSString stringWithFormat:@"%@/Library/imgs/%@",NSHomeDirectory(),lastName];
    [data writeToFile:imgName atomically:NO];
}

//+ (NSString *)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName{
//    NSData* imageData;
//    //判断图片是不是png格式的文件
//    if (UIImagePNGRepresentation(tempImage)) {
//        //返回为png图像。
//        imageData = UIImagePNGRepresentation(tempImage);
//    }else {
//        //返回为JPEG图像。
//        imageData = UIImageJPEGRepresentation(tempImage, 1.0);
//    }
//    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
//    
//    NSString* documentsDirectory = [paths objectAtIndex:0];
//    
//    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
//    
//    NSArray *nameAry=[fullPathToFile componentsSeparatedByString:@"/"];
//    NSLog(@"===fullPathToFile===%@",fullPathToFile);
//    NSLog(@"===FileName===%@",[nameAry objectAtIndex:[nameAry count]-1]);
//    
//    [imageData writeToFile:fullPathToFile atomically:NO];
//    return fullPathToFile;
//}
@end
