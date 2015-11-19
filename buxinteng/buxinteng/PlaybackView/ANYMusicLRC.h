//
//  ANYMusicLRC.h
//  buxinteng
//
//  Created by Anyson Chan on 15/11/19.
//  Copyright © 2015年 Anyson Chan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ANYMusicLRCItem : NSObject

@property(nonatomic, assign) float     time;
@property(nonatomic, strong) NSString *lrcStr;

@end

@interface ANYMusicLRC : NSObject

@property (strong , nonatomic) NSMutableArray *lrcList;

- (ANYMusicLRC *)initWithLRCFile:(NSString*)path;

- (void)reloadWithLRC:(NSString *)lrc;
- (void)reloadWithLRCFile:(NSString*)path;

@end
