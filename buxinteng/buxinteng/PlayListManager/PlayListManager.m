//
//  PlayListManager.m
//  buxinteng
//
//  Created by Anyson Chan on 15/11/19.
//  Copyright © 2015年 Anyson Chan. All rights reserved.
//

#import "PlayListManager.h"

@interface PlayListManager ()

@end

@implementation PlayListManager

+ (PlayListManager *)sharedInstance {
    static PlayListManager *manager = nil;
    static dispatch_once_t t;
    dispatch_once(&t, ^{
        manager = [[PlayListManager alloc] init];
    });
    
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

@end
