//
//  MainViewController.m
//  buxinteng
//
//  Created by Anyson Chan on 15/11/15.
//  Copyright © 2015年 Anyson Chan. All rights reserved.
//

#import "MainViewController.h"
#import "ANYPlayer.h"
#import "ANYPlaybackView.h"
#import <UIView+SDCAutoLayout.h>
#import "ANYQianQianLyricsDownloader.h"
#import "ANYAudioSessionHandler.h"
#import "NetworkMonitor.h"

@import MediaPlayer;

@interface MainViewController ()<ANYPlayerDelegate, ANYPlaybackViewDelegate> {
    NSDictionary *_playingDict;
}

@property(nonatomic, strong) NSArray *dataArray;
@property(nonatomic, strong) NSArray *lrcPathArray;
@property(nonatomic, strong) UILabel *networkStatusLable;
@property(nonatomic, strong) ANYPlaybackView *playbackView;
@property(nonatomic, strong) ANYPlayer *player;

@end

@implementation MainViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:ANYPlaybackInterruptionNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:ANYPlaybackResumeNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:ANYNetworkInterruptionNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:ANYNetworkResumeNotification
                                                  object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    //    接受远程控制
    [self becomeFirstResponder];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

- (void)viewDidDisappear:(BOOL)animated {
    //    取消远程控制
    [self resignFirstResponder];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.title = @"不心疼";
    
    _player = [[ANYPlayer alloc] init];
    _player.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playbackInterruption)
                                                 name:ANYPlaybackInterruptionNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playbackResume)
                                                 name:ANYPlaybackResumeNotification
                                               object:nil];
    
    [self setupSubviews];
    
    [[NetworkMonitor shardInstance] start];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkInterruption:)
                                                 name:ANYNetworkInterruptionNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkResume:)
                                                 name:ANYNetworkResumeNotification
                                               object:nil];
}

- (void)loadData {
    _dataArray = [NSArray arrayWithContentsOfURL:[NSURL URLWithString:@"http://7xl2f9.com1.z0.glb.clouddn.com/play_list.plist"]];
}

- (void)playNext {
    int index = arc4random() % self.dataArray.count;
    _playingDict = [self.dataArray objectAtIndex:index] ;
    [_player loadPlayerItem:[NSURL URLWithString:[[_playingDict objectForKey:@"tracks"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [self.playbackView.lrcView resetLRC];
}

- (NSString *)convertTime:(CGFloat)second {
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (second/3600 >= 1) {
        [formatter setDateFormat:@"HH:mm:ss"];
    } else {
        [formatter setDateFormat:@"mm:ss"];
    }
    NSString *showtimeNew = [formatter stringFromDate:d];
    return showtimeNew;
}

- (void)setupSubviews {
    ANYPlaybackView *playbackView = [[ANYPlaybackView alloc] init];
    playbackView.delegate = self;
    [self.view addSubview:playbackView];
    
    [playbackView sdc_alignEdgesWithSuperview:UIRectEdgeAll
                                       insets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
    _playbackView = playbackView;
    
    _networkStatusLable = [Common generateLabelWithText:@"当前网络不可用，请检查你的网络设置"
                                          textAlignment:NSTextAlignmentCenter
                                                   font:FONT(15)
                                              textColor:RGB(216, 212, 140)];
    [self.view addSubview:_networkStatusLable];
    [_networkStatusLable sdc_alignEdgesWithSuperview:UIRectEdgeTop | UIRectEdgeLeft | UIRectEdgeRight
                                              insets:UIEdgeInsetsMake(20, 20, 0, -20)];
    _networkStatusLable.alpha = 0.0f;
    
}

- (void)loadPlayerItemMetaData:(NSDictionary *)metaData {
    
    UIImage *artworkImage = IMAGE(@"noArt");
    NSString *title = @"Unknown Song";
    NSString *artist = @"Unknown Artist";
    if ([metaData objectForKey:kArtwork]) {
        artworkImage = [UIImage imageWithData:[metaData objectForKey:kArtwork]];
    }
    
    if ([metaData objectForKey:kTitle]) {
        title = [metaData objectForKey:kTitle];
    }
    
    if ([metaData objectForKey:kArtist]) {
        artist = [metaData objectForKey:kArtist];
    }
    
    [self.playbackView.progressView setElapsedTime:0];
    [self.playbackView.progressView setTimeLimit:[[metaData objectForKey:kDuration] floatValue]];
    
    [[self.playbackView artworkView] setImage:artworkImage];
    [[self.playbackView titleLabel] setText:title];
    [[self.playbackView artistLabel] setText:artist];

    MPMediaItemArtwork *artWork = [[MPMediaItemArtwork alloc] initWithImage:artworkImage];
    
    NSDictionary *dic = @{MPMediaItemPropertyTitle:title,
                          MPMediaItemPropertyArtist:artist,
                          MPMediaItemPropertyArtwork:artWork,
                          MPMediaItemPropertyPlaybackDuration:[metaData objectForKey:kDuration]};
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dic];
    
//    NSString *lrc = [ANYQianQianLyricsDownloader downLoadLyricsByArtist:artist
//                                                               AndTitle:title];
    
     NSString *lrc = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:[[_playingDict objectForKey:@"lrc"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] encoding:NSUTF8StringEncoding error:nil];
    
    [self.playbackView.lrcView reloadLRC:lrc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - notification action
- (void)playbackInterruption {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.playbackView interrupt];
    });
}

- (void)playbackResume {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.playbackView resume];
    });
}

