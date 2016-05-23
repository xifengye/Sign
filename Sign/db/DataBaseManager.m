//
//  DataBaseTool.m
//  Lottey
//
//  Created by yexifeng on 15/12/30.
//  Copyright © 2015年 moregood. All rights reserved.
//

#import "DataBaseManager.h"
#import "ModelBase.h"


#define dataBaseName @"lottey.sqlite"

#define dataBasePath [[(NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)) lastObject]stringByAppendingPathComponent:dataBaseName]





@implementation DataBaseManager

#pragma mark DataBaseManager

-(id)init {
    if (self = [super init]) {
        _dataBase = [FMDatabase databaseWithPath:dataBasePath];
    }
    return self;
}



+(id)sharedManager {
    
    static DataBaseManager*sharedMyManager = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        sharedMyManager = [[self alloc] init];
        [sharedMyManager createTables];
        [sharedMyManager initData];
        
    });
    
    return sharedMyManager;
}

#pragma mark 初始化创建表


-(void)initEmployeeGroup{
    _employeesGroup = [NSMutableArray array];
    _employeesGroupPinyin = [NSMutableArray array];
    NSMutableArray *group = [NSMutableArray array];
    NSString* currentPinyin;
    for(Employee* e in _employees){
        NSString *pinyin = [e.pinyin substringToIndex:1];
        //不同
        if(![currentPinyin isEqualToString:pinyin])
        {
            group = [NSMutableArray array];
            [group  addObject:e];
            [_employeesGroup addObject:group];
            [_employeesGroupPinyin addObject:pinyin];
            currentPinyin = pinyin;
        }else//相同
        {
            [group  addObject:e];
        }

    }
}

//创建表
-(BOOL)createTable:(NSString*)sqlCreateTable{
    BOOL result = false;
    if ([self.dataBase open]) {
        
        BOOL res = [self.dataBase executeUpdate:sqlCreateTable];
        if (!res) {
            NSLog(@"error when creating db table");
            result = false;
        } else {
            NSLog(@"success to creating db table");
            result = true;
        }
        [self.dataBase close];
    }
    return result;
}


//创建所有用到的表
-(void)createTables{
//            [self dropTable:TableEmployee];
    
    NSString *employeesSqlCreateTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT, '%@' TEXT,'%@' TEXT, '%@' TEXT, '%@' TEXT,'%@' INTEGER, '%@' INTEGER)",TableEmployee,@"ID",@"name",@"sex",@"phone",@"company",@"PID",@"sign",@"tourism"];
        [self createTable:employeesSqlCreateTable];//员工表
   }


#pragma mark 初始化数据
-(void)initData{
    
    //[self deleteTable:TableEmployee];
    self.employees = [NSMutableArray arrayWithArray:[self queryEmployees]];
    [self initEmployeeGroup];
    if(self.employees.count<=0){
        NSError * error =[NSError alloc];
        NSString *textFileContents = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"employees" ofType:@"txt"] encoding:NSUTF8StringEncoding error: & error];
        
        NSArray* items = [textFileContents componentsSeparatedByString:@"\n"];
        NSArray* ems = [self parseEmployeeFromText:items];
        [self insertEmployees:ems];
    }
}


-(NSArray<Employee*>*) parseEmployeeFromText:(NSArray*)text{
    NSMutableArray<Employee*>* es = [NSMutableArray array];
    for(int i=0;i<text.count;i++){
        NSString* employeeText = text[i];
        NSArray* items = [employeeText componentsSeparatedByString:@","];
        if(items.count<5){
            continue;
        }
        NSString* name=items[0];
        NSString* sex = items[1];
        NSString* phone = items[2];
        NSString* company = items[3];
        Employee* employee = [Employee employeeWithParam:phone name:name sex:sex company:company];
        [es addObject:employee];
    }
    return es;
}



#pragma mark - 员工 employee

//插入一个员工
-(NSUInteger)insertEmployee:(Employee*)employee{
    NSUInteger ID = [self insert:TableEmployee value:employee];
    if(ID>0){
        [self.employees addObject:employee];
        NSArray<Employee*>* ems = [self sortEmployees:self.employees];
        [self.employees removeAllObjects];
        [self.employees addObjectsFromArray:ems];
        [self initEmployeeGroup];
    }
    return ID;
}


//插入一群员工
-(void)insertEmployees:(NSArray<Employee*>*)employees{
    [self inserts:TableEmployee value:employees];
    [self.employees addObjectsFromArray:[self sortEmployees:employees]];
    [self initEmployeeGroup];
}

