//
//  MGMeCellView.h
//  SinaWeibo
//
//  Created by yexifeng on 15/11/30.
//  Copyright © 2015年 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Employee.h"
#define CELL_HEIGHT 100
@interface MGSignCellView : UITableViewCell
@property(nonatomic,strong)Employee* employee;

@property(nonatomic,weak)UIButton* signView;
@property(nonatomic,weak)UIButton* tourismView;
@property(nonatomic,weak)UILabel* nameLabel;
@end
