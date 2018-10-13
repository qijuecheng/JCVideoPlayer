//
//  JCPlayerView.m
//  播放器Demo
//
//  Created by 漆珏成 on 2018/8/16.
//  Copyright © 2018年 漆珏成. All rights reserved.
//

#import "JCPlayerView.h"
#import <AVFoundation/AVFoundation.h>
#import <Masonry.h>
#import "NSString+JCTime.h"
#import "JCRotationScreen.h"

@interface JCPlayerView()

@property (strong, nonatomic) AVPlayer *player;

@property (strong, nonatomic) AVPlayerItem *playerItem;

@property (strong, nonatomic) AVPlayerLayer *playerLayer;
/// 观察者
@property (strong, nonatomic) id playTimeObserver;

/// 工具条
@property (strong, nonatomic) UIView *toolbar;

/// 播放/暂停按钮
@property (strong, nonatomic) UIButton *playButton;
/// 开始时间label
@property (strong, nonatomic) UILabel *beginTimeLabel;

/// 结束时间时间label
@property (strong, nonatomic) UILabel *endTimeLabel;
/// 进度条
@property (strong, nonatomic) UISlider *progressBarSlider;

@property (strong, nonatomic) UIProgressView *loadProgressBar;

@property (strong, nonatomic) UIButton *fullScreenButton;

@property (strong, nonatomic) UIButton *midPlayButton;
/// 是否正在滑动进度条
@property (assign, nonatomic, getter=isSliding) BOOL sliding;

@property (strong, nonatomic) UIView *navigationBar;

@property (strong, nonatomic) UIButton *leftBarButtonItem;

@property (strong, nonatomic) UILabel *videoTitleLabel;

@property (strong, nonatomic) UIButton *volumeButton;

@property (strong, nonatomic) UIButton *shareButton;

@property (assign, nonatomic, getter=isDisplayNavigation) BOOL displayNavigation;
@end

@implementation JCPlayerView

#pragma mark - Getter

- (UIView *)toolbar {
    if (!_toolbar) {
        _toolbar = [[UIView alloc] init];
        _toolbar.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    }
    return _toolbar;
}

