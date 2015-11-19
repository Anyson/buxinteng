//
//  PlayListItem.m
//  buxinteng
//
//  Created by Anyson Chan on 15/11/20.
//  Copyright © 2015年 Anyson Chan. All rights reserved.
//

#import "PlayListItem.h"

@implementation PlayListItem

+ (PlayListItem *)playlistItemWithTracks:(NSString *)tracks lrc:(NSString *)lrc{
    PlayListItem *item = [[PlayListItem alloc] initWithTracks:tracks
                                                          lrc:lrc];
    
    return item;
}

- (instancetype)initWithTracks:(NSString *)tracks lrc:(NSString *)lrc
{
    self = [super init];
    if (self) {
        _tracks = tracks;
        _lrc = lrc;
        [self config];
    }
    return self;
}

- (void)config {
    _tracksUrl = [NSURL URLWithString:[_tracks stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    _lrcUrl = [NSURL URLWithString:[_lrc stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    _lrcText = @"";
    _isLiked = NO;
    _isDeleted = NO;
}

- (void)resetLrcText:(NSString *)lrcText {
    _lrcText = lrcText;
}

@end
