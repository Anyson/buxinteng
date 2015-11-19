//
//  PlayListItem.h
//  buxinteng
//
//  Created by Anyson Chan on 15/11/20.
//  Copyright © 2015年 Anyson Chan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayListItem : NSObject

@property(nonatomic, strong, readonly) NSString *tracks;//
@property(nonatomic, strong, readonly) NSString *lrc;

@property(nonatomic, strong, readonly) NSURL    *tracksUrl;
@property(nonatomic, strong, readonly) NSURL    *lrcUrl;
@property(nonatomic, strong, readonly) NSString *lrcText;

@property(nonatomic, assign) BOOL isLiked;
@property(nonatomic, assign) BOOL isDeleted;

+ (PlayListItem *)playlistItemWithTracks:(NSString *)tracks lrc:(NSString *)lrc;
- (instancetype)initWithTracks:(NSString *)tracks lrc:(NSString *)lrc;
- (void)resetLrcText:(NSString *)lrcText;

@end
