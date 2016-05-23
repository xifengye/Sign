//
//  FirstViewController.h
//  Sign
//
//  Created by yexifeng on 16/5/21.
//  Copyright © 2016年 yexifeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Employee.h"

@interface FirstViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>

@property(nonatomic,strong)Employee* employee;
@property(nonatomic,weak)UIView* idPanel;
@property(nonatomic,weak)UITextField* tfID;
@property(nonatomic,weak)UILabel* idLenLabel;
@property(nonatomic,weak)UIButton* btnOk;
@end

