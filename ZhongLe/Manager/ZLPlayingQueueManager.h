//
//  ZLPlayingQueueManager.h
//  ZhongLe
//
//  Created by jasonwu on 2017/7/7.
//  Copyright © 2017年 jasonwu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZLSongModel;

//播放顺序
typedef enum : NSUInteger{
    PlayingOrderSequence = 0,//顺序播放
    PlayingOrderLoop, //单曲循环
    PlayingOrderRandom,//随机播放
    PlayingOrderNum
} PlayingOrderType;

//数据来源 用来配置循环播放列表
typedef enum : NSUInteger {
    SongDataSourceAll = 0,//曲库
    SongDataSourceDownload
} SongDataSource;

@interface ZLPlayingQueueManager : NSObject

+ (ZLPlayingQueueManager *)sharedQueueManager;

@property (nonatomic, assign) SongDataSource dataSource;

#pragma mark - 曲库歌曲缓存

/**
 返回所有曲库中的歌曲

 @return 所有曲库的歌曲model
 */
- (NSArray *)getSongList;


/**
 对应的歌曲在播放列表的位置索引 用来定位上一首 下一首

 @param song 歌曲
 @return 位置
 */
- (int)indexOfSong:(ZLSongModel *)song;

/**
 获取指定位置的歌曲

 @param index 位置
 @return 歌曲
 */
- (ZLSongModel *)songOfIndex:(int)index;

/**
 加载所有的曲库歌曲
 */
- (void)loadAllSongsFromPlist;

/**
 添加歌曲

 @param songs 歌曲
 */
- (void)addSongs:(NSArray *)songs;

/**
 获得上一首歌的

 @return 上一首歌
 */
- (ZLSongModel *)getPreSong;

/**
 获得下一首歌
 
 @return 下一首歌
 */
- (ZLSongModel *)getNextSong;

#pragma mark - 播放顺序控制

/**
 切换下一中播放顺序模式
 */
- (void)switchPlayOrder;

/**
 获得当前的播放顺序模式

 @return 播放顺序模式
 */
- (PlayingOrderType)getCurrentPlayOrder;

/**
 是否是单曲循环模式

 @return true: 单曲循环 false： 非单曲循环
 */
- (BOOL)isLoopOrder;

/**
 最后保存当前播放顺序模式到本地 下次启动时读取
 */
- (void)savePlayOrder;

@end
