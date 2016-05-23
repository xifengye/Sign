//
//  TodayBirthdayViewController.h
//  BirthdayLottey
//
//  Created by yexifeng on 16/4/22.
//  Copyright © 2016年 moregood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGHeaderView.h"
#import "UISearchReslutView.h"

@interface SignViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    NSMutableArray* searchResultEmployees;
    NSString* keyWord;
}
@property(nonatomic,weak)UITableView* tableView;
@property(nonatomic,weak)MGHeaderView* headerView;
@property(nonatomic,weak)UISearchReslutView* searchResultView;

@end
