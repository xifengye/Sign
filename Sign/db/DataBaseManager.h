//
//  DataBaseTool.h
//  Lottey
//
//  Created by yexifeng on 15/12/30.
//  Copyright © 2015年 moregood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

#import "Employee.h"

#define TableEmployee   @"employees"

#define log false


@interface DataBaseManager : NSObject{
   BOOL isMonthBirthday;
    int monthOfBirthday;
    int dayOfBirthday;
}

+(instancetype)sharedManager;


@property(nonatomic,strong)FMDatabase* dataBase;
//@property(nonatomic,assign)BOOL isMonthBirthday;
//@property(nonatomic,assign)int monthOfBirthday;
//@property(nonatomic,assign)int dayOfBirthday;

-(Employee*) employee:(Employee*)emp;
@property(nonatomic,strong)NSMutableArray* employees;
@property(nonatomic,strong)NSMutableArray* employeesGroup;
@property(nonatomic,strong)NSMutableArray* employeesGroupPinyin;
@property NSArray<NSString*>* deptNames;

-(NSUInteger)insertEmployee:(Employee*)employee;
-(BOOL)updateEmployee:(Employee*)employee;
-(void)insertEmployees:(NSArray<Employee*>*)employees;
-(BOOL)deleteEmployee:(Employee *)employee;
-(BOOL)deleteEmployeeByIndex:(int)index;
-(void)clearEmployee;
- (BOOL) dropTable:(NSString *)tableName;
- (BOOL) deleteTable:(NSString *)tableName;
-(void)resetAppDataBase;

-(void)joinRemoteSignEmployees:(NSArray *)ems;

-(NSArray*)joinRemoteBaseEmployees:(NSArray *)ems;

-(NSArray*)employeesBySigned;

@end