- (UIButton *)midPlayButton {
    if (!_midPlayButton) {
        _midPlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_midPlayButton setImage:[UIImage imageNamed:@"big_pause"] forState:UIControlStateSelected];
        [_midPlayButton setImage:[UIImage imageNamed:@"big_play"] forState:UIControlStateNormal];
        [_midPlayButton addTarget:self action:@selector(onclickBeginWithEndButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _midPlayButton;
}

- (UIButton *)playButton {
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setImage:[UIImage imageNamed:@"video_play"] forState:UIControlStateNormal];
        [_playButton setImage:[UIImage imageNamed:@"video_pause"] forState:UIControlStateSelected];
        [_playButton addTarget:self action:@selector(onclickBeginWithEndButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}

- (UILabel *)beginTimeLabel {
    if (!_beginTimeLabel) {
        _beginTimeLabel = [[UILabel alloc] init];
        _beginTimeLabel.textColor = [UIColor whiteColor];
        _beginTimeLabel.font = [UIFont systemFontOfSize:14];
        _beginTimeLabel.text = @"00:00";
    }
    return _beginTimeLabel;
}

- (UILabel *)endTimeLabel {
    if (!_endTimeLabel) {
        _endTimeLabel = [[UILabel alloc] init];
        _endTimeLabel.textColor = [UIColor whiteColor];
        _endTimeLabel.font = [UIFont systemFontOfSize:14];
        _endTimeLabel.text = @"00:00";
    }
    return _endTimeLabel;
}

- (UISlider *)progressBarSlider {
    if (!_progressBarSlider) {
        _progressBarSlider = [[UISlider alloc] init];
        _progressBarSlider.minimumTrackTintColor = [UIColor colorWithRed:22/255.0 green:130/255.0 blue:251/255.0 alpha:1];
        _progressBarSlider.maximumTrackTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
        _progressBarSlider.minimumValue = 0.0;
        _progressBarSlider.maximumValue = 1.0;
        [_progressBarSlider addTarget:self action:@selector(onclickProgressSliderChanged:) forControlEvents:UIControlEventValueChanged];
        [_progressBarSlider setThumbImage:[UIImage imageNamed:@"silder_circle.png"] forState:UIControlStateNormal];
        [_progressBarSlider trackRectForBounds:CGRectMake(0, 0, 20, 20)];
    }
    return _progressBarSlider;
}

- (UIProgressView *)loadProgressBar {
    if (!_loadProgressBar) {
        _loadProgressBar = [[UIProgressView alloc] init];
        _loadProgressBar.progressTintColor = [UIColor whiteColor];
        _loadProgressBar.progressViewStyle = UIProgressViewStyleDefault;
    }
    return _loadProgressBar;
}

- (UIButton *)fullScreenButton {
    if (!_fullScreenButton) {
        _fullScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreenButton setImage:[UIImage imageNamed:@"video_Fullscreen"] forState:UIControlStateNormal];
        [_fullScreenButton addTarget:self action:@selector(onclickFullScreenButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullScreenButton;
}

- (UIView *)navigationBar {
    if (!_navigationBar) {
        _navigationBar = [[UIView alloc] init];
        _navigationBar.backgroundColor = self.navigationBarColor;
        _navigationBar.hidden = YES;
    }
    return _navigationBar;
}

- (UIButton *)leftBarButtonItem {
    if (!_leftBarButtonItem) {
        _leftBarButtonItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftBarButtonItem setImage:[UIImage imageNamed:@"return_white"] forState:UIControlStateNormal];
        [_leftBarButtonItem addTarget:self action:@selector(onclickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _leftBarButtonItem.tag = JCButtonTypeLeftBarItem;
    }
    return _leftBarButtonItem;
}

- (UILabel *)videoTitleLabel {
    if (!_videoTitleLabel) {
        _videoTitleLabel = [[UILabel alloc] init];
        _videoTitleLabel.font = _videoTitleFont;
        _videoTitleLabel.textColor = _videoTitleColor;
        _videoTitleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _videoTitleLabel;
}

- (UIButton *)volumeButton {
    if (!_volumeButton) {
        _volumeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_volumeButton setImage:[UIImage imageNamed:@"volume_open"] forState:UIControlStateNormal];
        [_volumeButton setImage:[UIImage imageNamed:@"volume_close"] forState:UIControlStateSelected];
        [_volumeButton addTarget:self action:@selector(onclickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _volumeButton.tag = JCButtonTypeVolume;
    }
    return _volumeButton;
}

- (UIButton *)shareButton {
    if (!_shareButton) {
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareButton setImage:[UIImage imageNamed:@"more_white"] forState:UIControlStateNormal];
        [_shareButton addTarget:self action:@selector(onclickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _shareButton.tag = JCButtonTypeShare;
    }
    return _shareButton;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        _autoHiddenToobarDuration = 6;
        _navigationBarColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _videoTitleColor = [UIColor whiteColor];
        _videoTitleFont = [UIFont systemFontOfSize:14];
        [self setup];
        [self setupFrame];
        [self configureVideo];
        [self autoHiddenToolbar];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    AVPlayerItem *item = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status = [[change objectForKey:@"new"] intValue];
        if (status == AVPlayerStatusReadyToPlay) {
            NSLog(@"准备播放");
            if ([self.delegate respondsToSelector:@selector(playVideoStatus:)]) {
                [self.delegate playVideoStatus:JCPlayerStatusReadyToPlay];
            }
            CMTime duration = item.duration;
            self.progressBarSlider.maximumValue = CMTimeGetSeconds(duration);
            self.endTimeLabel.text = [NSString convertTime:CMTimeGetSeconds(duration)];
        } else if (status == AVPlayerStatusFailed) {
            NSLog(@"播放失败");
            if ([self.delegate respondsToSelector:@selector(playVideoStatus:)]) {
                [self.delegate playVideoStatus:JCPlayerStatusFailed];
            }
        } else {
            NSLog(@"AVPlayerStatusUnknown");
            if ([self.delegate respondsToSelector:@selector(playVideoStatus:)]) {
                [self.delegate playVideoStatus:JCPlayerStatusUnknown];
            }
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSTimeInterval timeInterval = [self availableDurationRanges]; // 缓冲时间
        CGFloat totalDuration = CMTimeGetSeconds(self.playerItem.duration); // 总时间
        [self.loadProgressBar setProgress:timeInterval / totalDuration animated:YES];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.playerLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self isDisplayToolbar];
}


/**
 横竖屏切换时，执行

 @param previousTraitCollection UITraitCollection
 */
- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    if (self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact) {
        if ([self.delegate respondsToSelector:@selector(videoPlayerLayoutOfOrientation:)]) {
            [self.delegate videoPlayerLayoutOfOrientation:JCPlayScreenOrientationHorizontal];
        }
        self.navigationBar.hidden = NO;
        self.displayNavigation = YES;
    } else {
        if ([self.delegate respondsToSelector:@selector(videoPlayerLayoutOfOrientation:)]) {
            [self.delegate videoPlayerLayoutOfOrientation:JCPlayScreenOrientationVertical];
        }
        self.navigationBar.hidden = YES;
        self.displayNavigation = NO;
    }
}

#pragma mark - Private
- (void)setup {
    [self addSubview:self.midPlayButton];
    [self addSubview:self.toolbar];
    [self.toolbar addSubview:self.playButton];
    [self.toolbar addSubview:self.beginTimeLabel];
    [self.toolbar addSubview:self.loadProgressBar];
    [self.toolbar addSubview:self.progressBarSlider];
    [self.toolbar addSubview:self.endTimeLabel];
    [self.toolbar addSubview:self.fullScreenButton];
    
    [self addSubview:self.navigationBar];
    [self.navigationBar addSubview:self.leftBarButtonItem];
    [self.navigationBar addSubview:self.videoTitleLabel];
    [self.navigationBar addSubview:self.volumeButton];
    [self.navigationBar addSubview:self.shareButton];
}

- (void)setupFrame {
    [self.midPlayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.width.height.mas_equalTo(80);
    }];
    
    [self.toolbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(self.toolbar);
        make.width.height.mas_equalTo(22);
    }];
    
    [self.beginTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.playButton.mas_right).mas_offset(10);
        make.centerY.mas_equalTo(self.toolbar);
    }];
    
    [self.progressBarSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.beginTimeLabel.mas_right).mas_offset(10);
        make.right.mas_equalTo(self.endTimeLabel.mas_left).mas_offset(-10);
        make.centerY.mas_equalTo(self.toolbar);
        make.height.mas_equalTo(20);
    }];
    
    [self.loadProgressBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.width.mas_equalTo(self.progressBarSlider);
        make.centerY.mas_equalTo(self.progressBarSlider).mas_offset(1);
        make.height.mas_equalTo(2);
    }];
    
    
    [self.endTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.fullScreenButton.mas_left).mas_offset(-20);
        make.centerY.mas_equalTo(self.toolbar);
    }];
    
    [self.fullScreenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.toolbar);
        make.width.height.mas_equalTo(16);
    }];
    
    [self.navigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self);
        make.height.mas_equalTo(40);
    }];
    
    [self.leftBarButtonItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.navigationBar);
        make.left.mas_equalTo(10);
        make.width.height.mas_equalTo(25);
    }];
    
    [self.videoTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftBarButtonItem.mas_right).mas_offset(10);
        make.centerY.mas_equalTo(self.navigationBar);
        make.right.mas_lessThanOrEqualTo(self.navigationBar).mas_offset(-10);
    }];
    
    [self.volumeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.shareButton.mas_left).mas_offset(-10);
        make.centerY.mas_equalTo(self.navigationBar);
    }];
    
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(self.navigationBar);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(4);
    }];
}


