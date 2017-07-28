//
//  ZLPlayingInfoView.m
//  ZhongLe
//
//  Created by jasonwu on 2017/7/12.
//  Copyright © 2017年 jasonwu. All rights reserved.
//

#import "ZLPlayingInfoView.h"
#import "ZLSongModel.h"
#import "Masonry.h"
#import "UIImageEX.h"
#import "ZLDefine.h"
#import "UIImageView+WebCache.h"
#import "UIColor+App.h"
#import "ZLPlayingManager.h"
#import "MarqueeLabel.h"

static const int COVER_SIZE = 200;
static const int BUTTON_SIZE = 100;
@interface ZLPlayingInfoView ()

@property (nonatomic, strong) UIImageView   *bgView;
@property (nonatomic, strong) UIImageView   *blurView;
@property (nonatomic, strong) UIButton      *btnFold;
@property (nonatomic, strong) MarqueeLabel  *lbSongName;
@property (nonatomic, strong) UILabel       *lbSinger;
@property (nonatomic, strong) UIImageView   *imgCover;
@property (nonatomic, strong) UILabel       *lbProgress;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UISlider      *playSlider;
@property (nonatomic, strong) UILabel       *lbDuration;
@property (nonatomic, strong) UIButton      *btnPre;
@property (nonatomic, strong) UIButton      *btnPlay;
@property (nonatomic, strong) UIButton      *btnNext;

@property (nonatomic, assign) BOOL          shouldRefreshProgress;

@end

@implementation ZLPlayingInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.blurView];
        [self addSubview:self.bgView];
        [self addSubview:self.btnFold];
        [self addSubview:self.lbSongName];
        [self addSubview:self.lbSinger];
        [self addSubview:self.imgCover];
        [self addSubview:self.lbProgress];
        [self addSubview:self.progressView];
        [self addSubview:self.playSlider];
        [self addSubview:self.lbDuration];
        [self addSubview:self.btnPre];
        [self addSubview:self.btnPlay];
        [self addSubview:self.btnNext];
        
        [self refreshPlayBtnImage];
        
        _shouldRefreshProgress = true;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkStartCoverAnimation) name:Notif_SongStatusChanged object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectSwitchSong:) name:Notif_SwitchSong object:nil];
        
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)layoutUI {
//    CGSize textSize = [self.lbSongName sizeThatFits:CGSizeZero];
//    if (textSize.width > self.lbSongName.frame.size.width) {
//        textSize.width = self.lbSongName.frame.size.width;
//    }
//    [self.lbSongName mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self).offset(nameTopMargin);
//        make.centerX.mas_equalTo(self);
//        make.size.mas_equalTo(textSize);
//    }];
    
    CGSize textSize = [self.lbSinger sizeThatFits:CGSizeZero];
    [self.lbSinger mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lbSongName.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self);
        make.size.mas_equalTo(textSize);
    }];
    
    [self.imgCover mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(160);
        make.centerX.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(COVER_SIZE, COVER_SIZE));
    }];
    
    [self.btnFold mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(30);
        make.trailing.equalTo(self).offset(-30);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self.btnPlay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-40);
        make.centerX.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(BUTTON_SIZE, BUTTON_SIZE));
    }];
    
    CGFloat btnMargin = 15;
    [self.btnPre mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.btnPlay);
        make.trailing.equalTo(self.btnPlay.mas_leading).offset(-btnMargin);
        make.size.mas_equalTo(CGSizeMake(BUTTON_SIZE, BUTTON_SIZE));
    }];
    
    [self.btnNext mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.btnPlay);
        make.leading.equalTo(self.btnPlay.mas_trailing).offset(btnMargin);
        make.size.mas_equalTo(CGSizeMake(BUTTON_SIZE, BUTTON_SIZE));
    }];
    
    CGFloat progressWith = SCREEN_WIDTH - 110;
    CGFloat progressHeight = 2;
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.btnPlay.mas_top).offset(-20);
        make.centerX.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(progressWith,progressHeight));
    }];
    
    [self.playSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.btnPlay.mas_top).offset(-20);
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(self.progressView).offset(-1);
        make.size.mas_equalTo(CGSizeMake(progressWith,50));
    }];
    
    CGSize progressSize = [self.lbProgress sizeThatFits:CGSizeZero];
    [_lbProgress mas_updateConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.progressView.mas_leading).offset(-5);
        make.centerY.mas_equalTo(self.progressView);
        make.size.mas_equalTo(CGSizeMake(progressSize.width + 2, progressSize.height));
    }];
    
    CGSize durationSize = [self.lbDuration sizeThatFits:CGSizeZero];
    [_lbDuration mas_updateConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.progressView.mas_trailing).offset(5);
        make.centerY.mas_equalTo(self.progressView);
        make.size.mas_equalTo(durationSize);
    }];
    
    [self layoutIfNeeded];
}

