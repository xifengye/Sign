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
            
        // Update the view.
        [self initDetailPanel];
    }
}

- (void)initDetailPanel {
    // Update the user interface for the detail item.
    self.addPanel.hidden = YES;
    self.detailPanel.hidden = NO;
    
    if (self.detailItem) {
        self.navigationItem.title = self.detailItem.name;
        self.labelName.text = [NSString stringWithFormat:@"姓名:\t%@",self.detailItem.name];
        self.labelPhone.text = [NSString stringWithFormat:@"电话:\t%@",self.detailItem.phone];
        self.labelCompany.text = [NSString stringWithFormat:@"公司:\t%@",self.detailItem.company];
        self.labelPID.text = [NSString stringWithFormat:@"身份证号:\t%@",self.detailItem.PID==nil?@"":self.detailItem.PID];
    }
}

-(void)dealloc{
    NSLog(@"DetailViewControll dealloc");
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if(addMode){
        [self initAddEmployeeUI];
    }else{
        [self initDetailPanel];
    }
}

- (void)insertNewEmployee:(id)sender {
    
    
    NSString* name = self.tfName.text;
    if(name==nil || name.length<=0){
        return;
    }
    NSString* phone = self.tfPhone.text;
    if(phone==nil || phone.length<=0){
        return;
    }
    
   
    Employee* employee = [Employee employeeWithParam:phone name:name sex:@"" company:self.tfCompany.text];
    [[DataBaseManager sharedManager]insertEmployee:employee];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"employee_change" object:nil];
    self.navigationItem.rightBarButtonItem = nil;
    self.addPanel.hidden = YES;
}

-(void)showAddEmployeePanel{
    addMode = true;
    
}

-(void)initAddEmployeeUI{
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(insertNewEmployee:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.addPanel.hidden = NO;
    self.detailPanel.hidden = YES;
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
