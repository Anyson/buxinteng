//
//  ANYMusicLRCView.h
//  buxinteng
//
//  Created by Anyson Chan on 15/11/19.
//  Copyright © 2015年 Anyson Chan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ANYMusicLRCView : UIView

- (void)resetLRC;
- (void)reloadLRC:(NSString *)lrc;
- (void)reloadLRCWithPath:(NSString *)path;
- (BOOL)canBeginLrc:(float)playbackTime;
- (void)beganLrc:(float)playbackTime;
- (void)pauseLrc;
- (void)continueLrc;

@end