#pragma mark - 刷新UI
- (void)refreshViewWithModel:(ZLSongModel *)model {
    if (!model) {
        return;
    }
    self.lbSongName.text = model.songName;
    self.lbSinger.text   = model.singer;
    self.lbDuration.text = model.duration;
    [self.imgCover sd_setImageWithURL:[NSURL URLWithString:model.albumUrl] placeholderImage:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        UIImage *blurImage = [image scaleToSize:CGSizeMake(30, 30)];
        self.blurView.image = blurImage;
    }];
    
    float playingTime = [ZLPlayingManager sharedPlayingManager].curPlayingTime;
    [self refreshPlayingProgress:playingTime];
    
    float loadProgress = [ZLPlayingManager sharedPlayingManager].curLoadingScale;
    [self refreshLoadingProgress:loadProgress];
    
    [self layoutUI];
}

- (void)refreshPlayBtnImage {
    if ([ZLPlayingManager sharedPlayingManager].isPlaying) {
        UIImage *imgNormal = [UIImage imageNamed:@"ic_pause"];
        imgNormal = [imgNormal scaleToSize:CGSizeMake(50, 50)];
        
        [_btnPlay setImage:imgNormal forState:UIControlStateNormal];
        [_btnPlay setImage:imgNormal forState:UIControlStateHighlighted];
    } else {
        UIImage *imgNormal = [UIImage imageNamed:@"ic_play"];
        imgNormal = [imgNormal scaleToSize:CGSizeMake(50, 50)];
        
        [_btnPlay setImage:imgNormal forState:UIControlStateNormal];
        [_btnPlay setImage:imgNormal forState:UIControlStateHighlighted];
    }
}

- (void)refreshPlayingProgress:(float)playTime {
    _lbProgress.text = [self timeFormatted:playTime];
    if (_shouldRefreshProgress) {
         _playSlider.value = [[ZLPlayingManager sharedPlayingManager] getProgressByPlayTime:playTime];
    }
}

- (void)refreshLoadingProgress:(float)progress {
    _progressView.progress = progress;
}

- (void)restoreInfoView {
    _progressView.progress = 0;
    _playSlider.value = 0;
    _lbProgress.text = @"00:00";
    [ZLPlayingManager sharedPlayingManager].isPlaying = true;
    [self refreshPlayBtnImage];
}

//转换成时分秒
- (NSString *)timeFormatted:(int)totalSeconds
{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    
    return [NSString stringWithFormat:@"%02d:%02d",minutes, seconds];
}


#pragma mark - 动画
- (void)checkStartCoverAnimation {
    if ([ZLPlayingManager sharedPlayingManager].isPlaying) {
        [self stopCoverAnimation];
        CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithDouble:M_PI * 2];
        rotationAnimation.duration = 5.0;
        rotationAnimation.cumulative = YES;
        rotationAnimation.repeatCount = ULLONG_MAX;
        [_imgCover.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    }
}

- (void)stopCoverAnimation {
    [_imgCover.layer removeAllAnimations];
}
#pragma mark - event

- (void)detectSwitchSong:(NSNotification *)notif {
    [self restoreInfoView];
    ZLSongModel *curSong = [ZLPlayingManager sharedPlayingManager].curPlayingSong;
    [self refreshViewWithModel:curSong];
}

- (void)playPreSong {
    [[ZLPlayingManager sharedPlayingManager] playPreSong];
}

- (void)playNextSong {
    [[ZLPlayingManager sharedPlayingManager] playNextSong];
}

- (void)playOrPause{
    if (![ZLPlayingManager sharedPlayingManager].isPlaying) {
        //play
        [[ZLPlayingManager sharedPlayingManager] continuePlaying];
        [ZLPlayingManager sharedPlayingManager].isPlaying = true;
    }else{
        //pause
        [[ZLPlayingManager sharedPlayingManager] pause];
        [ZLPlayingManager sharedPlayingManager].isPlaying = false;
        [self stopCoverAnimation];
    }
    
    [self refreshPlayBtnImage];
}

- (void)playSliderValueChange:(UISlider *)sender {
    _shouldRefreshProgress = false;
    float value = sender.value;
    [[ZLPlayingManager sharedPlayingManager] seekToTime:value];
}

- (void)playSliderDidEndValueChange:(UISlider *)sender {
    _shouldRefreshProgress = true;
}

