//
//  ANYMusicLRCView.m
//  buxinteng
//
//  Created by Anyson Chan on 15/11/19.
//  Copyright © 2015年 Anyson Chan. All rights reserved.
//

#import "ANYMusicLRCView.h"
#import "ANYLRCTableViewCell.h"
#import "ANYMusicLRC.h"
#import <UIView+SDCAutoLayout.h>

@interface ANYMusicLRCView ()<UITableViewDataSource, UITableViewDelegate> {
    int     _currentIndex;
    BOOL    _isBeginning;
    
    NSTimer *_timer;
    double   _beginTime;
    float   _timeInterval;
}

@property(nonatomic, strong) ANYMusicLRC *musicLrc;
@property(nonatomic, strong) UITableView *tableView;

@end


@implementation ANYMusicLRCView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _musicLrc = [[ANYMusicLRC alloc] init];
        [self setupSubviews];
    }
    return self;
}

- (void)awakeFromNib{
    [self setupSubviews];
}

- (void)setupSubviews {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero
                                              style:UITableViewStylePlain];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.userInteractionEnabled = NO;
    [self addSubview:_tableView];
    
    [_tableView registerClass:[ANYLRCTableViewCell class]
       forCellReuseIdentifier:@"ANYLRCTableViewCell"];
    
    [_tableView sdc_alignEdgesWithSuperview:UIRectEdgeAll
                                     insets:UIEdgeInsetsMake(20, 0, -20, 0) ];
}

- (void)updateLrc {
    if (_currentIndex < self.musicLrc.lrcList.count) {
        ANYMusicLRCItem *item = [self.musicLrc.lrcList objectAtIndex:_currentIndex] ;
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0]
                                    animated:YES
                              scrollPosition:UITableViewScrollPositionMiddle];
        ++_currentIndex;
        _timeInterval = 0;
        if (_currentIndex < self.musicLrc.lrcList.count) {
            ANYMusicLRCItem *item2 = [self.musicLrc.lrcList objectAtIndex:_currentIndex];
            _timeInterval = item2.time - item.time;
        }
        if ([_timer isValid]) {
            [_timer invalidate];
        }
        _timer= [NSTimer scheduledTimerWithTimeInterval:_timeInterval
                                                 target:self
                                               selector:@selector(updateLrc)
                                               userInfo:nil
                                                repeats:NO];
        _beginTime = [[NSDate date] timeIntervalSince1970] * 1000;
        NSLog_DEBUG(@"");
    }
}

#pragma mark - table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.musicLrc.lrcList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ANYLRCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ANYLRCTableViewCell"
                                                                forIndexPath:indexPath];
    if (self.musicLrc.lrcList.count > 0) {
        [cell setupLRC:[[self.self.musicLrc.lrcList objectAtIndex:indexPath.row] lrcStr]];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30.0f;
}


#pragma mark - public method
- (void)resetLRC {
    [self.musicLrc.lrcList removeAllObjects];
    [self.tableView reloadData];
    
    if ([_timer isValid]) {
        [_timer invalidate];
    }
}

- (void)reloadLRC:(NSString *)lrc {
    [self.musicLrc reloadWithLRC:lrc];
    _isBeginning = NO;
}

- (void)reloadLRCWithPath:(NSString *)path {
    [self.musicLrc reloadWithLRCFile:path];
    _isBeginning = NO;
}

- (void)beganLrc:(float)playbackTime {
    if ([_timer isValid]) {
        [_timer invalidate];
        _timer = nil;
    }

    _isBeginning = YES;
    [self.tableView reloadData];
    
    int i = 0;
    //找到时间最近的歌词
    for (;i < self.musicLrc.lrcList.count-1; ++i) {
        ANYMusicLRCItem *item = [self.musicLrc.lrcList objectAtIndex:i];
        ANYMusicLRCItem *item2 = [self.musicLrc.lrcList objectAtIndex:i+1];
        NSLog_DEBUG(@"%f, %f", item.time, item2.time);
        if (item.time == playbackTime) {
            _currentIndex = i;
            break;
        } else if (item2.time == playbackTime) {
            _currentIndex = i+1;
            break;
        } else if ((item.time < playbackTime) &&
                   (item2.time > playbackTime)) {
            float t1 = fabsf(playbackTime - item.time);
            float t2 = fabsf(playbackTime - item2.time);
            
            _currentIndex = (t1 >= t2)? i+1:i;
            break;
        }
    }
    NSLog_DEBUG(@"found :%d; %f", i, playbackTime);
    
    if (i < self.musicLrc.lrcList.count - 1) {
        [self updateLrc];
        if (_currentIndex > 0) {
            
            for (int j = 0;j < _currentIndex; ++j) {
                ANYLRCTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:0]];
                [cell setupLRCColor:RGB_PRIMARY];
            }
        }
    } else {
        _currentIndex = 0;
    }
}

- (void)pauseLrc {
    float t = ([[NSDate date] timeIntervalSince1970]*1000 - _beginTime) / 1000;
    _timeInterval = _timeInterval - t;
    if ([_timer isValid]) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)continueLrc {
    _timer= [NSTimer scheduledTimerWithTimeInterval:_timeInterval
                                             target:self
                                           selector:@selector(updateLrc)
                                           userInfo:nil
                                            repeats:NO];
    _beginTime = [[NSDate date] timeIntervalSince1970]*1000;

}

- (BOOL)canBeginLrc:(float)playbackTime {
    if (playbackTime >= [[self.musicLrc.lrcList firstObject] time] && !_isBeginning && self.musicLrc.lrcList.count > 0) {
        return YES;
    }
    
    return NO;
}

@end
