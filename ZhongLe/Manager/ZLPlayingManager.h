//
//  ZLPlayingManager.h
//  ZhongLe
//
//  Created by jasonwu on 2017/7/7.
//  Copyright © 2017年 jasonwu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZLSongModel;

typedef void(^playProgressBlock)(float curPlayTime);
typedef void(^loadProgressBlock)(float loadProgress);

@interface ZLPlayingManager : NSObject

+ (ZLPlayingManager *)sharedPlayingManager;

@property (nonatomic, strong) ZLSongModel   *curPlayingSong;
@property (nonatomic, assign) BOOL          isPlaying;
@property (nonatomic, assign) float         curLoadingScale;
@property (nonatomic, assign) float         curPlayingTime;

- (void)playSong:(NSString *)songId loadProgress:(loadProgressBlock)loadProgress
                                    playProgress:(playProgressBlock)playProgress;

- (void)playPreSong;

- (void)playNextSong;

- (void)continuePlaying;
- (void)pause;
- (void)stop;
- (void)playAll;

- (float)getProgressByPlayTime:(float)playTime;

- (void)seekToTime:(float)timeValue;

- (void)saveCurSong;

@end
