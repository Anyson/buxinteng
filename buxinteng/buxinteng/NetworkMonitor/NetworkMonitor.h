//
//  NetworkMonitor.h
//  buxinteng
//
//  Created by Anyson Chan on 15/11/20.
//  Copyright © 2015年 Anyson Chan. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const ANYNetworkInterruptionNotification  =  @"ANYNetworkInterruptionNotification";
static NSString *const ANYNetworkResumeNotification        =  @"ANYNetworkResumeNotification";

@interface NetworkMonitor : NSObject

+ (NetworkMonitor *)shardInstance;

- (void)start;

@end
