//
//  TodayBirthdayViewController.m
//  BirthdayLottey
//
//  Created by yexifeng on 16/4/22.
//  Copyright © 2016年 moregood. All rights reserved.
//

#import "SignViewController.h"
#import "DataBaseManager.h"
#import "MGHeaderView.h"
#import "MGSignCellView.h"
#import "FirstViewController.h"


#define kAlphaNum   @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

@interface SignViewController ()

//@property NSMutableArray<Employee*>* todayBirthdayEmployees;

@end

@implementation SignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        self.navigationController.navigationBarHidden = YES;
    [self initView];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didEmployeeDelete:)
                                                 name:@"employee_change" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(overMe:) name:@"OVER_ME" object:nil];
}


-(void)overMe:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)dealloc{
    NSLog(@"SignedviewController dealloc");
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


-(void)initView{
    CGFloat headerViewHeight=  80;
     MGHeaderView* headerView = [[MGHeaderView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, headerViewHeight)];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onTextFieldValueChange:) name:UITextFieldTextDidChangeNotification object:headerView.searchTextLabel];
    headerView.searchTextLabel.delegate = self;
    
    [self.view addSubview:headerView];
    self.headerView = headerView;
    UITableView* tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, headerViewHeight+5, self.view.frame.size.width, self.view.frame.size.height-headerViewHeight-48-30)];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UISearchReslutView* searchResultView = [[UISearchReslutView alloc]initWithFrame:self.tableView.frame];
    self.searchResultView = searchResultView;
    self.searchResultView.tableView.delegate = self;
    self.searchResultView.tableView.dataSource = self;
    [self.view addSubview:searchResultView];
    searchResultView.hidden = YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSCharacterSet *cs;
    
    cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum] invertedSet];
    
    
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
    
    
    
    BOOL canChange = [string isEqualToString:filtered];
    
    
    
    return canChange;
}

-(void)onTextFieldValueChange:(NSNotification*)notification{
    UITextField *textField = notification.object;
    keyWord = [textField.text uppercaseString];
    if(keyWord!=nil && keyWord.length>0){
        [self showSearchResult];
    }else{
        [self hideSearchResult];
    }
    
}

-(void)showSearchResult{
    self.searchResultView.hidden = NO;
    searchResultEmployees = [NSMutableArray array];
    for(Employee* e in [DataBaseManager sharedManager].employees){
        if([e.pinyin hasPrefix:keyWord]|| [e.phone hasPrefix:keyWord]){
            [searchResultEmployees addObject:e];
        }
    }
    [self.searchResultView.tableView reloadData];
}

-(void)hideSearchResult{
    searchResultEmployees = nil;
    self.searchResultView.hidden = YES;
    [self.tableView reloadData];
}


-(void)didEmployeeDelete:(id)sender{
    [self.tableView reloadData];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - UITableViewDataSource

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.searchResultView.hidden?[DataBaseManager sharedManager].employeesGroupPinyin:nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *key = [[DataBaseManager sharedManager].employeesGroupPinyin objectAtIndex:section];
    return self.searchResultView.hidden?key:nil;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.searchResultView.hidden?[[DataBaseManager sharedManager].employeesGroupPinyin count]:1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.searchResultView.hidden?[[[DataBaseManager sharedManager].employeesGroup objectAtIndex:section] count]:searchResultEmployees.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Employee* e;
    if(!self.searchResultView.hidden){
        e = searchResultEmployees[indexPath.row];
    }else{
        e =[[[DataBaseManager sharedManager].employeesGroup objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    }
    static NSString *CellIdentifier = @"Cell";
    MGSignCellView *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[MGSignCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    

    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.employee = e;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CELL_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return index;
}

#pragma mark -
#pragma mark - UITableViewDelegate
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(!self.searchResultView.hidden){
        return nil;
    }
    UIView* header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    header.backgroundColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.4];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 20)];
    lab.textAlignment = NSTextAlignmentLeft;
    lab.font = [UIFont systemFontOfSize:20];
    lab.text = [[DataBaseManager sharedManager].employeesGroupPinyin objectAtIndex:section];
    lab.textColor = [UIColor whiteColor];
    [header addSubview:lab];
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Employee* e;
    if(self.searchResultView.hidden==YES){
        e =[[[DataBaseManager sharedManager].employeesGroup objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    }else{
        e = searchResultEmployees[indexPath.row];
    }
    FirstViewController* controller = [[FirstViewController alloc]init];
    controller.employee = e;
    
    UINavigationController* navController = [[UINavigationController alloc]initWithRootViewController:controller];
    [self presentViewController:navController animated:true completion:nil];
    
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
         Employee* e =[[[DataBaseManager sharedManager].employeesGroup objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
        [[DataBaseManager sharedManager] deleteEmployee:e];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"employee_change" object:nil];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}




@end
