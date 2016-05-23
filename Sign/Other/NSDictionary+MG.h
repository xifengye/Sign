//
//  NSDictionary+MG.h
//  Sign
//
//  Created by yexifeng on 16/5/23.
//  Copyright © 2016年 yexifeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (MG)
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
+(NSArray*)arrayWithJsonString:(NSString*)jsonString;
@end