/**
 视频配置
 */
- (void)configureVideo {
    _player = [[AVPlayer alloc] init];
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.layer addSublayer:self.playerLayer];
    [self bringSubviewToFront:self.midPlayButton];
    [self bringSubviewToFront:self.toolbar];
    [self bringSubviewToFront:self.navigationBar];
}



- (void)addObserverAndNotification {
    [_playerItem addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionNew) context:nil];
    [_playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:(NSKeyValueObservingOptionNew) context:nil];
    [self monitoringPlayBack:self.playerItem];
    [self addNotifaction];
}

// 观察播放进度
- (void)monitoringPlayBack:(AVPlayerItem *)item {
    __weak typeof(self) WeakSelf = self;
    _playTimeObserver = [_player addPeriodicTimeObserverForInterval:CMTimeMake(1, 30.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float currentPlayTime = (double)(item.currentTime.value / item.currentTime.timescale);
        if (!WeakSelf.isSliding) {
            [WeakSelf updateVideoProgressSlider:currentPlayTime];
        }
    }];
}

// 更新滑动条
- (void)updateVideoProgressSlider:(float)currentTime {
    self.progressBarSlider.value = currentTime;
    self.beginTimeLabel.text = [NSString convertTime:currentTime];
}

- (void)addNotifaction {
    // 播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(vedioPlayDidFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    // 前台通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterForegroundNotification) name:UIApplicationWillEnterForegroundNotification object:nil];
    // 后台通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackgroundNotification) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

// 已缓冲进度
- (NSTimeInterval)availableDurationRanges {
    // 获取item的缓存速度
    NSArray *loadedTimeRanges = [self.playerItem loadedTimeRanges];
    // 获取缓存域
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    // 计算总缓冲时间 = start + duration
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;
    return result;
}

- (void)autoHiddenToolbar {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_autoHiddenToobarDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.toolbar.hidden = YES;
        self.midPlayButton.hidden = YES;
        self.navigationBar.hidden = YES;
    });
}


