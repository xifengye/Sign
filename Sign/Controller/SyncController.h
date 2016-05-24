//
//  SyncController.h
//  Sign
//
//  Created by yexifeng on 16/5/23.
//  Copyright © 2016年 yexifeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncUdpSocket.h"
#import "IPAddress.h"


//每次同步基本信息人数的个数
#define numberOfOnceSync    20

@interface SyncController : UITableViewController{
    NSString* myIP;
    NSMutableArray* remoteEmployees;
    NSUInteger currentSyncIndex;//当前同步到第几个
}
@property(nonatomic,strong)AsyncUdpSocket* udpSocket;

@end
