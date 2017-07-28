//
//  ZLSongListCell.h
//  ZhongLe
//
//  Created by jasonwu on 2017/7/12.
//  Copyright © 2017年 jasonwu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SongListCellHeight 48

@class ZLSongModel;

@interface ZLSongListCell : UITableViewCell

@property (nonatomic, strong) ZLSongModel *curModel;

- (void)setWithSongModel:(ZLSongModel *)model rowIndex:(int)index;

- (void)showAnimationView;
- (void)hideAnimationView;

- (void)startPlayingAnimation;
- (void)stopPlayingAnimation;
@end
