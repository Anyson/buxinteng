//
//  ANYPlayer.h
//  buxinteng
//
//  Created by Anyson Chan on 15/11/17.
//  Copyright © 2015年 Anyson Chan. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *kTitle     = @"title";
static NSString *kType      = @"type";
static NSString *kAlbumName = @"albumName";
static NSString *kArtist    = @"artist";
static NSString *kArtwork   = @"artwork";
static NSString *kDuration  = @"duration";

@class ANYPlayer;
@protocol ANYPlayerDelegate <NSObject>

@optional

- (void)player:(ANYPlayer *)player readyToPlay:(NSDictionary *)commonMetaData;
- (void)player:(ANYPlayer *)player loadedTimeRanges:(float)loadedTime duration:(float)duration;
- (void)player:(ANYPlayer *)player updatePlaybackTime:(float)playbackTime duration:(float)duration;
- (void)player:(ANYPlayer *)player failedToPlay:(NSError *)error;
- (void)playerDidPlayToEndTime:(ANYPlayer *)player;
- (void)playerFailedToPlayToEndTime:(ANYPlayer *)player;

@end


@interface ANYPlayer : NSObject

@property(nonatomic, weak) id<ANYPlayerDelegate> delegate;

- (void)loadPlayerItem:(NSURL *)url;

- (void)play;
- (void)pause;
- (void)removeAllObserver;
- (BOOL)isPlaying;

@end
