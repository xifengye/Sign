//
//  SyncController.m
//  Sign
//
//  Created by yexifeng on 16/5/23.
//  Copyright © 2016年 yexifeng. All rights reserved.
//

#import "SyncController.h"
#import "SocketData.h"
#import "DataBaseManager.h"
#import "NSDictionary+MG.h"
#import "MGSignCellView.h"
#import <AdSupport/AdSupport.h>



@implementation SyncController
-(void)viewDidLoad{
    NSLog(@"SyncController viewDidLoad");
    remoteEmployees = [NSMutableArray array];
    [super viewDidLoad];
    
    [self setupNavBar];
    myIP  = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];;
    NSLog(@"myIp--->%@",myIP);

    [self openUDPServer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(overMe:) name:@"OVER_ME" object:nil];
}


-(void)overMe:(id)sender{
    [_udpSocket close];
    _udpSocket = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)dealloc{
    NSLog(@"SyncController dealloc");
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}



-(void)setupNavBar{
    self.title = @"数据同步";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送同步数据" style:UIBarButtonItemStyleDone target:self action:@selector(sendData)];
    self.navigationItem.title = self.title;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"复制数据" style:UIBarButtonItemStyleDone target:self action:@selector(copyData)];
    
}

-(void)copyData{
    NSMutableString* sb = [NSMutableString string];
    for(Employee* e in [DataBaseManager sharedManager].employees){
        if(e.sign && e.tourism){
            [sb appendFormat:@"姓名:%@\t电话:%@\t身份证号码:%@\n",e.name,e.phone,e.PID];
        }
    }
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = sb;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"复制成功"
                                                    message:sb
                                                   delegate:self
                                          cancelButtonTitle:@"关闭" otherButtonTitles:nil];
    [alert show];

}

-(void)sendData{
    NSArray* arr = [[DataBaseManager sharedManager] employeesBySigned];
    if(arr.count>0){
        SocketData* socketData = [[SocketData alloc]initWithParam:myIP employees:arr];
        NSString* data = [socketData toDictString];
        [self sendMassage:data];
    }
}




//建立基于UDP的Socket连接
-(void)openUDPServer{
    //初始化udp
    AsyncUdpSocket *tempSocket=[[AsyncUdpSocket alloc] initWithDelegate:self];
    _udpSocket=tempSocket;
    //绑定端口
    NSError *error = nil;
    [_udpSocket bindToPort:4333 error:&error];
    
    //发送广播设置
    [_udpSocket enableBroadcast:YES error:&error];
    
    //加入群里，能接收到群里其他客户端的消息
    [_udpSocket joinMulticastGroup:@"224.0.0.2" error:&error];
    
   	//启动接收线程
    [_udpSocket receiveWithTimeout:-1 tag:0];
    
}


//通过UDP,发送消息
-(void)sendMassage:(NSString *)message
{
    
    NSDate *nowTime = [NSDate date];
    
    NSMutableString *sendString=[NSMutableString stringWithCapacity:100];
    [sendString appendString:message];
    //开始发送
    BOOL res = [_udpSocket sendData:[sendString dataUsingEncoding:NSUTF8StringEncoding]
                                 toHost:@"224.0.0.2"
                                   port:4333
                            withTimeout:-1
                
                                    tag:0];
    
    
   	if (!res) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"发送失败"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}


#pragma mark UDP Delegate Methods
- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port
{
    
    [_udpSocket receiveWithTimeout:-1 tag:0];
    NSLog(@"host---->%@",host);
    
    
   	//接收到数据回调，用泡泡VIEW显示出来
    
    NSString *info=[[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
    NSArray* arr = [info componentsSeparatedByString:@"^"];
    NSString* ip = arr[0];
    NSString* employeesStr = arr[1];
    NSArray* array = [NSDictionary arrayWithJsonString:employeesStr];
    NSArray* employees = [Employee objectArrayWithKeyValuesArray:array];
    SocketData* socketData = [[SocketData alloc]initWithParam:ip employees:employees];
    //收到自己发的广播时不显示出来
    if ([socketData.fromIp isEqualToString:myIP])
    {
        return YES;
    }
    [self onReceiveRemoteEmployees:employees];
    return YES;
}

-(void)onReceiveRemoteEmployees:(NSArray*)res{
    [[DataBaseManager sharedManager]joinRemoteEmployees:res];
    [remoteEmployees removeAllObjects];
    [remoteEmployees addObjectsFromArray:res];
    [self.tableView reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"employee_change" object:nil];
}


- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    //无法发送时,返回的异常提示信息
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:[error description]
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:nil];
    [alert show];
    
}
- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error
{
    //无法接收时，返回异常提示信息
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:[error description]
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:nil];
    [alert show];
}



#pragma mark - UITableViewDataSource



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  remoteEmployees.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Employee* e = remoteEmployees[indexPath.row];
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



@end