-(NSArray<Employee*>*)sortEmployees:(NSArray<Employee*>*)employees{
    NSComparator cmptr = ^(Employee* obj1, Employee* obj2){
        NSString* name1Pinyin = nil;
        NSString* name2Pinyin = nil;
        if ([obj1.name length]) {
            NSMutableString *ms = [[NSMutableString alloc] initWithString:obj1.name];
            if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO)) {
                name1Pinyin = ms;
            }
        }
        
        if ([obj2.name length]) {
            NSMutableString *ms = [[NSMutableString alloc] initWithString:obj2.name];
            if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO)) {
                name2Pinyin = ms;
            }
        }
        NSComparisonResult ret = [name1Pinyin compare:name2Pinyin options:NSNumericSearch];
        return ret;
    };
    return [employees sortedArrayUsingComparator:cmptr];
}

-(BOOL)updateEmployee:(Employee *)employee{
    if([self.dataBase open]){
        NSString *updateSql = [NSString stringWithFormat:@"UPDATE '%@' SET name='%@',sex='%@',phone='%@',company='%@',PID='%@',sign=%d, tourism=%d WHERE ID='%d'", TableEmployee,employee.name,employee.sex,employee.phone,employee.company,employee.PID,[employee signValue],[employee tourismValue],employee.ID];
        BOOL res = [self.dataBase executeUpdate:updateSql];
        [self.dataBase close];
        return res;
    }
    
    return false;

}


//所有员工
-(NSArray*) queryEmployees{
    NSMutableArray* employees = [NSMutableArray array];
    NSMutableArray<NSString*>*deptname = [NSMutableArray array];
    if ([self.dataBase open]) {
        FMResultSet *rs = [self.dataBase executeQuery:[NSString stringWithFormat:@"SELECT ID,phone,name,sex,company FROM %@ ORDER BY phone ASC",TableEmployee]];
        while ([rs next]) {
            int ID = [rs intForColumn:@"ID"];
            NSString *name = [rs stringForColumn:@"name"];
            NSString *phone = [rs stringForColumn:@"phone"];
            NSString* company = [rs stringForColumn:@"company"];
            NSString* sex = [rs stringForColumn:@"sex"];
            NSString* PID = [rs stringForColumn:@"PID"];
            BOOL sign = [rs intForColumn:@"sign"];
            BOOL tourism = [rs intForColumn:@"tourism"];
            Employee* employee = [Employee employeeWithParam:phone name:name sex:sex company:company];
            employee.PID = PID;
            employee.ID = ID;
            employee.sign = sign;
            employee.tourism = tourism;
            [employees addObject:employee];
        }
        
        [rs close];
    }
    self.deptNames = deptname;
    return [self sortEmployees:employees];
}


-(void)joinRemoteEmployees:(NSArray *)ems{
    NSMutableArray* array = [NSMutableArray array];
    for(Employee* e in ems){
        Employee* newEmployee = [self asyncRemoteEmployee:e];
        if(newEmployee!=nil){
            [array addObject:newEmployee];
        }
    }
    if(array.count>0){
        [self insertEmployees:array];
    }
}

-(Employee*)asyncRemoteEmployee:(Employee*)e{
    Employee*emp = [self employee:e];
    if(emp==nil){//远程新添加的
        return e;
    }else{
        if(e.sign){
            emp.sign = true;
            emp.tourism = e.tourism;
        }
        return nil;
    }
}

-(NSArray *)employeesBySigned{
    NSMutableArray* array = [NSMutableArray array];
    for(Employee* e in _employees){
        if(e.sign){
            [array addObject:e];
        }
    }
    return array;
}

//根据ID查员工
-(Employee*) employee:(Employee*)emp{
    //    Employee* e = nil;
    for(Employee* e in self.employees){
        if([e.phone isEqualToString:emp.phone] && [e.name isEqualToString:emp.name]){
            return e;
        }
    }
    
    return nil;
}
//删除员工
-(BOOL)deleteEmployee:(Employee *)employee{
    BOOL res = [self deleteByID:TableEmployee ID:employee.ID];
    if(res){
        [self removeEmployee:employee];
    }
    return res;
}


-(BOOL)deleteEmployeeByIndex:(int)index{
    if(index>= self.employees.count){
        return false;
    }
    Employee* e = self.employees[index];
    return [self deleteEmployee:e];
}



