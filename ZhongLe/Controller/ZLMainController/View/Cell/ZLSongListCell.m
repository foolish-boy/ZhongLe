//
//  ZLSongListCell.m
//  ZhongLe
//
//  Created by jasonwu on 2017/7/12.
//  Copyright © 2017年 jasonwu. All rights reserved.
//

#import "ZLSongListCell.h"
#import "UIImageView+WebCache.h"
#import "ZLSongModel.h"
#import "Masonry.h"
#import "ZLDefine.h"
#import "ZLPlayingAnimationView.h"

static const int coverSize = 36;
static const int animationViewWith = 14;
static const int animationViewHeight = 20;

@interface ZLSongListCell ()

@property (nonatomic, strong) UILabel     *lbIndex;
@property (nonatomic, strong) UIImageView *imgCover;
@property (nonatomic, strong) UILabel     *lbSongName;
@property (nonatomic, strong) UILabel     *lbSinger;
@property (nonatomic, strong) ZLPlayingAnimationView *animationView;

@end

@implementation ZLSongListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.lbIndex];
        [self.contentView addSubview:self.imgCover];
        [self.contentView addSubview:self.lbSinger];
        [self.contentView addSubview:self.lbSongName];
        [self.contentView addSubview:self.animationView];
        [self hideAnimationView];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
//        [self addGestureRecognizer:longPress];
    }
    return self;
}

- (void)setWithSongModel:(ZLSongModel *)model rowIndex:(int)index {
    self.lbIndex.text    = [NSString stringWithFormat:@"%d",index];
    self.lbSongName.text = model.songName;
//    if ([[ZLNetworkTask sharedTask] hasDownLoaded:model.songUrl]) {
//        self.lbSongName.text = [NSString stringWithFormat:@"%@(已下载)", model.songName];
//    }
    self.lbSinger.text   = model.singer;
    self.curModel        = model;
    
    [self.imgCover sd_setImageWithURL:[NSURL URLWithString:model.albumUrl] placeholderImage:nil];
    
    CGFloat margin = 15;
    CGSize indexSize = [self.lbIndex sizeThatFits:CGSizeZero];
    [self.lbIndex mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.leading.equalTo(self.contentView).offset(margin);
        make.size.mas_equalTo(indexSize);
    }];
    
    [self.imgCover mas_updateConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.lbIndex.mas_trailing).offset(margin);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(coverSize, coverSize));
    }];
    
    CGFloat maxWidth = SCREEN_WIDTH - margin - indexSize.width - margin - coverSize - margin - 40;
    CGSize nameSize = [self.lbSongName sizeThatFits:CGSizeMake(maxWidth, MAXFLOAT)];
    if (nameSize.width > maxWidth) {
        nameSize.width = maxWidth;
    }
    [self.lbSongName mas_updateConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.imgCover.mas_trailing).offset(margin);
        make.top.equalTo(self.contentView).offset(4);
        make.size.mas_equalTo(nameSize);
    }];
    
    CGSize singerSize = [self.lbSinger sizeThatFits:CGSizeMake(maxWidth, MAXFLOAT)];
    if (singerSize.width > maxWidth) {
        singerSize.width = maxWidth;
    }
    [self.lbSinger mas_updateConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.imgCover.mas_trailing).offset(margin);
        make.bottom.equalTo(self.contentView).offset(-4);
        make.size.mas_equalTo(singerSize);
    }];
    
    [self.animationView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.contentView).offset(-5);
        make.bottom.equalTo(self.contentView).offset(-3);
        make.size.mas_equalTo(CGSizeMake(animationViewWith, animationViewHeight));
    }];

    [self setNeedsLayout];
}


- (void)longPressAction:(UILongPressGestureRecognizer *)ges {
    [[NSNotificationCenter defaultCenter] postNotificationName:Notif_LongPressSongListCell object:self.curModel];
}


- (void)showAnimationView {
    self.animationView.hidden = false;
    self.lbSongName.textColor = [UIColor redColor];
}

- (void)hideAnimationView {
    _animationView.hidden = true;
    self.lbSongName.textColor = [UIColor blackColor];
}

- (void)startPlayingAnimation {
    [_animationView stopAnimation];
    [_animationView startAnimation];
}
- (void)stopPlayingAnimation {
    [_animationView stopAnimation];
}

#pragma mark - setter

- (UILabel *)lbIndex {
    if (!_lbIndex) {
        _lbIndex = [UILabel new];
        _lbIndex.font = [UIFont boldSystemFontOfSize:13];
//        _lbIndex.lineBreakMode = NSLineBreakByTruncatingTail;
        _lbIndex.textColor = [UIColor grayColor];
        _lbIndex.textAlignment = NSTextAlignmentCenter;
    }
    return _lbIndex;
}

- (UIImageView *)imgCover {
    if (!_imgCover) {
        _imgCover = [UIImageView new];
        _imgCover.layer.cornerRadius = coverSize/2;
        _imgCover.layer.masksToBounds = YES;
    }
    return _imgCover;
}

- (UILabel *)lbSongName {
    if (!_lbSongName) {
        _lbSongName = [UILabel new];
        _lbSongName.font = [UIFont boldSystemFontOfSize:16];
        _lbSongName.lineBreakMode = NSLineBreakByTruncatingTail;
        _lbSongName.textColor = [UIColor blackColor];
    }
    return _lbSongName;
}

- (UILabel *)lbSinger {
    if (!_lbSinger) {
        _lbSinger = [UILabel new];
        _lbSinger.font = [UIFont systemFontOfSize:12];
        _lbSinger.lineBreakMode = NSLineBreakByTruncatingTail;
        _lbSinger.textColor = [UIColor grayColor];
    }
    return _lbSinger;
}

- (ZLPlayingAnimationView *)animationView {
    if (!_animationView) {
        _animationView = [[ZLPlayingAnimationView alloc] initWithFrame:CGRectMake(0, 0, animationViewWith, animationViewHeight)];
    }
    return _animationView;
}

@end
