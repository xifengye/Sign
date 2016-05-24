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
    NSUInteger addMode;
}
@property (strong, nonatomic) Employee* detailItem;

@property (weak, nonatomic) IBOutlet UIView* panel;

@property (weak, nonatomic) IBOutlet UITextField* tfName;
@property (weak, nonatomic) IBOutlet UITextField* tfPhone;
@property (weak, nonatomic) IBOutlet UITextField* tfCompany;
@property (weak, nonatomic) IBOutlet UITextField* tfPID;

- (void)willAdd;

@end

