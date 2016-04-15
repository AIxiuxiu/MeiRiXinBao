//
//  CustomEncrypt.h
//  MedicineHall
//
//  Created by ink on 14/11/21.
//  Copyright (c) 2014年 ink. All rights reserved.
//


/*
 方法一：
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"5" forKey:@"uid"];
    [dic setObject:@"测试文本" forKey:@"title"];
    [dic setObject:@"20141114" forKey:@"time"];
    [dic setObject:@"3" forKey:@"p"];
    NSLog(@"%@",[CustomEncrypt jiamiWithDictionary:dic]);
 方法二：
    NSLog(@"%@",[CustomEncrypt jiamiWithString:@"uid=5&title=测试文本&time=20141114&p=3"]);
 */

/*
 主要加密过程：
    1.先按照“参数名”作排序
    2.通过“参数名”的排序把“参数”组合成字符串
    3.将上面的字符串拼接“秘钥”
    4.进行MD5加密
    5.返回结果
 */


#import <Foundation/Foundation.h>
#import "MD5/NSString+Hashing.h"
@interface CustomEncrypt : NSObject
+ (NSDictionary *)stringToDictionary:(NSString *)string;
+ (NSString *) jiamiWithString:(NSString *)string;
+ (NSString *) jiamiWithDictionary:(NSDictionary *)dict;
+ (NSString *) jiamiWithDate:(NSString *)dateStr;
@end
