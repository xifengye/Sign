//
//  SocketData.h
//  Sign
//
//  Created by yexifeng on 16/5/23.
//  Copyright © 2016年 yexifeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Employee.h"
#import "MJExtension.h"

@interface SocketData : NSObject
@property(nonatomic,copy)NSString* fromIp;
@property(nonatomic,copy)id data;

-(instancetype)initWithParam:(NSString*)ip employees:(NSArray*)ems;
-(NSString*)toDictString;

@end
