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

- (void)downLoadTask:(ZLSongModel *)requestSong;

- (BOOL)hasDownLoaded:(ZLSongModel *)requestSong;
- (NSURL *)getDownLoadedUrl:(ZLSongModel *)requestSong;
- (NSArray *)getDownLoadedSongIdList;

- (void)removeSong:(NSString *)songId;
- (void)clearSongs;

- (void)addToDownLoadQueue:(ZLSongModel *)song;
- (void)removeFromDownLoadQueue:(ZLSongModel *)song;
- (void)downLoadAll;
@end
