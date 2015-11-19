//
//  ANYPlayer.m
//  buxinteng
//
//  Created by Anyson Chan on 15/11/17.
//  Copyright © 2015年 Anyson Chan. All rights reserved.
//

#import "ANYPlayer.h"
@import AVFoundation;

#import "ANYAudioSessionHandler.h"

@interface ANYPlayer () {
//    dispatch_queue_t _enumerationQueue;
    
    CGFloat _totalTime;
}

@property(nonatomic, strong) AVPlayer *player;
@property(nonatomic, strong) id        playbackTimeObserver;

@end

@implementation ANYPlayer

- (instancetype)init
{
    self = [super init];
    if (self) {
//        _enumerationQueue = dispatch_queue_create("Browser Enumeration Queue", DISPATCH_QUEUE_SERIAL);
//        dispatch_set_target_queue(_enumerationQueue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0));
        
        [ANYAudioSessionHandler sharedInstance];
        _player = [[AVQueuePlayer alloc] init];
    
    }
    return self;
}

- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [[self.player currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}

- (void)monitoringPlayback:(AVPlayerItem *)playerItem {
    [self.player removeTimeObserver:self.playbackTimeObserver];
    __weak ANYPlayer *wself = self;
    self.playbackTimeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(5, 250) queue:NULL usingBlock:^(CMTime time) {
        CGFloat currentSecond = (float) time.value / time.timescale;//playerItem.currentTime.value / playerItem.currentTime.timescale;
        CGFloat totalSecond = playerItem.duration.value / playerItem.duration.timescale;
        if ([wself.delegate respondsToSelector:@selector(player:updatePlaybackTime:duration:)]) {
            [wself.delegate player:wself updatePlaybackTime:currentSecond duration:totalSecond];
        }
    }];
}

- (void)removePlayerItemObserVer:(AVPlayerItem *) playerItem {
    [playerItem removeObserver:self
                    forKeyPath:@"status"
                       context:nil];
    [playerItem removeObserver:self
                    forKeyPath:@"loadedTimeRanges"
                       context:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:AVPlayerItemDidPlayToEndTimeNotification
                                                  object:playerItem];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:AVPlayerItemFailedToPlayToEndTimeNotification
                                                  object:playerItem];
}

#pragma mark - Public method
- (void)loadPlayerItem:(NSURL *)url {
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
    [playerItem addObserver:self forKeyPath:@"status"
                    options:NSKeyValueObservingOptionNew
                    context:nil];
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges"
                    options:NSKeyValueObservingOptionNew
                    context:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:playerItem];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemFailedToPlayToEndTime:)
                                                 name:AVPlayerItemFailedToPlayToEndTimeNotification
                                               object:playerItem];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([_player currentItem]) {
            [self removeAllObserver];
        }
        [_player replaceCurrentItemWithPlayerItem:playerItem];
    });
}

- (void)play {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.player play];
    });
}

- (void)pause {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.player pause];
    });
}

- (void)removeAllObserver {
    [self removePlayerItemObserVer:[_player currentItem]];
}

- (BOOL)isPlaying {
    if (self.player.rate == 1.0) {
        return YES;
    }
    return NO;
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context {
    
     AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        
        switch (status) {
            case AVPlayerItemStatusUnknown:
            {
                 NSLog_DEBUG(@"Player item status unknown");
            }
                break;
                
            case AVPlayerItemStatusReadyToPlay:
            {
                 NSLog_DEBUG(@"Player item status readyToPlay");
                CGFloat totalSecond = playerItem.duration.value / playerItem.duration.timescale;// 转换成秒
                [self monitoringPlayback:playerItem];// 监听播放状态
                NSMutableDictionary *metaDict = [NSMutableDictionary dictionary];
                for (AVMetadataItem *item in playerItem.asset.commonMetadata) {
                    [metaDict setObject:item.value forKey:item.commonKey];
                }
                
                [metaDict setObject:@(totalSecond) forKey:kDuration];
                if ([self.delegate respondsToSelector:@selector(player:readyToPlay:)]) {
                    [self.delegate player:self
                              readyToPlay:metaDict];
                }
            }
                break;
                
            case AVPlayerItemStatusFailed:
            {
                AVPlayerItem *thePlayerItem = (AVPlayerItem *) object;
                 NSLog_DEBUG(@"AVPlayerStatusFailed... %@, %@", thePlayerItem, thePlayerItem.error);
                [thePlayerItem removeObserver:self
                                   forKeyPath:@"status"
                                      context:nil];
                [thePlayerItem removeObserver:self
                                   forKeyPath:@"loadedTimeRanges"
                                      context:nil];
                
                if ([self.delegate respondsToSelector:@selector(player:failedToPlay:)]) {
                    [self.delegate player:self
                             failedToPlay:thePlayerItem.error];
                }
            }
                break;
        }

    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSTimeInterval timeInterval = [self availableDuration];// 计算缓冲进度
        CMTime duration = playerItem.duration;
        CGFloat totalDuration = CMTimeGetSeconds(duration);
        if ([self.delegate respondsToSelector:@selector(player:loadedTimeRanges:duration:)]) {
            [self.delegate player:self
                 loadedTimeRanges:timeInterval
                         duration:totalDuration];
        }
    } else if ([keyPath isEqualToString:@"tracks"]) {
        NSLog_DEBUG(@"tracks");
    }
}

#pragma mark - notification action
- (void)playerItemDidReachEnd:(NSNotification *)notification {
    NSLog_DEBUG(@"playerItemDidReachEnd");
    AVPlayerItem *playerItem = notification.object;
    [self removePlayerItemObserVer:playerItem];
    [self.player replaceCurrentItemWithPlayerItem:nil];
    
    if ([self.delegate respondsToSelector:@selector(playerDidPlayToEndTime:)]) {
        [self.delegate playerDidPlayToEndTime:self];
    }
}

- (void)playerItemFailedToPlayToEndTime:(NSNotification *)notification {
    NSLog_DEBUG(@"playerItemFailedToPlayToEndTime");
    AVPlayerItem *playerItem = notification.object;
    [self removePlayerItemObserVer:playerItem];
    
    if ([self.delegate respondsToSelector:@selector(playerFailedToPlayToEndTime:)]) {
        [self.delegate playerFailedToPlayToEndTime:self];
    }
}

@end
