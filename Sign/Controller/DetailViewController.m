//
//  DetailViewController.m
//  BirthdayLottey
//
//  Created by yexifeng on 16/4/21.
//  Copyright © 2016年 moregood. All rights reserved.
//

#import "DetailViewController.h"
#import "DataBaseManager.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        addMode = 1;
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"完成更新" style:UIBarButtonItemStyleDone target:self action:@selector(insertNewEmployee:)];
        self.navigationItem.rightBarButtonItem = addButton;
    }
}


-(void)willAdd{
    addMode = 2;
}

- (void)resetValue {
    self.panel.hidden = NO;
    _detailItem = nil;
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"完成新增" style:UIBarButtonItemStyleDone target:self action:@selector(insertNewEmployee:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.navigationItem.title = @"添加新数据";
    self.tfName.text = @"";
    self.tfPhone.text = @"";
    self.tfCompany.text = @"";
    self.tfPID.text = @"";

}

-(void)invokeValue{
    if (self.detailItem) {
        self.panel.hidden = NO;
        self.navigationItem.title = self.detailItem.name;
        self.tfName.text = self.detailItem.name;
        self.tfPhone.text = self.detailItem.phone;
        self.tfCompany.text = self.detailItem.company;
        self.tfPID.text = self.detailItem.PID;
    }

}

-(void)dealloc{
    NSLog(@"DetailViewControll dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if(addMode==2){
        [self resetValue];
    }else if(addMode == 1){
        [self invokeValue];
    }else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"复制数据" style:UIBarButtonItemStyleDone target:self action:@selector(copyData)];
    }
}

-(void)copyData{
    NSMutableString* sb = [NSMutableString string];
    for(Employee* e in [DataBaseManager sharedManager].employees){
        if(e.sign && e.tourism){
            [sb appendFormat:@"姓名:%@\t电话:%@\t身份证号码:%@\n",e.name,e.phone,e.PID];
        }
    }
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = sb;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"复制成功"
                                                    message:sb
                                                   delegate:self
                                          cancelButtonTitle:@"关闭" otherButtonTitles:nil];
    [alert show];
    
}


- (void)insertNewEmployee:(id)sender {
    
    
    NSString* name = self.tfName.text;
    if(name==nil || name.length<=0){
        return;
    }
    NSString* phone = self.tfPhone.text;
//    if(phone==nil || phone.length<=0){
//        return;
//    }
//    
    if(_detailItem==nil){
        _detailItem = [[Employee alloc]init];
    }
    _detailItem.name = name;
    _detailItem.phone = phone;
    _detailItem.company = self.tfCompany.text;
    _detailItem.PID = self.tfPID.text;

    if(_detailItem.ID==0){
        BOOL result = [[DataBaseManager sharedManager]insertEmployee:_detailItem];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:[NSString stringWithFormat:result?@"新增 %@ 成功!":@"新增 %@ 失败!",_detailItem.name]
                                                       delegate:self
                                              cancelButtonTitle:@"关闭" otherButtonTitles:nil];
        [alert show];

    }else{
        BOOL result = [[DataBaseManager sharedManager]updateEmployee:_detailItem];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:[NSString stringWithFormat:result?@"更新 %@ 成功!":@"更新 %@ 失败!",_detailItem.name]
                                                       delegate:self
                                              cancelButtonTitle:@"关闭" otherButtonTitles:nil];
        [alert show];

    }
    addMode = YES;
    [self resetValue];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"employee_change" object:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
