//
//  PlayListManager.m
//  buxinteng
//
//  Created by Anyson Chan on 15/11/19.
//  Copyright © 2015年 Anyson Chan. All rights reserved.
//

#import "PlayListManager.h"

#define DATA_URL_PATH @"http://7xoear.com1.z0.glb.clouddn.com/play_list.plist"

#define LOVE_TRACKS_FILE_NAME @"love_tracks_list.plist"
#define HATE_TRACKS_FILE_NAME @"hate_tracks_list.plist"

@interface PlayListManager () {
    dispatch_queue_t _fileQueue;
}

@property(nonatomic, strong) NSMutableArray *playList;
@property(nonatomic, strong) NSMutableArray *lovePlayList;

@property(nonatomic, strong) NSMutableArray *loveTracksList;
@property(nonatomic, strong) NSMutableArray *hateTracksList;

@property(nonatomic, strong) NSString *loveFilePath;
@property(nonatomic, strong) NSString *hateFilePath;

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
        
        _fileQueue = dispatch_queue_create("file handle Queue", DISPATCH_QUEUE_SERIAL);
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        _loveFilePath = [[paths objectAtIndex:0]
                           stringByAppendingPathComponent:LOVE_TRACKS_FILE_NAME];
        _hateFilePath = [[paths objectAtIndex:0]
                           stringByAppendingPathComponent:HATE_TRACKS_FILE_NAME];
    }
    return self;
}

- (void)loadData {
    if ([[NSFileManager defaultManager] fileExistsAtPath:_loveFilePath]) {
        _loveTracksList = [NSMutableArray arrayWithContentsOfFile:_loveFilePath];
    } else {
        _loveTracksList = [NSMutableArray array];
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:_hateFilePath]) {
        _hateTracksList = [NSMutableArray arrayWithContentsOfFile:_hateFilePath];
    } else {
        _hateTracksList = [NSMutableArray array];
    }
    
    NSArray *array = [NSArray arrayWithContentsOfURL:[NSURL URLWithString:DATA_URL_PATH]];
    if (array == nil || [array count] <= 0) {
        array = [NSArray arrayWithContentsOfURL:[NSURL URLWithString:DATA_URL_PATH]];
    }
    _playList = [NSMutableArray array];
    PlayListItem *item;
    for (NSDictionary *dict in array) {
        if ([_hateTracksList containsObject:[dict objectForKey:@"tracks"]]) {
            continue;
        }
        item = [PlayListItem playlistItemWithTracks:[dict objectForKey:@"tracks"]
                                                lrc:[dict objectForKey:@"lrc"]];
        if ([_loveTracksList containsObject:item.tracks]) {
            item.isLiked = YES;
        }
        [_playList addObject:item];
    }
}

- (PlayListItem *)getRandomItem {
    if (_playList.count <= 0) {
        return nil;
    }
    int index = arc4random() % _playList.count;
    return [_playList objectAtIndex:index];
}

- (NSString *)getLrcText:(PlayListItem *)item {
    if (item.lrcText && ![item.lrcText isEqualToString:@""]) {
        return item.lrcText;
    }
    NSError *error;
    NSString *lrcText = [[NSString alloc] initWithContentsOfURL:[item lrcUrl] encoding:NSUTF8StringEncoding error:&error];
    [item resetLrcText:lrcText];
    
    if (error) {
        NSData *data = [NSData dataWithContentsOfURL:item.lrcUrl];
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        lrcText = [[NSString alloc] initWithData:data encoding:enc];
        [item resetLrcText:lrcText];

    }
    return lrcText;
}

- (BOOL)isPlayListEmpty {
    if (_playList && _playList.count > 0) {
        return NO;
    }
    
    return YES;
}

- (void)like:(PlayListItem *)item {
    item.isLiked = YES;
    if (![_loveTracksList containsObject:item.tracks]) {
        [_loveTracksList addObject:item.tracks];
        dispatch_async(_fileQueue, ^{
           [_loveTracksList writeToFile:_loveFilePath
                              atomically:YES];
        });
    }
}

- (void)dislike:(PlayListItem *)item {
    item.isLiked = NO;
    if ([_loveTracksList containsObject:item.tracks]) {
        [_loveTracksList removeObject:item.tracks];
        dispatch_async(_fileQueue, ^{
            [_loveTracksList writeToFile:_loveFilePath
                              atomically:YES];
        });
    }
}

- (void)hate:(PlayListItem *) item {
    if ([_playList containsObject:item]) {
        [_playList removeObject:item];
        if (![_hateTracksList containsObject:item.tracks]) {
            [_hateTracksList addObject:item.tracks];
            dispatch_async(_fileQueue, ^{
                [_hateTracksList writeToFile:_hateFilePath
                                  atomically:YES];
            });
        }
    }
}

@end
