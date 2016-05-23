//
//  MainTabViewController.m
//  BirthdayLottey
//
//  Created by yexifeng on 16/4/21.
//  Copyright © 2016年 moregood. All rights reserved.
//

#import "MainTabViewController.h"
#import "DataBaseManager.h"

@interface MainTabViewController ()

@end

@implementation MainTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(overMe:) name:@"OVER_ME" object:nil];
}


-(void)overMe:(id)sender{
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)dealloc{
    NSLog(@"MainTabViewController dealloc");
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
