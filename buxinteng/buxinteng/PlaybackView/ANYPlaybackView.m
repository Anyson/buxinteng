//
//  ANYPlaybackView.m
//  buxinteng
//
//  Created by Anyson Chan on 15/11/17.
//  Copyright © 2015年 Anyson Chan. All rights reserved.
//

#import "ANYPlaybackView.h"
#import <UIView+SDCAutoLayout.h>
#import "ANYMusicLRCView.h"

@interface ANYPlaybackView ()

@end

@implementation ANYPlaybackView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = [UIColor whiteColor];
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    
    float offsetY = 0;
    float offsetY2 = 0;
    if (IS_IPHONE_4S) {
        offsetY = -45;
        offsetY2 = -20;
    } else if (IS_IPHONE_5) {
        offsetY = -40;
        offsetY2 = -10;
    }
    
    UILabel *appTitleLabel = [Common generateLabelWithText:@"不心疼随心听"
                                             textAlignment:NSTextAlignmentCenter
                                                      font:FONT(30)
                                                 textColor:RGB_PRIMARY];
    [self addSubview:appTitleLabel];
    [appTitleLabel sdc_alignEdgesWithSuperview:UIRectEdgeTop | UIRectEdgeLeft | UIRectEdgeRight
                                        insets:UIEdgeInsetsMake(20, 0, 0, 0)];
    [appTitleLabel sdc_pinHeight:100 + offsetY];
    
    _artworkView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 150) / 2, 130 + offsetY, 150, 150)];
    [_artworkView setImage:IMAGE(@"noArt")];
    _artworkView.layer.cornerRadius = 75.0f;
    _artworkView.layer.masksToBounds = YES;
    [self addSubview:_artworkView];
    
    _progressView = [[CircleProgressView alloc] initWithFrame:CGRectMake(0, 0, 160, 160)];
    _progressView.translatesAutoresizingMaskIntoConstraints = YES;
    _progressView.timeLimit = 60*1;
    _progressView.elapsedTime = 0;
    _progressView.tintColor = RGB_PRIMARY;
    [self addSubview:_progressView];
    
    _progressView.center = _artworkView.center;
    
    _titleLabel = [Common generateLabelWithText:@" "
                                  textAlignment:NSTextAlignmentCenter
                                           font:FONT(25)
                                      textColor:RGBA(0, 0, 0, 0.8)];
    [self addSubview:_titleLabel];
    [_titleLabel sdc_alignEdgesWithSuperview:UIRectEdgeTop | UIRectEdgeLeft | UIRectEdgeRight
                                        insets:UIEdgeInsetsMake(320 + offsetY + offsetY2, 0, 0, 0)];
    
    _artistLabel = [Common generateLabelWithText:@" "
                                   textAlignment:NSTextAlignmentCenter
                                            font:FONT(20)
                                       textColor:RGB_TEXT_COLOR];
    [self addSubview:_artistLabel];
    [_artistLabel sdc_alignEdgesWithSuperview:UIRectEdgeTop | UIRectEdgeLeft | UIRectEdgeRight
                                      insets:UIEdgeInsetsMake(355 + offsetY + offsetY2, 0, 0, 0)];
    
    
    _playBtn = [Common generateButtonWithTarget:self
                                         action:@selector(playBtnAction:)];
    _playBtn.translatesAutoresizingMaskIntoConstraints = YES;
    [_playBtn setImage:IMAGE(@"btn_play")
              forState:UIControlStateNormal];
    [_playBtn setImage:IMAGE(@"btn_play")
               forState:UIControlStateHighlighted];
    [_playBtn setImage:IMAGE(@"btn_transparent")
              forState:UIControlStateSelected];
    [_playBtn setImage:IMAGE(@"btn_transparent")
              forState:UIControlStateDisabled];
    [_playBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    [_playBtn setBounds:CGRectMake(0, 0, 150, 150)];
    [_playBtn setCenter:_artworkView.center];
    _playBtn.layer.cornerRadius = 75.0f;
    _playBtn.layer.masksToBounds = YES;
    [self addSubview:_playBtn];
    
    _nextBtn = [Common generateButtonWithTarget:self
                                         action:@selector(nextBtnAction:)];
    [_nextBtn setImage:IMAGE(@"btn_next")
              forState:UIControlStateNormal];
    [self addSubview:_nextBtn];
    
    [_nextBtn sdc_alignEdgesWithSuperview:UIRectEdgeBottom
                                   insets:UIEdgeInsetsMake(0, 0, -60 - offsetY, 0)];
    [_nextBtn sdc_horizontallyCenterInSuperviewWithOffset:SCREEN_WIDTH / 4];
    
    _likeBtn = [Common generateButtonWithTarget:self
                                         action:@selector(likeBtnAction:)];
    [_likeBtn setImage:IMAGE(@"btn_heart")
              forState:UIControlStateNormal];
    [_likeBtn setImage:IMAGE(@"btn_heart_red")
              forState:UIControlStateSelected];
    [self addSubview:_likeBtn];
    [_likeBtn sdc_alignEdgesWithSuperview:UIRectEdgeBottom
                                   insets:UIEdgeInsetsMake(0, 0, -60 - offsetY, 0)];
    [_likeBtn sdc_horizontallyCenterInSuperviewWithOffset:-SCREEN_WIDTH / 4];
    
    _hateBtn = [Common generateButtonWithTarget:self
                                         action:@selector(hateBtnAction:)];
    [_hateBtn setImage:IMAGE(@"btn_delete")
              forState:UIControlStateNormal];
    [self addSubview:_hateBtn];
    [_hateBtn sdc_alignEdgesWithSuperview:UIRectEdgeBottom
                                   insets:UIEdgeInsetsMake(0, 0, -60 - offsetY, 0)];
    [_hateBtn sdc_horizontallyCenterInSuperview];
    
    _lrcView = [[ANYMusicLRCView alloc] init];
    _lrcView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_lrcView];
    
    [_lrcView sdc_alignEdgesWithSuperview:UIRectEdgeLeft | UIRectEdgeRight];
    [_lrcView sdc_alignEdge:UIRectEdgeTop
                   withEdge:UIRectEdgeBottom
                     ofView:_artistLabel];
    [_lrcView sdc_alignEdge:UIRectEdgeBottom
                   withEdge:UIRectEdgeTop
                     ofView:_hateBtn];

}

