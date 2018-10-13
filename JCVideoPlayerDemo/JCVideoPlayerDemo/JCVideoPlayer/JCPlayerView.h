//
//  JCPlayerView.h
//  播放器Demo
//
//  Created by 漆珏成 on 2018/8/16.
//  Copyright © 2018年 漆珏成. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    JCButtonTypeLeftBarItem = 1000,
    JCButtonTypeVolume,
    JCButtonTypeShare,
} JCButtonType;

typedef enum : NSUInteger {
    JCPlayerStatusUnknown, // 未知
    JCPlayerStatusReadyToPlay, // 准备播放
    JCPlayerStatusFailed, // 播放失败
    JCPlayerStatusWillEnterForeground, // 将要进入前台
    JCPlayerStatusDidEnterBackground, // 进入后台
} JCPlayerStatus;

typedef enum : NSUInteger {
    JCPlayScreenOrientationVertical, // 竖屏
    JCPlayScreenOrientationHorizontal, // 横屏
} JCPlayScreenOrientation; // 播放器屏幕方向

@protocol JCPlayerViewDelegate<NSObject>
@required

/**
 视频播放器布局

 @param orientation 根据是否全屏布局，JCPlayScreenOrientation
 */
- (void)videoPlayerLayoutOfOrientation:(JCPlayScreenOrientation)orientation;
@optional

/**
 监听视频播放状态

 @param status JCPlayerStatus
 */
- (void)playVideoStatus:(JCPlayerStatus)status;


/**
 点击分享按钮
 */
- (void)didClickShareButtonAction:(UIButton *)button;
@end


@interface JCPlayerView : UIView

@property (assign, nonatomic) id<JCPlayerViewDelegate> delegate;
/**
 视频的URL
 */
@property (copy, nonatomic) NSString *vedioUrl;

/**
 声音大小
 */
@property (assign, nonatomic) CGFloat volumeValue;

/**
 工具栏自动消失时间
 */
@property (assign, nonatomic) int autoHiddenToobarDuration;

/**
 视频标题字体大小
 */
@property (strong, nonatomic) UIFont *videoTitleFont;

/**
 视频标题字体颜色
 */
@property (strong, nonatomic) UIColor *videoTitleColor;


/**
 视频标题
 */
@property (strong, nonatomic) NSString *videoTitle;

/**
 视频导航条背景颜色
 */
@property (strong, nonatomic) UIColor *navigationBarColor;

/**
 播放
 */
- (void)play;

/**
 暂停
 */
- (void)pause;


/**
 是否静音

 @param mute 默认NO
 */
- (void)isMute:(BOOL)mute;


/**
 移除播放器
 */
- (void)remove;
@end
