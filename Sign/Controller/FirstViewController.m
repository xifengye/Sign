//
//  FirstViewController.m
//  Sign
//
//  Created by yexifeng on 16/5/21.
//  Copyright © 2016年 yexifeng. All rights reserved.
//

#import "FirstViewController.h"
#import "DataBaseManager.h"
#import "EndController.h"
#import "UIimage+MG.h"

#define kAlphaNum   @"Xx0123456789"
#define INTERVAL_KEYBOARD   40


@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self setupNavBar];
    [self initViews];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(overMe:) name:@"OVER_ME" object:nil];
}


-(void)overMe:(id)sender{
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)dealloc{
    NSLog(@"FirstViewController dealloc");
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initViews{
    UIFont* font = [UIFont fontWithName:@"Helvetica-Bold"  size:(35.0)];
    UIFont* btnFont = [UIFont fontWithName:@"Helvetica-Bold"  size:(50.0)];
    CGSize frameSize = self.view.frame.size;
    UILabel* tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, frameSize.height*0.2,frameSize.width , 100)];
    tipLabel.text = _employee.tourism? @"您已报名参加旅游活动,是否取消?":@"您还未报名参加旅游活动,是否报名参加?";
    tipLabel.textColor = [UIColor blackColor];
    [self.view addSubview:tipLabel];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.font = font;
    
    CGFloat btnWidth = 250;
    CGFloat btnHeight =90;
    CGFloat btnY = CGRectGetMaxY(tipLabel.frame)+100;
    CGFloat btn1X = frameSize.width*0.2;
    UIButton* btn1 = [[UIButton  alloc]initWithFrame:CGRectMake(btn1X,btnY , btnWidth, btnHeight)];
    [self.view addSubview:btn1];
    [btn1 setTitle:_employee.tourism?@"取消报名":@"不报名" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn1.tag = 1;
    btn1.font = btnFont;
    UIImage* normal = [UIImage imageWithStretchable:@"action_sheet_button_delete_normal"];
    UIImage* press = [UIImage imageWithStretchable:@"action_sheet_button_delete_click"];
    [btn1 setBackgroundImage:normal forState:UIControlStateNormal];
    [btn1 setBackgroundImage:press forState:UIControlStateHighlighted];
    [btn1 addTarget:self action:@selector(onBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton* btn2 = [[UIButton  alloc]initWithFrame:CGRectMake(frameSize.width-btn1X-btnWidth, btnY, btnWidth, btnHeight)];
    [self.view addSubview:btn2];
    [btn2 setTitle:_employee.tourism?@"依然报名":@"报名" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn2.tag = 2;
    btn2.font = btnFont;
    UIImage* normal2 = [UIImage imageWithStretchable:@"action_sheet_button_confirm_normal"];
    UIImage* press2 = [UIImage imageWithStretchable:@"action_sheet_button_confirm_click"];
    [btn2 setBackgroundImage:normal2 forState:UIControlStateNormal];
    [btn2 setBackgroundImage:press2 forState:UIControlStateHighlighted];
    [btn2 addTarget:self action:@selector(onBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    CGFloat idWidth = frameSize.width*0.5;
    CGFloat okBtnWidth = 100;
    
    UIView* viewP = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(btn1.frame)+100, frameSize.width, 90)];
    [self.view addSubview:viewP];
    self.idPanel = viewP;
    
    UITextField* tfID = [[UITextField alloc]initWithFrame:CGRectMake((frameSize.width-idWidth-okBtnWidth-20)/2, 0, idWidth, 60)];
    tfID.placeholder = @"请输入身份证号码";
    tfID.textAlignment = NSTextAlignmentCenter;
    self.tfID = tfID;
    [viewP addSubview:tfID];
    self.idPanel.hidden = _employee.PID==nil;
    tfID.text = _employee.PID;
    tfID.delegate = self;
    tfID.font = font;
    tfID.keyboardType = UIKeyboardTypeNumberPad;
    tfID.borderStyle = UITextBorderStyleRoundedRect;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onTextFieldValueChange:) name:UITextFieldTextDidChangeNotification object:tfID];
    
    UIButton* btnOk = [[UIButton  alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tfID.frame)+20, 0, okBtnWidth, 60)];
    [viewP addSubview:btnOk];
    [btnOk setTitle:@"确定" forState:UIControlStateNormal];
    [btnOk setBackgroundImage:normal2 forState:UIControlStateNormal];
    [btnOk setBackgroundImage:press2 forState:UIControlStateHighlighted];
    [btnOk setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnOk.tag = 3;
    btnOk.font = [UIFont fontWithName:@"Helvetica-Bold"  size:(25.0)];
    [btnOk addTarget:self action:@selector(onBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel* idLenLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMinY(tfID.frame)-50 , frameSize.width, 50)];
    [viewP addSubview: idLenLabel];
    self.idLenLabel = idLenLabel;
    idLenLabel.textAlignment = NSTextAlignmentCenter;
    
}

-(void)onTextFieldValueChange:(NSNotification*)notification{
    UITextField *textField = notification.object;
    self.idLenLabel.text = [NSString stringWithFormat:@"已输入 %d 位字符",textField.text.length];
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSCharacterSet *cs;
    
    cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum] invertedSet];
    
    
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
    
    
    
    BOOL canChange = [string isEqualToString:filtered];
    
    
    
    return canChange;
}


-(void)onBtnClicked:(UIButton*)sender{
    _employee.sign = true;
    [[DataBaseManager sharedManager]updateEmployee:_employee];
    if(sender.tag ==1 ){//取消报名
        [self doNotTourism];
    }else if(sender.tag ==2){//报名
        self.idPanel.hidden = NO;
    }else{//确定身份证
        _employee.PID = self.tfID.text;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:_employee.PID
                                                        message:@"请再次确认您输入的身份证号码是否有误!"
                                                       delegate:self
                                              cancelButtonTitle:@"发现有误" otherButtonTitles:@"确认无误",nil];
        [alert show];

    }
}

-(void)doNotTourism{
    _employee.tourism = NO;
    [self goOverController];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1){
        _employee.tourism = YES;
        [self goOverController];
    }
}

-(void)goOverController{
    [[DataBaseManager sharedManager]updateEmployee:_employee];
    EndController* controller = [[EndController alloc]init];
    [self presentViewController:controller animated:YES completion:nil];
}


-(void)setupNavBar{
    self.title = [NSString stringWithFormat:@"欢迎%@",self.employee.name];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(goBack)];
    self.navigationItem.title = self.title;
    
}

-(void)goBack{
    [self dismissViewControllerAnimated:true completion:nil];
}


///键盘显示事件
- (void) keyboardWillShow:(NSNotification *)notification {
    //获取键盘高度，在不同设备上，以及中英文下是不同的
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
    CGFloat offset = (_idPanel.frame.origin.y+_idPanel.frame.size.height+INTERVAL_KEYBOARD) - (self.view.frame.size.height - kbHeight);
    
    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //将视图上移计算好的偏移
    if(offset > 0) {
        [UIView animateWithDuration:duration animations:^{
            self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
}

///键盘消失事件
- (void) keyboardWillHide:(NSNotification *)notify {
    // 键盘动画时间
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
}

@end