/**
 是否显示工具栏
 */
- (void)isDisplayToolbar {
    self.toolbar.hidden = !self.toolbar.hidden;
    self.midPlayButton.hidden = !self.midPlayButton.hidden;
    if (self.isDisplayNavigation) {
        self.navigationBar.hidden = !self.navigationBar.hidden;
    }
    if (!self.toolbar.hidden) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_autoHiddenToobarDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.toolbar.hidden = YES;
            self.midPlayButton.hidden = YES;
            if (self.isDisplayNavigation) {
                self.navigationBar.hidden = YES;
            }
        });
    }
}

- (void)didScreenChanged {
    if ([JCRotationScreen isOrientatioinLandscape]) {
        [JCRotationScreen rotationScreenOrientation:(UIInterfaceOrientationPortrait)];
    } else {
        [JCRotationScreen rotationScreenOrientation:(UIInterfaceOrientationLandscapeRight)];
    }
}
    

#pragma mark - Action
- (void)onclickBeginWithEndButtonAction:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        [self play];
    } else {
        [self pause];
    }
    self.playButton.selected = button.selected;
    self.midPlayButton.selected = button.selected;
}

- (void)onclickFullScreenButtonAction:(UIButton *)button {
    [self didScreenChanged];
}

- (void)onclickProgressSliderChanged:(UISlider *)slider {
    [self pause];
    CMTime changedTime = CMTimeMakeWithSeconds(self.progressBarSlider.value, 1.0);
    [self.playerItem seekToTime:changedTime completionHandler:^(BOOL finished) {
        // 跳转完成后
    }];
}

/**
 视频播放完成
 */
- (void)vedioPlayDidFinished:(NSNotification *)noti {
    _playerItem = [noti object];
    [_playerItem seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
        self.playButton.selected = NO;
    }];
    
    self.midPlayButton.hidden = NO;
    self.midPlayButton.selected = NO;
}

- (void)willEnterForegroundNotification {
    if ([self.delegate respondsToSelector:@selector(playVideoStatus:)]) {
        [self.delegate playVideoStatus:JCPlayerStatusWillEnterForeground];
    }
}

- (void)didEnterBackgroundNotification {
    if ([self.delegate respondsToSelector:@selector(playVideoStatus:)]) {
        [self.delegate playVideoStatus:JCPlayerStatusDidEnterBackground];
    }
}

- (void)onclickButtonAction:(UIButton *)button {
    if (button.tag == JCButtonTypeLeftBarItem) {
        [self didScreenChanged];
    } else if (button.tag == JCButtonTypeVolume) {
        button.selected = !button.selected;
        [self isMute:button.selected];
    } else if (button.tag == JCButtonTypeShare) {
        if ([self.delegate respondsToSelector:@selector(didClickShareButtonAction:)]) {
            [self.delegate didClickShareButtonAction:button];
        }
    }
}

#pragma mark - Public
- (void)setVedioUrl:(NSString *)vedioUrl {
    _vedioUrl = vedioUrl;
    _playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:vedioUrl]];
    [_player replaceCurrentItemWithPlayerItem:_playerItem];
    [self addObserverAndNotification];
}

- (void)play {
    [self.player play];
    self.playButton.selected = YES;
    self.midPlayButton.selected = YES;
}

- (void)pause {
    [self.player pause];
    self.playButton.selected = NO;
    self.midPlayButton.selected = NO;
}

- (void)setVolumeValue:(CGFloat)volumeValue {
    _volumeValue = volumeValue;
    self.player.volume = volumeValue;
}

- (void)setVideoTitle:(NSString *)videoTitle {
    _videoTitle = videoTitle;
    self.videoTitleLabel.text = videoTitle;
}

- (void)isMute:(BOOL)mute {
    if (mute) {
        self.player.volume = 0.0;
    } else {
        self.player.volume = 0.5;
    }
}

- (void)remove {
    [self.player replaceCurrentItemWithPlayerItem:nil];
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [self.player removeTimeObserver:self.playTimeObserver];
    self.playTimeObserver = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
