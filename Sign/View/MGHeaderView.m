//
//  MGHeaderView.m
//  Sign
//
//  Created by yexifeng on 16/5/22.
//  Copyright © 2016年 yexifeng. All rights reserved.
//

#import "MGHeaderView.h"

@implementation MGHeaderView


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.4];
        CGFloat margin = 5;
        UITextField* tf = [[UITextField alloc]initWithFrame:CGRectMake(margin, margin, frame.size.width-margin*2, frame.size.height-margin*5)];
        tf.backgroundColor = [UIColor whiteColor];
        tf.placeholder = @"输入首字母查找";
        tf.font = [UIFont fontWithName:@"Helvetica-Bold"  size:(30.0)];
        [tf setTextAlignment:NSTextAlignmentCenter];
        self.searchTextLabel = tf;
        tf.keyboardType = UIKeyboardTypeNamePhonePad;
        tf.borderStyle = UITextBorderStyleRoundedRect;
        [self addSubview:_searchTextLabel];
    }
    return self;
}

@end
