//
//  Employee.m
//  BirthdayLottey
//
//  Created by yexifeng on 16/4/21.
//  Copyright © 2016年 moregood. All rights reserved.
//

#import "Employee.h"
#import "pinyin.h"

@implementation Employee

-(instancetype)initWithParam:(NSString *)phone name:(NSString *)name sex:(NSString*)sex company:(NSString *)company{
    self = [super init];
    if(self){
        self.phone = phone;
        self.name = name;
        self.sex = sex;
        self.company = company;
    }
    return self;
}

+(instancetype)employeeWithParam:(NSString *)phone name:(NSString *)name sex:(NSString*)sex company:(NSString *)company{
    Employee* e = [[Employee alloc] initWithParam:phone name:name sex:sex company:company];
    return e;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ %@  %@ %@", self.name,_phone,_sign?@"已签到":@"未签到",_tourism?@"参加":@""];
}

-(void)setName:(NSString *)name{
    _name = name;
    pinyin = [self chineseToPinyin:name];
}

-(NSString*)chineseToPinyin:(NSString*)chineseString{
    if(![chineseString isEqualToString:@""]){
        NSString *pinYinResult = [NSString string];
        for(int j=0;j<chineseString.length;j++){
            NSString *singlePinyinLetter = [[NSString stringWithFormat:@"%c",
                                             
                                             pinyinFirstLetter([chineseString characterAtIndex:j])]uppercaseString];
            
            pinYinResult = [pinYinResult stringByAppendingString:singlePinyinLetter];
        }
        return pinYinResult;
    }else{
        return @"";
    }
}

-(NSUInteger)signValue{
    return _sign?1:0;
}

-(NSUInteger)tourismValue{
    return _tourism?1:0;
}


-(NSString *)pinyin{
    return pinyin;
}
-(void)setPinyin:(NSString *)py{
    pinyin = py;
}

-(NSString *)toDictString{
    NSMutableString* sb = [NSMutableString string];
    [sb appendString:[NSString stringWithFormat:@"{\"phone\":\"%@\",",self.phone]];
    [sb appendString:[NSString stringWithFormat:@"\"name\":\"%@\",",self.name]];
    [sb appendString:[NSString stringWithFormat:@"\"company\":\"%@\",",_company]];
    [sb appendString:[NSString stringWithFormat:@"\"PID\":\"%@\",",self.PID]];
    [sb appendString:[NSString stringWithFormat:@"\"sign\":%hhd,",_sign]];
    [sb appendString:[NSString stringWithFormat:@"\"tourism\":%hhd}",_tourism]];
    return sb;
}

-(NSString *)PID{
   return _PID==nil?@"":_PID;
}
-(NSString *)phone{
    return _phone==nil?@"":_phone;
}


-(BOOL)needSyncBaseInfo:(Employee *)e{
    if(e==nil){
        return true;
    }
    return !([e.name isEqualToString:self.name] && [e.phone isEqualToString:self.phone] && [e.company isEqualToString:self.company]);
}


@end
