//
//  Employee.h
//  BirthdayLottey
//
//  Created by yexifeng on 16/4/21.
//  Copyright © 2016年 moregood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelBase.h"

@interface Employee : ModelBase{
    NSString* pinyin;
}
@property(nonatomic,copy)NSString* phone;//电话
@property(nonatomic,copy)NSString* name;//姓名
@property(nonatomic,copy)NSString* company;//公司
@property(nonatomic,copy)NSString* sex;
@property(nonatomic,copy)NSString* PID;//身份证号码
@property(nonatomic,assign)BOOL tourism;
@property(nonatomic,assign)BOOL sign;

-(NSUInteger)signValue;
-(NSUInteger)tourismValue;
-(NSString*)pinyin;
-(void)setPinyin:(NSString*)pinyin;

-(NSString*)toDictString;


-(instancetype)initWithParam:(NSString*)phone name:(NSString*)name sex:(NSString*)sex company:(NSString*)company;

+(instancetype)employeeWithParam:(NSString*)phone name:(NSString*)name sex:(NSString*)sex company:(NSString*)company;

@end
