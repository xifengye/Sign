//
//  UISearchReslutView.m
//  Sign
//
//  Created by yexifeng on 16/5/22.
//  Copyright © 2016年 yexifeng. All rights reserved.
//

#import "UISearchReslutView.h"

@implementation UISearchReslutView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = [UIColor whiteColor];
        UIView* uiView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 40)];
        [self addSubview:uiView];
        UILabel* tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, frame.size.width-10, 40)];
        uiView.backgroundColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.4];
        tipLabel.text = @"搜索结果:";
        self.tipLabel = tipLabel;
        [uiView addSubview:tipLabel];
        
        UITableView* tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, frame.size.width, frame.size.height-40)];
        self.tableView = tableView;
        [self addSubview:tableView];
    }
    return self;
}
@end