- (void)foldInfoView {
//    [[ZLPlayingManager sharedPlayingManager] stop];
    [self.baseController dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - setter
- (UIImageView *)blurView {
    if (!_blurView) {
        CGRect frame = self.bounds;
//        frame.size.height -= STATUS_BAR_HEIGHT;
//        frame.origin.y += STATUS_BAR_HEIGHT;
        _blurView = [[UIImageView alloc] initWithFrame:frame];
        _blurView.image = [UIImage imageNamed:@"bg_test"];
    }
    return _blurView;
}

- (UIImageView *)bgView {
    if (!_bgView) {
        CGRect frame = self.bounds;
//        frame.size.height -= STATUS_BAR_HEIGHT;
//        frame.origin.y += STATUS_BAR_HEIGHT;
        _bgView = [[UIImageView alloc] initWithFrame:frame];
        _bgView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.9];
    }
    return _bgView;
}

- (UIButton *)btnFold {
    if (!_btnFold) {
        _btnFold = [UIButton new];
        UIImage *foldImg = [UIImage imageNamed:@"ic_fold"];
        foldImg = [foldImg scaleToSize:CGSizeMake(20, 20)];
        [_btnFold setImage:foldImg forState:UIControlStateNormal];
        
        [_btnFold addTarget:self action:@selector(foldInfoView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnFold;
}
- (UIImageView *)imgCover {
    if (!_imgCover) {
        _imgCover = [UIImageView new];
        _imgCover.layer.cornerRadius = COVER_SIZE/2;
        _imgCover.layer.masksToBounds = YES;
    }
    return _imgCover;
}

- (MarqueeLabel *)lbSongName {
    if (!_lbSongName) {
        CGFloat labelWidth = 300;
        CGFloat lableHeight = 45;
        CGFloat originX = (SCREEN_WIDTH - labelWidth)/2.0;
        CGFloat originY = 70 ;
        _lbSongName = [[MarqueeLabel alloc] initWithFrame:CGRectMake(originX, originY, labelWidth, lableHeight)
                                                 duration:7.0 andFadeLength:20.0];
        _lbSongName.textColor = [UIColor whiteColor];
        _lbSongName.textAlignment = NSTextAlignmentCenter;
        _lbSongName.font = [UIFont systemFontOfSize:20];
    }
    return _lbSongName;
}
- (UILabel *)lbSinger {
    if (!_lbSinger) {
        _lbSinger = [UILabel new];
        _lbSinger.textColor = [UIColor whiteColor];
        _lbSinger.font = [UIFont systemFontOfSize:14];
    }
    return _lbSinger;
}
- (UILabel *)lbDuration {
    if (!_lbDuration) {
        _lbDuration = [UILabel new];
        _lbDuration.textColor = [UIColor whiteColor];
        _lbDuration.font = [UIFont systemFontOfSize:12];
    }
    return _lbDuration;
}
- (UILabel *)lbProgress {
    if (!_lbProgress) {
        _lbProgress = [UILabel new];
        _lbProgress.textColor = [UIColor whiteColor];
        _lbProgress.font = [UIFont systemFontOfSize:12];
        _lbProgress.text = @"00:00";
    }
    return _lbProgress;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [UIProgressView new];
        _progressView.tintColor = [UIColor grayColor];
        _progressView.trackTintColor = [UIColor whiteColor];
//        _progressView.progress = 0.5;
    }
    return _progressView;
}

- (UISlider *)playSlider {
    if (!_playSlider) {
        _playSlider = [UISlider new];
        _playSlider.minimumValue = 0.0;
        _playSlider.maximumValue = 1.0;
//        _playSlider.value = 0.2;
        _playSlider.minimumTrackTintColor = [UIColor greenThemeColor];
        _playSlider.thumbTintColor = [UIColor greenThemeColor];
        _playSlider.maximumTrackTintColor = [UIColor clearColor];
        [_playSlider addTarget:self action:@selector(playSliderValueChange:) forControlEvents:UIControlEventValueChanged];
        [_playSlider addTarget:self action:@selector(playSliderDidEndValueChange:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playSlider;
}
- (UIButton *)btnPre {
    if (!_btnPre) {
        _btnPre = [UIButton new];
        _btnPre.selected = YES;
        UIImage *imgNormal = [UIImage imageNamed:@"ic_play_pre"];
        imgNormal = [imgNormal scaleToSize:CGSizeMake(50, 50)];
        
        [_btnPre setImage:imgNormal forState:UIControlStateNormal];
        [_btnPre setImage:imgNormal forState:UIControlStateHighlighted];
        
        [_btnPre addTarget:self action:@selector(playPreSong) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnPre;
}
- (UIButton *)btnPlay {
    if (!_btnPlay) {
        _btnPlay = [UIButton new];
        _btnPlay.selected = YES;
        [_btnPlay addTarget:self action:@selector(playOrPause) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnPlay;
}
- (UIButton *)btnNext {
    if (!_btnNext) {
        _btnNext = [UIButton new];
        _btnNext.selected = YES;
        UIImage *imgNormal = [UIImage imageNamed:@"ic_play_next"];
        imgNormal = [imgNormal scaleToSize:CGSizeMake(50, 50)];
        
        [_btnNext setImage:imgNormal forState:UIControlStateNormal];
        [_btnNext setImage:imgNormal forState:UIControlStateHighlighted];
        [_btnNext addTarget:self action:@selector(playNextSong) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnNext;
}
@end
