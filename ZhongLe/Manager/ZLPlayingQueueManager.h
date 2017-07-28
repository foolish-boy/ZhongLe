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


@interface ZLPlayingQueueManager : NSObject

+ (ZLPlayingQueueManager *)sharedQueueManager;

#pragma mark - 曲库歌曲缓存

/**
 添加歌曲 存入内存中

 @param song 歌曲model
 */
- (void)addSong:(ZLSongModel *)song;


/**
 批量添加歌曲

 @param songArr 歌曲数组
 */
- (void)addSongs:(NSArray *)songArr;


/**
 送缓存中删除歌曲

 @param songId 歌曲ID
 */
- (void)removeSong:(NSString *)songId;


/**
 清空缓存所有歌曲
 */
- (void)clearSongs;


/**
 根据歌曲ID获取歌曲信息

 @param songId 歌曲ID
 @return 歌曲Model
 */
- (ZLSongModel*)getSongById:(NSString *)songId;


/**
 返回所有曲库中的歌曲

 @return 所有曲库的歌曲model
 */
- (NSArray *)getSongList;


/**
 songId对应的歌曲在曲库中的位置索引

 @param songId 歌曲ID
 @return 位置
 */
- (int)indexOfSong:(NSString *)songId;

/**
 返回曲库中特定位置的歌曲ID

 @param index 位置
 @return 歌曲ID
 */
- (NSString *)songIdAtIndex:(NSUInteger)index;

/**
 加载所有的曲库歌曲
 */
- (void)loadAllSongsFromPlist;


/**
 获得上一首歌的ID

 @return 上一首歌的ID
 */
- (NSString *)getPreSongId;

/**
 获得下一首歌的ID
 
 @return 下一首歌的ID
 */
- (NSString *)getNextSongId;

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


#pragma mark - 下载歌曲缓存

/**
 获得所有下载的歌曲

 @return 下载的歌曲列表
 */
- (NSArray *)getDownLoadedSongList;

/**
 获得下载歌曲列表中指定位置的歌曲ID

 @param index 索引
 @return 歌曲ID
 */
- (NSString *)downLoadedSongIdAtIndex:(NSUInteger)index;
@end
