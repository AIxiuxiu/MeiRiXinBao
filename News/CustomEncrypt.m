//
//  CustomEncrypt.m
//  MedicineHall
//
//  Created by ink on 14/11/21.
//  Copyright (c) 2014年 ink. All rights reserved.
//

#import "CustomEncrypt.h"
#define kEncryptKey @"zhonghua"
@implementation CustomEncrypt

+ (NSString *)jiamiWithString:(NSString *)string{
    NSArray *strArray = [string componentsSeparatedByString:@"&"];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    for (NSString *stringWithEqual in strArray) {
        NSArray *array = [stringWithEqual componentsSeparatedByString:@"="];
        NSString *key = [array objectAtIndex:0];
        NSString *value = [array objectAtIndex:1];
        [dic setObject:value forKey:key];
    }
   return [CustomEncrypt jiamiWithDictionary:dic];
}
+ (NSDictionary *)stringToDictionary:(NSString *)string {
    NSArray *strArray = [string componentsSeparatedByString:@"&"];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    for (NSString *stringWithEqual in strArray) {
        NSArray *array = [stringWithEqual componentsSeparatedByString:@"="];
        NSString *key = [array objectAtIndex:0];
        NSString *value = [array objectAtIndex:1];
        [dic setObject:value forKey:key];
    }
    return dic;
}

+(NSString *)jiamiWithDictionary:(NSDictionary *)dict {
    NSString *result;
    //先按照参数名作排序
    NSArray *keys = [dict allKeys];
    keys = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *key1 = (NSString *)obj1;
        NSString *key2 = (NSString *)obj2;
        return [key1 compare:key2];
    }];
    //通过key的排序把value组合成字符串，拼接秘钥，进行MD5加密
    NSMutableArray *values = [[NSMutableArray alloc] init];
    for (int i = 0; i<keys.count; i++) {
        NSString *key = [keys objectAtIndex:i];
        NSString *value = [dict objectForKey:key];
        [values addObject:value];
    }
    result = [values componentsJoinedByString:@""];
    result = [result stringByAppendingString:kEncryptKey];
    result = [result MD5Hash];
    return result;
}

+ (NSString *) jiamiWithDate:(NSString *)dateStr {
    NSString *result;
    result = [dateStr stringByAppendingString:kEncryptKey];
    result = [result MD5Hash];
    return result;
}
@end
