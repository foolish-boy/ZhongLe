//
//  ZLPlayingStatusView.m
//  ZhongLe
//
//  Created by jasonwu on 2017/7/13.
//  Copyright © 2017年 jasonwu. All rights reserved.
//

#import "ZLPlayingStatusView.h"
#import "ZLPlayingAnimationView.h"
#import "ZLPlayingManager.h"
#import "ZLPlayingQueueManager.h"
#import "UIImageEX.h"
#import "Masonry.h"
#import "ZLDefine.h"
#import "MarqueeLabel.h"
#import "ZLSongModel.h"

static const int animationViewWith = 14;
static const int animationViewHeight = 20;
static const int btnPlaySize = 60;
static const int btnOrderSize = 30;
static const NSString *strStatusPrefix = @"当前正在播放: ";

@interface ZLPlayingStatusView ()

@property (nonatomic, strong) ZLPlayingAnimationView *animationView;
@property (nonatomic, strong) MarqueeLabel           *lbSongDesc;
@property (nonatomic, strong) UIButton               *btnPlay;
@property (nonatomic, strong) UIButton               *btnOrder;

@end
@implementation ZLPlayingStatusView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        [self addSubview:self.btnOrder];
        [self addSubview:self.animationView];
        [self addSubview:self.lbSongDesc];
        [self addSubview:self.btnPlay];
        
        [self refreshView];
        [self refreshOrderBtnImg];
        [self layoutUI];
    }
    return self;
}

- (void)layoutUI {
    CGFloat margin = 10;
    
    [self.animationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(margin);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(animationViewWith, animationViewHeight));
    }];
    
    [self.btnOrder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.animationView.mas_trailing).offset(margin);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(btnOrderSize, btnOrderSize));
    }];
    
    [self.btnPlay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-margin);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(btnPlaySize, btnPlaySize));
    }];
    
    CGFloat labelWidth = 200;
    CGFloat lableHeight = 45;
    CGFloat originX = (self.frame.size.width - labelWidth)/2.0;
    CGFloat originY = (self.frame.size.height - lableHeight)/2.0 ;
    self.lbSongDesc.frame = CGRectMake(originX, originY, labelWidth, lableHeight);
    
    [self setNeedsLayout];
}


#pragma mark - 刷新UI
- (void)refreshView {
    NSString *defautSongName = @"独乐乐不如众乐乐";
    self.lbSongDesc.text = defautSongName;
    
    ZLSongModel *curSong = [ZLPlayingManager sharedPlayingManager].curPlayingSong;
    if (curSong) {
        self.lbSongDesc.text = [NSString stringWithFormat:@"%@%@-%@",strStatusPrefix,curSong.songName,curSong.singer];
    }
    if ([ZLPlayingManager sharedPlayingManager].isPlaying) {
        [self startAnimation];
    } else {
        [self stopAnimation];
    }
    
    [self refreshPlayBtnImage];
    [self layoutUI];
}

- (void)refreshPlayBtnImage {
    if ([ZLPlayingManager sharedPlayingManager].curPlayingSong) {
        self.btnPlay.enabled = true;
    } else {
        self.btnPlay.enabled = false;
    }
    
    if ([ZLPlayingManager sharedPlayingManager].isPlaying) {
        UIImage *imgNormal = [UIImage imageNamed:@"ic_pause"];
        imgNormal = [imgNormal scaleToSize:CGSizeMake(40, 40)];
        
        [_btnPlay setImage:imgNormal forState:UIControlStateNormal];
        [_btnPlay setImage:imgNormal forState:UIControlStateHighlighted];
    } else {
        UIImage *imgNormal = [UIImage imageNamed:@"ic_play"];
        imgNormal = [imgNormal scaleToSize:CGSizeMake(40, 40)];
        
        [_btnPlay setImage:imgNormal forState:UIControlStateNormal];
        [_btnPlay setImage:imgNormal forState:UIControlStateHighlighted];
    }
}

- (void)refreshOrderBtnImg {
    PlayingOrderType curOrder = [[ZLPlayingQueueManager sharedQueueManager] getCurrentPlayOrder];
    UIImage *img = nil;
    switch (curOrder) {
        case PlayingOrderSequence:
            img = [UIImage imageNamed:@"ic_order_sequence"];
            break;
        case PlayingOrderRandom:
            img = [UIImage imageNamed:@"ic_order_random"];
            break;
        case PlayingOrderLoop:
            img = [UIImage imageNamed:@"ic_order_loop"];
            break;
        default:
            break;
    }
    [self.btnOrder setImage:[img scaleToSize:CGSizeMake(20, 20)] forState:UIControlStateNormal];
}

#pragma mark - 动画
- (void)startAnimation {
    [self stopAnimation];
    [self.animationView startAnimation];
    [self.lbSongDesc unpauseLabel];
//    [self.lbSongDesc restartLabel];

}

- (void)stopAnimation {
    [self.animationView stopAnimation];
    [self.lbSongDesc pauseLabel];
//    [self.lbSongDesc shutdownLabel];
}

#pragma mark - event
- (void)playOrPause{
    if (![ZLPlayingManager sharedPlayingManager].isPlaying) {
        //play
        [[ZLPlayingManager sharedPlayingManager] continuePlaying];
        [ZLPlayingManager sharedPlayingManager].isPlaying = true;
//        [self startCoverAnimation];
    }else{
        //pause
        [[ZLPlayingManager sharedPlayingManager] pause];
        [ZLPlayingManager sharedPlayingManager].isPlaying = false;
//        [self stopCoverAnimation];
    }
}

- (void)switchPlayOrder {
    [[ZLPlayingQueueManager sharedQueueManager] switchPlayOrder];
    [self refreshOrderBtnImg];
}

#pragma mark - lazy load

- (ZLPlayingAnimationView *)animationView {
    if (!_animationView) {
        _animationView = [[ZLPlayingAnimationView alloc] initWithFrame:CGRectMake(0, 0, animationViewWith, animationViewHeight)];
    }
    return _animationView;
}

- (UILabel *)lbSongDesc {
    if (!_lbSongDesc) {
        _lbSongDesc = [[MarqueeLabel alloc] initWithFrame:CGRectZero
                                                 duration:2.0 andFadeLength:20.0];
        _lbSongDesc.rate = 15;
        _lbSongDesc.textAlignment = NSTextAlignmentCenter;
        _lbSongDesc.textColor = [UIColor whiteColor];
        _lbSongDesc.font = [UIFont systemFontOfSize:18];
    }
    return _lbSongDesc;
}

- (UIButton *)btnPlay {
    if (!_btnPlay) {
        _btnPlay = [UIButton new];
        _btnPlay.selected = YES;
        [_btnPlay addTarget:self action:@selector(playOrPause) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnPlay;
}

- (UIButton *)btnOrder {
    if (!_btnOrder) {
        _btnOrder = [UIButton new];
        [_btnOrder addTarget:self action:@selector(switchPlayOrder) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnOrder;
}
@end
