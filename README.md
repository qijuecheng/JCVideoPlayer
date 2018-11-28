# JCVideoPlayer
视频播放器
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
