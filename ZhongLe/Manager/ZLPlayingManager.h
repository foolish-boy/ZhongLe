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

@property (nonatomic, strong) ZLSongModel   *curPlayingSong;//当前正在播放的歌曲
@property (nonatomic, assign) BOOL          isPlaying;//当前是否在播放
@property (nonatomic, assign) float         curLoadingScale;//当前歌曲的加载进度
@property (nonatomic, assign) float         curPlayingTime;//当前歌曲的播放进度

/**
 准备播放歌曲

 @param song 歌曲
 @param loadProgress 加载进度回调
 @param playProgress 播放进度回调
 */
- (void)playSong:(ZLSongModel *)song loadProgress:(loadProgressBlock)loadProgress
                                    playProgress:(playProgressBlock)playProgress;


/**
 播放上一首
 */
- (void)playPreSong;
/**
 播放下一首
 */

- (void)playNextSong;

/**
 继续播放暂停的歌曲
 */
- (void)continuePlaying;

/**
 暂停播放
 */
- (void)pause;

/**
 停止播放
 */
- (void)stop;


/**
 根据播放的时长计算播放进度

 @param playTime 播放时长
 @return 播放进度 0～1
 */
- (float)getProgressByPlayTime:(float)playTime;

/**
 快进／快退

 @param timeValue 目标事件值
 */
- (void)seekToTime:(float)timeValue;

@end
