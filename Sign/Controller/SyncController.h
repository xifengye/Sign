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

@interface SyncController : UITableViewController{
    NSString* myIP;
    NSMutableArray* remoteEmployees;
}
@property(nonatomic,strong)AsyncUdpSocket* udpSocket;

@end
