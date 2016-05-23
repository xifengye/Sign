//
//  EndController.m
//  Sign
//
//  Created by yexifeng on 16/5/23.
//  Copyright © 2016年 yexifeng. All rights reserved.
//

#import "EndController.h"

#import "WelcomeController.h"

@implementation EndController
-(void)viewDidLoad{
    [super viewDidLoad];
    UIImageView* bgView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    [bgView setImage:[UIImage imageNamed:@"over.jpg"]];
    [self.view addSubview:bgView];
    
    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:3.0f];
   }

-(void)delayMethod{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"OVER_ME" object:nil];
    [self dismissViewControllerAnimated:NO completion:nil];
    
}


-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}



@end
