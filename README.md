# JCVideoPlayer
视频播放器

 - (void)viewDidLoad {<br>
    [super viewDidLoad];<br>
    JCPlayerView *playerView = [[JCPlayerView alloc] init];<br>
    NSString *url = @"https://pic.ibaotu.com/00/63/01/12h888piCneY.mp4";<br>
    playerView.vedioUrl = url;<br>
    playerView.videoTitle = @"这是一个视频标题";<br>
    playerView.delegate = self;<br>
    [playerView isMute:NO];<br>
    [self.view addSubview:playerView];<br>
    
    _playerView = playerView;<br>
    
 }


 - (void)videoPlayerLayoutOfOrientation:(JCPlayScreenOrientation)orientation {<br>
    if (orientation == JCPlayScreenOrientationVertical) {<br>
        [self.playerView mas_remakeConstraints:^(MASConstraintMaker *make) {<br>
            make.leading.trailing.equalTo(@0);<br>
            make.top.mas_equalTo(20);<br>
            make.height.mas_equalTo(260);<br>
        }];<br>
    } else {<br>
        [self.playerView mas_remakeConstraints:^(MASConstraintMaker *make) {<br>
            make.top.leading.bottom.trailing.mas_equalTo(0);<br>
        }];<br>
    }<br>
}<br>
