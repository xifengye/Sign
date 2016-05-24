//
//  EndController.m
//  Sign
//
//  Created by yexifeng on 16/5/23.
//  Copyright © 2016年 yexifeng. All rights reserved.
//

#import "EndController.h"
#import "UIImage+MG.h"

#import "WelcomeController.h"

@implementation EndController
-(void)viewDidLoad{
    [super viewDidLoad];
    UIImageView* bgView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    [bgView setImage:[UIImage imageNamed:@"over.jpg"]];
    [self.view addSubview:bgView];
    
    CGFloat btnWidth = 250;
    
    UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width-btnWidth)/2, self.view.frame.size.height*0.7, btnWidth, 80)];
    UIImage* normal2 = [UIImage imageWithStretchable:@"action_sheet_button_confirm_normal"];
    UIImage* press2 = [UIImage imageWithStretchable:@"action_sheet_button_confirm_click"];
    UIFont* btnFont = [UIFont fontWithName:@"Helvetica-Bold"  size:(50.0)];
    btn.font = btnFont;
    [btn setBackgroundImage:normal2 forState:UIControlStateNormal];
    [btn setBackgroundImage:press2 forState:UIControlStateHighlighted];
    [btn setTitle:@"知道了" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(delayMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
   }

-(void)delayMethod{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"OVER_ME" object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}



@end