- (void)networkInterruption:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.networkStatusLable.alpha = 1.0f;
                         }];
        BOOL flag = [[notification object] boolValue];
        [self.playbackView enable:NO];
        if (flag) {
            //首次打开没有网络
            
        } else {
            //播放过程中没有有网络
            [self.playbackView interrupt];
            [self.player pause];
        }
    });
}

- (void)networkResume:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.networkStatusLable.alpha = 0.0f;
                         }];
        BOOL flag = [[notification object] boolValue];
        [self.playbackView enable:YES];
        if (!self.dataArray || flag) {
            [self loadData];
            [self playNext];
        } else {
            if (![self.player isPlaying]) {
                [self.playbackView resume];
            }
        }
    });
}

#pragma mark - ANYPlayer delegate
- (void)player:(ANYPlayer *)player readyToPlay:(NSDictionary *)commonMetaData {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadPlayerItemMetaData:commonMetaData];
        [self.player play];
        [[self.playbackView playBtn] setSelected:YES];
    });
}

- (void)player:(ANYPlayer *)player loadedTimeRanges:(float)loadedTime duration:(float)duration {
    dispatch_async(dispatch_get_main_queue(), ^{
        
    });
}

- (void)player:(ANYPlayer *)player updatePlaybackTime:(float)playbackTime duration:(float)duration {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.playbackView.progressView setElapsedTime:playbackTime];
        if ([self.playbackView.lrcView canBeginLrc:playbackTime]) {
            [self.playbackView.lrcView beganLrc:playbackTime];
        }
    });
}

- (void)player:(ANYPlayer *)player failedToPlay:(NSError *)error {
    
}

- (void)playerDidPlayToEndTime:(ANYPlayer *)player {
    [self playNext];
}

- (void)playerFailedToPlayToEndTime:(ANYPlayer *)player {
    [self playNext];
}

#pragma mark - playback view delegte 
- (void)playbackViewPressPlayBtn:(ANYPlaybackView *)playbackView {
    if (!playbackView.playBtn.selected) {
        [_player play];
    } else {
        [_player pause];
    }
    playbackView.playBtn.selected = !playbackView.playBtn.selected;
}

- (void)playbackViewPressNextBtn:(ANYPlaybackView *)playbackView {
    if ([self.player isPlaying]) {
        [self.player pause];
        playbackView.playBtn.selected = NO;
    }
    
    [self playNext];
}

#pragma mark - remote control received
- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (event.type == UIEventTypeRemoteControl) {  //判断是否为远程控制
            switch (event.subtype) {
                case  UIEventSubtypeRemoteControlPlay:
                    if (![self.player isPlaying]) {
                        [self.playbackView playOrPause];
                    }
                    
                    break;
                case UIEventSubtypeRemoteControlPause:
                    if ([self.player isPlaying]) {
                        [self.playbackView playOrPause];
                    }
                    break;
                case UIEventSubtypeRemoteControlNextTrack:
                    [self playbackViewPressNextBtn:self.playbackView];
                    NSLog_DEBUG(@"下一首");
                    break;
                case UIEventSubtypeRemoteControlPreviousTrack:
                    NSLog_DEBUG(@"上一首 ");
                    break;
                default:
                    break;
            }
        }
    });
}

@end
