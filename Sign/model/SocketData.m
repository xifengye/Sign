//
//  SocketData.m
//  Sign
//
//  Created by yexifeng on 16/5/23.
//  Copyright © 2016年 yexifeng. All rights reserved.
//

#import "SocketData.h"


@implementation SocketData

-(instancetype)initWithParam:(NSString *)ip employees:(NSArray *)ems{
    self = [super init];
    if(self){
        self.fromIp = ip;
        self.data = [self parse:ems];
    }
    return self;
}

-(NSString*)parse:(NSArray*)ems{
    NSMutableString* sb = [NSMutableString stringWithString:@"["];
    int i=0;
    for(Employee* e in ems){
        [sb appendString:[e toDictString]];
        if(++i<ems.count){
            [sb appendString:@","];
        }
    }
    [sb appendString:@"]"];
    return sb;
}

-(NSString*)toDictString{
    NSMutableString* sb = [NSMutableString string];
    [sb appendString:[NSString stringWithFormat:@"%@^",_fromIp]];
    [sb appendString:_data];
    return sb;
}

@end
