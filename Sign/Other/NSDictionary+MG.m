//
//  NSDictionary+MG.m
//  Sign
//
//  Created by yexifeng on 16/5/23.
//  Copyright © 2016年 yexifeng. All rights reserved.
//

#import "NSDictionary+MG.h"

@implementation NSDictionary (MG)
/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+(NSArray*)arrayWithJsonString:(NSString*)jsonString{
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSMutableArray *tableArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return tableArray;
}
@end
