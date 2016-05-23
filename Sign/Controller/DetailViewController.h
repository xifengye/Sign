//
//  DetailViewController.h
//  BirthdayLottey
//
//  Created by yexifeng on 16/4/21.
//  Copyright © 2016年 moregood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Employee.h"

@interface DetailViewController : UIViewController{
    BOOL addMode;
}

@property (strong, nonatomic) Employee* detailItem;
@property (weak, nonatomic) IBOutlet UILabel  *labelName;
@property (weak, nonatomic) IBOutlet UILabel  *labelPhone;
@property (weak, nonatomic) IBOutlet UILabel  *labelCompany;
@property (weak, nonatomic) IBOutlet UILabel  *labelPID;



@property(weak,nonatomic) IBOutlet UIView* addPanel;
@property(weak,nonatomic) IBOutlet UIView* detailPanel;

@property (weak, nonatomic) IBOutlet UITextField* tfName;
@property (weak, nonatomic) IBOutlet UITextField* tfPhone;
@property (weak, nonatomic) IBOutlet UITextField* tfCompany;


-(void)showAddEmployeePanel;

@end

