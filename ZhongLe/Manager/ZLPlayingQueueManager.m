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

@property (nonatomic, strong) NSMutableArray        *allSongList;//曲库歌曲列表

@property (nonatomic, strong) NSMutableArray        *orderedSongList;//排序后的列表 用来控制播放次序

@property (nonatomic, assign) PlayingOrderType      playOrder;

@end


@implementation ZLPlayingQueueManager

@synthesize dataSource = _dataSource;

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
        _allSongList        = [NSMutableArray new];
        _orderedSongList = [NSMutableArray new];
        _playOrder = PlayingOrderSequence;
        _dataSource = SongDataSourceAll;
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

- (NSArray *)getSongList {
    return self.allSongList;
}

- (void)setDataSource:(SongDataSource)dataSource {
    _dataSource = dataSource;
    [self resetOrderdSongList];
    [self playOrderCase];
}

- (SongDataSource)dataSource {
    return _dataSource;
}

- (void)addSongs:(NSArray *)songs {
    for (id song in songs) {
        if ([song isKindOfClass:[ZLSongModel class]]) {
            [self.allSongList addObject:song];
        }
    }
}

- (void)loadAllSongsFromPlist {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"DemoSongs" ofType:@"plist"];
    NSArray *songsLit = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    for (NSDictionary *songInfo in songsLit) {
        ZLSongModel *model = [[ZLSongModel alloc] initWithDic:songInfo];
        if (![self.allSongList containsObject:model]) {
            [self.allSongList addObject:model];
        }
    }
    [self initPlayOrder];
}

- (int)indexOfSong:(ZLSongModel *)song {
    for (int i = 0; i < self.orderedSongList.count; i ++) {
        ZLSongModel *model = [self.orderedSongList objectAtIndex:i];
        if ([model.songId isEqualToString:song.songId]) {
            return i;
        }
    }
    return  -1;
}

- (ZLSongModel *)songOfIndex:(int)index {
    if (index >= 0 && index < self.allSongList.count) {
        return [self.allSongList objectAtIndex:index];
    }
    return nil;
}

- (ZLSongModel *)getPreSong {

    ZLSongModel *preSong = [self.orderedSongList firstObject];
    ZLSongModel *playingSong = [ZLPlayingManager sharedPlayingManager].curPlayingSong;
    if (playingSong) {
        int index = [self indexOfSong:playingSong];
        if (index >= 0) {
            int preIndex = index - 1;
            if (preIndex < 0) {
                preIndex = self.orderedSongList.count - 1;
            }
            preSong = [self.orderedSongList objectAtIndex:preIndex];
        }
    }
   return preSong;
}

- (ZLSongModel *)getNextSong {
    ZLSongModel *nextSong = [self.orderedSongList firstObject];
    ZLSongModel *playingSong = [ZLPlayingManager sharedPlayingManager].curPlayingSong;
    if (playingSong) {
        int index = [self indexOfSong:playingSong];
        if (index >= 0) {
            NSUInteger nextIndex = (index + 1) % self.orderedSongList.count;
            nextSong = [self.orderedSongList objectAtIndex:nextIndex];
        }
    }
    return nextSong;
    
}

#pragma mark - 播放次序控制

/**
 重置排序列表 同初始列表顺序
 */
- (void)resetOrderdSongList {
    [self.orderedSongList removeAllObjects];
    switch (self.dataSource) {
        case SongDataSourceAll:
            [self.orderedSongList addObjectsFromArray:self.allSongList];
            break;
        case SongDataSourceDownload:
            [self.orderedSongList addObjectsFromArray:[[ZLDownLoadManager sharedDownLoad] getDownLoadedSongList]];
            break;
        default:
            break;
    }

}


/**
 切换播放顺序模式的判断逻辑
 */
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

/**
 切换到顺序播放
 */
- (void)switchToSequenceOrder {
    self.playOrder = PlayingOrderSequence;
    [self resetOrderdSongList];
}

/**
 切换到随机播放
 */
- (void)switchToRandomOrder {
    self.playOrder = PlayingOrderRandom;
    //先恢复初始顺序
    [self resetOrderdSongList];
    //产生随机数组
    int repeatNum = self.orderedSongList.count - 1;
    for (int i = 0; i < repeatNum; i ++) {
        int dataNum = self.orderedSongList.count - i - 1;
        int randomIndex = arc4random() % dataNum;
        int lastIndex = dataNum;
        [self.orderedSongList exchangeObjectAtIndex:randomIndex withObjectAtIndex:lastIndex];
        
    }
    
}


/**
 切换到单曲循环
 */
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
