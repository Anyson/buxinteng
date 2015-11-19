//
//  ANYMusicLRC.m
//  buxinteng
//
//  Created by Anyson Chan on 15/11/19.
//  Copyright © 2015年 Anyson Chan. All rights reserved.
//

#import "ANYMusicLRC.h"

@implementation ANYMusicLRCItem

@end

@implementation ANYMusicLRC

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.lrcList= [[NSMutableArray alloc]init];
    }
    return self;
}


- (ANYMusicLRC *)initWithLRCFile:(NSString *)path{
    self = [super init];
    if (self) {
        self.lrcList= [[NSMutableArray alloc]init];
        [self reloadWithLRCFile:path];
    }
    return self;
}

- (void)reloadWithLRC:(NSString *)lrc {
    self.lrcList = [self showLRC:lrc];
}

- (void)reloadWithLRCFile:(NSString *)path {
    [self.lrcList removeAllObjects];
    NSError *error;
    NSString *LRCFileStr = [[NSString alloc]initWithContentsOfFile:path
                                                          encoding:NSUTF8StringEncoding
                                                             error:&error];
    self.lrcList = [self showLRC:LRCFileStr];
    
}

- (NSMutableArray *)showLRC:(NSString*)lrcStr{
    NSMutableArray *rootList = [[NSMutableArray alloc]init];
    NSArray *array = [lrcStr componentsSeparatedByString:@"\n"];
    for (int i = 0; i < array.count; i++) {
        NSString *tempStr = [[array objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([tempStr isEqualToString:@""] ||
            [tempStr containsString:@"[ti:"] ||
            [tempStr containsString:@"[ar:"] ||
            [tempStr containsString:@"[al:"] ||
            [tempStr containsString:@"[by:"]    ) {
            continue;
        }
        NSArray *lineArray = [tempStr componentsSeparatedByString:@"]"];
        for (int j = 0; j < [lineArray count]-1; j ++) {
            NSString *lrcStr = [[lineArray lastObject] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if ([lrcStr isEqualToString:@""]) {
                continue;
            }
            if ([lineArray[j] length] > 8) {
                ANYMusicLRCItem *item = [[ANYMusicLRCItem alloc] init];
                NSString *str1 = [tempStr substringWithRange:NSMakeRange(3, 1)];
                NSString *str2 = [tempStr substringWithRange:NSMakeRange(6, 1)];
                if ([str1 isEqualToString:@":"] && [str2 isEqualToString:@"."]) {
                    NSString *timeStr = [[lineArray objectAtIndex:j] substringWithRange:NSMakeRange(1, 8)];//分割区间求歌词时间
                    //把时间 和 歌词 加入词典
                    NSArray *array = [timeStr componentsSeparatedByString:@":"];//把时间转换成秒
                    NSUInteger time = [array[0] intValue] * 60 + [array[1] intValue];
                    [item setLrcStr:lrcStr] ;
                    [item setTime:time];
                    
                    [rootList addObject:item];
                }
            }
        }
    }
    
    [rootList sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        ANYMusicLRCItem *item1 = obj1;
        ANYMusicLRCItem *item2 = obj2;
        
        if (item1.time < item2.time) {
            return NSOrderedAscending;
        } else if (item1.time > item2.time) {
            return NSOrderedDescending;
        }
        return NSOrderedSame;
        
    }];

    return rootList;
}

@end
