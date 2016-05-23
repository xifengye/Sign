//
//  WelcomeController.m
//  Sign
//
//  Created by yexifeng on 16/5/22.
//  Copyright © 2016年 yexifeng. All rights reserved.
//

#import "WelcomeController.h"
#import "MainTabViewController.h"

@implementation WelcomeController
-(void)viewDidLoad{
    [super viewDidLoad];
    UIImageView* bgView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    [bgView setImage:[UIImage imageNamed:@"welcome.jpg"]];
    [self.view addSubview:bgView];
    
    UIImage* btnImg = [UIImage imageNamed:@"btnSign"];
    UIButton* btnGo = [[UIButton alloc]initWithFrame:self.view.bounds];
    [btnGo setBackgroundImage:btnImg forState:UIControlStateNormal];

    [self.view addSubview:btnGo];
    self.btnGo = btnGo;
    [btnGo addTarget:self action:@selector(onGo) forControlEvents:UIControlEventTouchUpInside];
}

-(void)onGo{
    UIViewController* controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"mainController"];
    [self presentViewController:controller animated:true completion:nil];
    
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}

@end
