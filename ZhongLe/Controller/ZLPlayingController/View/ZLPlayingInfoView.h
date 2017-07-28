//
//  ZLPlayingInfoView.h
//  ZhongLe
//
//  Created by jasonwu on 2017/7/12.
//  Copyright © 2017年 jasonwu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZLSongModel;

@interface ZLPlayingInfoView : UIView

@property (nonatomic, weak) UIViewController *baseController;

- (void)refreshViewWithModel:(ZLSongModel *)model;
- (void)refreshPlayingProgress:(float)playTime;
- (void)refreshLoadingProgress:(float)progress;

- (void)checkStartCoverAnimation;
@end
