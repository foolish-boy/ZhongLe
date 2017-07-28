//
//  ZLPlayingQueueManager.m
//  ZhongLe
//
//  Created by jasonwu on 2017/7/7.
//  Copyright © 2017年 jasonwu. All rights reserved.
//

#import "ZLPlayingQueueManager.h"
#import "ZLSongModel.h"
#import "ZLPlayingManager.h"
#import "ZLDownLoadManager.h"

@interface ZLPlayingQueueManager ()

@property (nonatomic, strong) NSMutableArray        *songIds;//原始列表，与UI展示一致
@property (nonatomic, strong) NSMutableArray        *orderedSongIds;//排序后的列表 用来控制播放次序
@property (nonatomic, strong) NSMutableDictionary   *mapSongs;
@property (nonatomic, strong) dispatch_queue_t      playQueue;
@property (nonatomic, assign) PlayingOrderType      playOrder;

@end


@implementation ZLPlayingQueueManager

+ (ZLPlayingQueueManager *)sharedQueueManager {
    static ZLPlayingQueueManager *singleton = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc] init];
    });
    return singleton;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _mapSongs = [NSMutableDictionary new];
        _songIds  = [NSMutableArray new];
        _orderedSongIds = [NSMutableArray new];
        _playQueue = dispatch_queue_create("com.zhongle.palyingqueuemanager", DISPATCH_QUEUE_SERIAL);
        _playOrder = PlayingOrderSequence;
    }
    return self;
}

- (void)initPlayOrder {
    
    NSNumber *order = [[NSUserDefaults standardUserDefaults] objectForKey:@"playOrder"];
    if (order) {
        self.playOrder = order.intValue;
    }
    [self playOrderCase];
}

//- (void)addSong:(NSString *)songPath {
//    if (!songPath) {
//        return;
//    }
//    dispatch_async(_playQueue, ^{
//        ZLSongModel *song = [[ZLSongModel alloc] initWithSongPath:songPath];
//        if (song && ![_mapSongs valueForKey:song.songId]) {
//            [_mapSongs setObject:song forKey:song.songId];
//        }
//    });
//}

- (void)addSong:(ZLSongModel *)song {
    if (!song) {
        return;
    }
    if (![self.mapSongs valueForKey:song.songId]) {
        [self.songIds addObject:song.songId];
        [self.orderedSongIds addObject:song.songId];
        [self.mapSongs setObject:song forKey:song.songId];
    }
    
}
- (void)addSongs:(NSArray *)songArr {
    if (!songArr || songArr.count == 0) {
        return;
    }
//    dispatch_async(_playQueue, ^{
        for (id song in songArr) {
            if ([song  isKindOfClass:[ZLSongModel class]]) {
                [self addSong:song];
            }
        }
//    });
}

- (void)removeSong:(NSString *)songId {
    if (!songId) {
        return;
    }
//    dispatch_async(_playQueue, ^{
        if ([self.mapSongs valueForKey:songId]) {
            [self.songIds removeObject:songId];
            [self.orderedSongIds removeObject:songId];
            [self.mapSongs removeObjectForKey:songId];
        }
//    });
}

- (void)clearSongs {
//    dispatch_async(_playQueue, ^{
        [self.songIds removeAllObjects];
        [self.orderedSongIds removeAllObjects];
        [self.mapSongs removeAllObjects];
//    });
}

- (ZLSongModel *)getSongById:(NSString *)songId {
    if (!songId) {
        return nil;
    }
    if ([self.mapSongs valueForKey:songId]) {
        return [self.mapSongs valueForKey:songId];
    }
    return nil;
}

- (NSArray *)getSongList {
    //dictionary无序 array有序
    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:[self.songIds count]];
    for (int i = 0; i < self.songIds.count; i ++) {
        NSString *songId = [self.songIds objectAtIndex:i];
        ZLSongModel *model = [_mapSongs valueForKey:songId];
        if (model) {
            [arr addObject:model];
        }
    }
    return arr;
}

