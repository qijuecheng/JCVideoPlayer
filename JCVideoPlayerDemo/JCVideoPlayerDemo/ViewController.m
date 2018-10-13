//
//  ViewController.m
//  JCVideoPlayerDemo
//
//  Created by 漆珏成 on 2018/10/13.
//  Copyright © 2018年 漆珏成. All rights reserved.
//

#import "ViewController.h"
#import "JCPlayerView.h"
#import <Masonry.h>

@interface ViewController ()<JCPlayerViewDelegate>
@property (strong, nonatomic) JCPlayerView *playerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    JCPlayerView *playerView = [[JCPlayerView alloc] init];
    NSString *url = @"https://pic.ibaotu.com/00/63/01/12h888piCneY.mp4";
    playerView.vedioUrl = url;
    playerView.videoTitle = @"这是一个视频标题";
    playerView.delegate = self;
    [playerView isMute:NO];
    [self.view addSubview:playerView];
    
    _playerView = playerView;
    
}


- (void)videoPlayerLayoutOfOrientation:(JCPlayScreenOrientation)orientation {
    if (orientation == JCPlayScreenOrientationVertical) {
        [self.playerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(@0);
            make.top.mas_equalTo(20);
            make.height.mas_equalTo(260);
        }];
    } else {
        [self.playerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.bottom.trailing.mas_equalTo(0);
        }];
    }
}


@end
