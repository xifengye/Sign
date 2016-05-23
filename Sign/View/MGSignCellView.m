//
//  MGMeCellView.m
//  SinaWeibo
//
//  Created by yexifeng on 15/11/30.
//  Copyright © 2015年 moregood. All rights reserved.
//

#import "MGSignCellView.h"
#import "UIImage+MG.h"

@implementation MGSignCellView


+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString* ID = @"MeCell";
    MGSignCellView *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell==nil){
        cell = [[MGSignCellView alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        CGFloat btnWidth = 10;
        CGFloat btnMarginTop = 2;
        UIButton* signView = [[UIButton alloc]init];
        signView.frame = CGRectMake(0, btnMarginTop, btnWidth, CELL_HEIGHT-btnMarginTop*2);
        [self addSubview:signView];
        [signView setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.2]] forState:UIControlStateNormal];
        [signView setBackgroundImage:[UIImage createImageWithColor:[UIColor orangeColor]] forState:UIControlStateSelected];
        self.signView = signView;
        
        UIButton* tourismView = [[UIButton alloc]init];
        tourismView.frame = CGRectMake(btnWidth, btnMarginTop, btnWidth, CELL_HEIGHT-btnMarginTop*2);
        [self addSubview:tourismView];
        self.tourismView = tourismView;
        [tourismView setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.3]] forState:UIControlStateNormal];
        [tourismView setBackgroundImage:[UIImage createImageWithColor:[UIColor redColor]] forState:UIControlStateSelected];
        
        UILabel* nameLabel = [[UILabel alloc]init];
        [self addSubview:nameLabel];
        self.nameLabel = nameLabel;
        UIFont* nameFont = [UIFont fontWithName:@"Helvetica-Bold"  size:(40.0)];
        nameLabel.font = nameFont;
        nameLabel.frame = CGRectMake(btnWidth*2+100,0,300,CELL_HEIGHT);
        
        UILabel* phoneLabel = [[UILabel alloc]init];
        [self addSubview:phoneLabel];
        self.phoneLabel = phoneLabel;
        UIFont* phoneFont = [UIFont fontWithName:@"Helvetica"  size:(25.0)];
        phoneLabel.font = phoneFont;
        phoneLabel.frame = CGRectMake(CGRectGetMaxX(nameLabel.frame)+20,0,300,CELL_HEIGHT/2);
        
        
        UILabel* companyLabel = [[UILabel alloc]init];
        [self addSubview:companyLabel];
        self.companyLabel = companyLabel;
        companyLabel.font = phoneFont;
        companyLabel.frame = CGRectMake(CGRectGetMaxX(nameLabel.frame)+20,CELL_HEIGHT/2,600,CELL_HEIGHT/2);
    }
    return self;
}

-(void)setEmployee:(Employee *)employee{
    _employee = employee;
    self.nameLabel.text = employee.name;
    self.phoneLabel.text = employee.phone;
    self.signView.selected = employee.sign;
    self.tourismView.selected = employee.tourism;
    self.companyLabel.text = employee.company;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