- (NSArray *)getDownLoadedSongList {
    //dictionary无序 array有序
    NSArray *songIdList = [[ZLDownLoadManager sharedDownLoad] getDownLoadedSongIdList];
    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:[songIdList count]];
    for (int i = 0; i < songIdList.count; i ++) {
        NSString *songId = [songIdList objectAtIndex:i];
        ZLSongModel *model = [_mapSongs valueForKey:songId];
        if (model) {
           [arr addObject:model];
        }
    }
    return arr;
}

- (void)loadAllSongsFromPlist {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"DemoSongs" ofType:@"plist"];
    NSArray *songsLit = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    for (NSDictionary *songInfo in songsLit) {
        ZLSongModel *model = [[ZLSongModel alloc] initWithDic:songInfo];
        [self addSong:model];
    }
    [self initPlayOrder];
}

- (int)indexOfSong:(NSString *)songId {
    return [self.orderedSongIds indexOfObject:songId];
}

- (NSString *)songIdAtIndex:(NSUInteger)index {
    if (index >= 0 && index < [self.songIds count]) {
        return [self.songIds objectAtIndex:index];
    }
    return nil;
}

- (NSString *)downLoadedSongIdAtIndex:(NSUInteger)index {
    NSArray *arr = [[ZLDownLoadManager sharedDownLoad] getDownLoadedSongIdList];
    if (index >= 0 && index < arr.count) {
        return [arr objectAtIndex:index];
    }
    return nil;
}

- (NSString *)getPreSongId {
    NSString *preId = [self.orderedSongIds firstObject];
    ZLSongModel *playingSong = [ZLPlayingManager sharedPlayingManager].curPlayingSong;
    if (playingSong) {
        int index = [self indexOfSong:playingSong.songId];
        int preIndex = index - 1;
        if (preIndex < 0) {
            preIndex = self.orderedSongIds.count - 1;
        }
        preId = [self.orderedSongIds objectAtIndex:preIndex];
    }
    return preId;
}

- (NSString *)getNextSongId {
    NSString *nextId = [self.orderedSongIds firstObject];
    ZLSongModel *playingSong = [ZLPlayingManager sharedPlayingManager].curPlayingSong;
    if (playingSong) {
        NSUInteger index = [self indexOfSong:playingSong.songId];
        NSUInteger nextIndex = (index + 1) % self.orderedSongIds.count;
        nextId = [self.orderedSongIds objectAtIndex:nextIndex];
    }
    return nextId;
}

#pragma mark - 播放次序控制

- (void)playOrderCase {
    switch (self.playOrder) {
        case PlayingOrderSequence:
            [self switchToSequenceOrder];
            break;
        case PlayingOrderRandom:
            [self switchToRandomOrder];
            break;
        case PlayingOrderLoop:
            [self switchToLoopOrder];
            break;
        default:
            break;
    }
}

- (void)switchPlayOrder {
    self.playOrder = (self.playOrder + 1) % PlayingOrderNum;
    [self playOrderCase];
}

- (void)switchToSequenceOrder {
    self.playOrder = PlayingOrderSequence;
    
    [self.orderedSongIds removeAllObjects];
    [self.orderedSongIds addObjectsFromArray:self.songIds];
}

- (void)switchToRandomOrder {
    self.playOrder = PlayingOrderRandom;
    //先恢复初始顺序
    [self.orderedSongIds removeAllObjects];
    [self.orderedSongIds addObjectsFromArray:self.songIds];
    //产生随机数组
    int repeatNum = self.orderedSongIds.count - 1;
    for (int i = 0; i < repeatNum; i ++) {
        int dataNum = self.orderedSongIds.count - i - 1;
        int randomIndex = arc4random() % dataNum;
        int lastIndex = dataNum;
        [self.orderedSongIds exchangeObjectAtIndex:randomIndex withObjectAtIndex:lastIndex];
        
    }
    
}

- (void)switchToLoopOrder {
    self.playOrder = PlayingOrderLoop;
}

- (void)savePlayOrder {
    [[NSUserDefaults standardUserDefaults] setObject:@(self.playOrder) forKey:@"playOrder"];
}

- (PlayingOrderType)getCurrentPlayOrder {
    return self.playOrder;
}

- (BOOL)isLoopOrder {
    return self.playOrder == PlayingOrderLoop;
}
@end
