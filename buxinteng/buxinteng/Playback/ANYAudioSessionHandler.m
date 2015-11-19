//
//  ANYAudioSessionHandler.m
//  buxinteng
//
//  Created by Anyson Chan on 15/11/19.
//  Copyright © 2015年 Anyson Chan. All rights reserved.
//

#import "ANYAudioSessionHandler.h"
@import AVFoundation;

@interface ANYAudioSessionHandler ()

@end

@implementation ANYAudioSessionHandler

+ (ANYAudioSessionHandler *)sharedInstance {
    static ANYAudioSessionHandler *handler = nil;
    static dispatch_once_t t;
    dispatch_once(&t, ^{
        handler = [[ANYAudioSessionHandler alloc] init];
    });
    
    return handler;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self resetAudioSessionCategory];
        [self registerNotications];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:AVAudioSessionInterruptionTypeKey
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:AVAudioSessionRouteChangeNotification
                                                  object:nil];
}

- (void)resetAudioSessionCategory {
    NSError *sessionError = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&sessionError];
}

- (void)registerNotications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(audioSessionInterruption:)
                                                 name:AVAudioSessionInterruptionNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(audioSessionRouteChange:)
                                                 name:AVAudioSessionRouteChangeNotification
                                               object:nil];
}

- (void)audioSessionInterruption:(NSNotification *)notification {
    NSLog_DEBUG(@"[0002]%@", notification.userInfo);
    NSInteger interruptionFlag = [[[notification userInfo] objectForKey:AVAudioSessionInterruptionTypeKey] integerValue];
    
    if (interruptionFlag) {
        //中断了
        [[NSNotificationCenter defaultCenter] postNotificationName:ANYPlaybackInterruptionNotification
                                                            object:nil];
    } else {
        //中断结束
        NSInteger optionFlag = (int)[[[notification userInfo] objectForKey:AVAudioSessionInterruptionOptionKey] integerValue];
        if (optionFlag) {
            //可恢复原来状态
            [[NSNotificationCenter defaultCenter] postNotificationName:ANYPlaybackResumeNotification
                                                                object:nil];
            [self resetAudioSessionCategory];
        }
    }
}

- (void)audioSessionRouteChange:(NSNotification *)notification {
    NSLog_DEBUG(@"[0001]%@", notification.userInfo);
    NSDictionary *userInfo = notification.userInfo;
    NSInteger routeChangeReason = [[userInfo valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    if (routeChangeReason == AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
        //耳机拔出
        [[NSNotificationCenter defaultCenter] postNotificationName:ANYPlaybackInterruptionNotification
                                                            object:nil];
    }
}

@end
