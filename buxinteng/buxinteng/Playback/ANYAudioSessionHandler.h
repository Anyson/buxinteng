//
//  ANYAudioSessionHandler.h
//  buxinteng
//
//  Created by Anyson Chan on 15/11/19.
//  Copyright © 2015年 Anyson Chan. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const ANYPlaybackInterruptionNotification  =  @"ANYPlaybackInterruptionNotification";
static NSString *const ANYPlaybackResumeNotification        =  @"ANYPlaybackResumeNotification";

@interface ANYAudioSessionHandler : NSObject

+ (ANYAudioSessionHandler *)sharedInstance;

@end