- (void)enable:(BOOL)enable {
    self.playBtn.enabled = enable;
    self.nextBtn.enabled = enable;
}

- (void)interrupt {
    _artworkView.alpha = 0.2f;
    _titleLabel.alpha = 0.2f;
    _artistLabel.alpha = 0.2f;
    _lrcView.alpha = 0.2f;
    [_lrcView pauseLrc];
    _playBtn.selected = NO;
}

- (void)resume {
    _artworkView.alpha = 1.0f;
    _titleLabel.alpha = 1.0f;
    _artistLabel.alpha = 1.0f;
    _lrcView.alpha = 1.0f;
    [_lrcView continueLrc];
    
    if ([self.delegate respondsToSelector:@selector(playbackViewPressPlayBtn:)]) {
        [self.delegate playbackViewPressPlayBtn:self];
    }
}

- (void)playOrPause {
    [self playBtnAction:_playBtn];
}

#pragma mark - ui control action
- (void)playBtnAction:(id)sender {
    if (_playBtn.selected) {
        _artworkView.alpha = 0.2f;
        _titleLabel.alpha = 0.2f;
        _artistLabel.alpha = 0.2f;
        _lrcView.alpha = 0.2f;
        [_lrcView pauseLrc];
    } else {
        _artworkView.alpha = 1.0f;
        _titleLabel.alpha = 1.0f;
        _artistLabel.alpha = 1.0f;
        _lrcView.alpha = 1.0f;
        [_lrcView continueLrc];
    }
    
    if ([self.delegate respondsToSelector:@selector(playbackViewPressPlayBtn:)]) {
        [self.delegate playbackViewPressPlayBtn:self];
    }
}

- (void)nextBtnAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(playbackViewPressNextBtn:)]) {
        [self.delegate playbackViewPressNextBtn:self];
        
        _artworkView.alpha = 1.0f;
        _titleLabel.alpha = 1.0f;
        _artistLabel.alpha = 1.0f;
        _lrcView.alpha = 1.0f;
        [_lrcView pauseLrc];
    }
}

- (void)likeBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(playbackViewPressLikeBtn:likeFlag:)]) {
        [self.delegate playbackViewPressLikeBtn:self likeFlag:sender.selected];
    }
}

- (void)hateBtnAction:(id)sender {
    _artworkView.alpha = 1.0f;
    _titleLabel.alpha = 1.0f;
    _artistLabel.alpha = 1.0f;
    _lrcView.alpha = 1.0f;
    [_lrcView pauseLrc];
    if ([self.delegate respondsToSelector:@selector(playbackViewPressHateBtn:)]) {
        [self.delegate playbackViewPressHateBtn:self];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
