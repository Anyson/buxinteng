//
//  NetworkMonitor.m
//  buxinteng
//
//  Created by Anyson Chan on 15/11/20.
//  Copyright © 2015年 Anyson Chan. All rights reserved.
//

#import "NetworkMonitor.h"
#import "Reachability.h"

@interface NetworkMonitor () {
    BOOL _isStart;
    BOOL _isFisrt;
}

@end

@implementation NetworkMonitor

+ (NetworkMonitor *)shardInstance {
    static NetworkMonitor *monitor = nil;
    static dispatch_once_t t;
    dispatch_once(&t, ^{
        monitor = [[NetworkMonitor alloc] init];
    });
    
    return monitor;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isStart = NO;
        _isFisrt = YES;
    }
    return self;
}

- (void)start {
    if (_isStart) {
        return;
    }
    _isStart = YES;
    // Allocate a reachability object
    Reachability* reach = [Reachability reachabilityWithHostname:@"http://7xoear.com1.z0.glb.clouddn.com"];
    
    // Set the blocks
    reach.reachableBlock = ^(Reachability*reach)
    {
        // keep in mind this is called on a background thread
        // and if you are updating the UI it needs to happen
        // on the main thread, like this:
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog_DEBUG(@"REACHABLE!");
            [[NSNotificationCenter defaultCenter]
             postNotificationName:ANYNetworkResumeNotification
             object:@(_isFisrt)];
            _isFisrt = NO;
        });
    };
    
    reach.unreachableBlock = ^(Reachability*reach)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog_DEBUG(@"UNREACHABLE!");
            [[NSNotificationCenter defaultCenter]
             postNotificationName:ANYNetworkInterruptionNotification
             object:@(_isFisrt)];
            _isFisrt = NO;
        });
    };
    
    // Start the notifier, which will cause the reachability object to retain itself!
    [reach startNotifier];
}
@end