//从内存中删除员工
-(void)removeEmployee:(Employee*)employee{
    for(Employee* e in self.employees){
        if(e.phone == employee.phone){
            [self.employees removeObject:e];
            [self initEmployeeGroup];
            break;
        }
    }
}

//删除所有员工
-(void)clearEmployee{
    [self deleteTable:TableEmployee];
    [self.employees removeAllObjects];
}

//根据模式创建插入数据,key-value
-(NSString*)createInsertSqlWithObj:(NSString*)tableName value:(ModelBase*)value{
    NSArray* propertys = [value filterPropertys];
    NSMutableString* insertSql = [NSMutableString stringWithString:[NSString stringWithFormat:@"INSERT INTO %@ (",tableName]];
    for(int i=0;i<propertys.count;i++){
        NSString* property = propertys[i];
        if(![property isEqualToString:@"ID"]){
            [insertSql appendString:[NSString stringWithFormat:@"%@,",property]];
        }
        if(i==propertys.count-1){
            [insertSql deleteCharactersInRange:NSMakeRange(insertSql.length-1, 1)];
            [insertSql appendString:@") VALUES ("];
        }
    }
    NSDictionary* kv = [value toDictionary];
    for(int i=0;i<propertys.count;i++){
        NSString* property = propertys[i];
        if(![property isEqualToString:@"ID"]){
            
            [insertSql appendString:[NSString stringWithFormat:@"'%@',",kv[[NSString stringWithFormat:@"_%@",property]]]];
        }
        if(i==propertys.count-1){
            [insertSql deleteCharactersInRange:NSMakeRange(insertSql.length-1, 1)];
            [insertSql appendString:@")"];
        }
    }
    return insertSql;
}

#pragma mark 插入

//插入一个模型对象到数据库
-(NSUInteger)insert:(NSString*)tableName value:(ModelBase*)value{
    NSUInteger ID = 0;
    if ([self.dataBase open]) {
        NSString* insertSql = [self createInsertSqlWithObj:tableName value:value];
//        NSLog(@"插入语句:%@",insertSql);
        BOOL res = [self.dataBase executeUpdate:insertSql];
        if (!res) {
            NSLog(@"error when insert db table");
        } else {
            ID = self.dataBase.lastInsertRowId;
            value.ID = ID;
            NSLog(@"success to insert db table");
        }
        [self.dataBase close];
    }
    
    return ID;
}

//批量插入模型数据
-(void)inserts:(NSString*)tableName value:(NSArray<ModelBase*>*)values{
    if ([self.dataBase open]) {
        for(int i=0;i<values.count;i++){
            NSUInteger ID = 0;
            ModelBase* value = values[i];
            NSString* insertSql = [self createInsertSqlWithObj:tableName value:value];
//            NSLog(@"插入语句:%@",insertSql);
            BOOL res = [self.dataBase executeUpdate:insertSql];
            
            if (!res) {
                NSLog(@"error when insert db table");
            } else {
                ID = self.dataBase.lastInsertRowId;
                value.ID = ID;
//                NSLog(@"success to insert db table");
            }
        }
        [self.dataBase close];
    }
}

#pragma mark 移除表

// 删除表
- (BOOL) dropTable:(NSString *)tableName
{
    if([self.dataBase open]){
        NSString *sqlstr = [NSString stringWithFormat:@"DROP TABLE %@", tableName];
        if (![self.dataBase executeUpdate:sqlstr])
        {
            NSLog(@"Delete table error!");
            return NO;
        }
        return YES;
    }
    return NO;
}

#pragma mark 清除表数据

//删除某表数据根据ID
-(BOOL)deleteByID:(NSString *)tableName ID:(NSUInteger)ID{
    if([self.dataBase open]){
        NSString *sqlstr = [NSString stringWithFormat:@"DELETE FROM %@ WHERE ID=%d", tableName,ID];
        if (![self.dataBase executeUpdate:sqlstr])
        {
            NSLog(@"Erase table error!");
            return NO;
        }
        return YES;
    }
    return NO;
    
    return false;
}


// 清除表
- (BOOL) deleteTable:(NSString *)tableName
{
    if([self.dataBase open]){
        NSString *sqlstr = [NSString stringWithFormat:@"DELETE FROM %@", tableName];
        if (![self.dataBase executeUpdate:sqlstr])
        {
            NSLog(@"Erase table error!");
            return NO;
        }
        return YES;
    }
    return NO;
}





-(void)resetAppDataBase{
    [self dropTable:TableEmployee];
    [self createTables];
    [self.employees removeAllObjects];
    
}


@end
