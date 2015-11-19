//
//  ANYPlaybackView.h
//  buxinteng
//
//  Created by Anyson Chan on 15/11/17.
//  Copyright © 2015年 Anyson Chan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleProgressView.h"
#import "ANYMusicLRCView.h"

@class ANYPlaybackView;
@protocol ANYPlaybackViewDelegate <NSObject>

- (void)playbackViewPressPlayBtn:(ANYPlaybackView *)playbackView;
- (void)playbackViewPressNextBtn:(ANYPlaybackView *)playbackView;
- (void)playbackViewPressHateBtn:(ANYPlaybackView *)playbackView;
- (void)playbackViewPressLikeBtn:(ANYPlaybackView *)playbackView likeFlag:(BOOL)isLike;

@end

@interface ANYPlaybackView : UIView

@property(nonatomic, weak)   id<ANYPlaybackViewDelegate> delegate;

@property(nonatomic, strong) CircleProgressView *progressView;
@property(nonatomic, strong) UIImageView        *artworkView;
@property(nonatomic, strong) UILabel            *titleLabel;
@property(nonatomic, strong) UILabel            *artistLabel;
@property(nonatomic, strong) UIButton           *playBtn;
@property(nonatomic, strong) UIButton           *nextBtn;
@property(nonatomic, strong) UIButton           *likeBtn;
@property(nonatomic, strong) UIButton           *hateBtn;

@property(nonatomic, strong) ANYMusicLRCView    *lrcView;

- (void)enable:(BOOL)enable;
- (void)interrupt;
- (void)resume;
- (void)playOrPause;

@end
