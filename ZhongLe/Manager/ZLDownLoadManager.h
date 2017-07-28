//
//  ZLDownLoadManager.h
//  ZhongLe
//
//  Created by jasonwu on 2017/7/26.
//  Copyright © 2017年 jasonwu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZLSongModel;

@interface ZLDownLoadManager : NSObject

+ (ZLDownLoadManager *)sharedDownLoad;

/**
 添加歌曲到下载队列

 @param song 下载的歌曲
 */
- (void)addToDownLoadQueue:(ZLSongModel *)song;

/**
 从下载队列中删除歌曲

 @param song 歌曲
 */
- (void)removeFromDownLoadQueue:(ZLSongModel *)song;


/**
 开始下载单曲

 @param requestSong 下载的歌曲
 */
- (void)startDownLoad:(ZLSongModel *)requestSong;

/**
 下载所有选中的歌曲
 */
- (void)downLoadAll;

/**
 判断歌曲是否已经下载过

 @param requestSong 歌曲
 @return true: 已经下载 false:未下载
 */
- (BOOL)hasDownLoaded:(ZLSongModel *)requestSong;

/**
 返回歌曲的下载地址，网络地址／本地地址

 @param requestSong 歌曲
 @return 如果歌曲已经下载过 返回本地地址，否则原样返回网络地址
 */
- (NSURL *)getDownLoadedUrl:(ZLSongModel *)requestSong;

/**
 加载下载的歌曲列表
 */
- (void)loadDownLoadedSongs;
/**
 返回下载的歌曲列表

 @return 下载的歌曲列表
 */
- (NSArray *)getDownLoadedSongList;

/**
 删除下载的歌曲

 @param song 歌曲
 */
- (void)removeSong:(ZLSongModel *)song;


/**
 清空所有下载的歌曲
 */
- (void)clearSongs;

/**
 获取指定位置的歌曲
 
 @param index 位置
 @return 歌曲
 */
- (ZLSongModel *)songOfIndex:(int)index;


@end
