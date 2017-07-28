//
//  ZLPlayingManager.m
//  ZhongLe
//
//  Created by jasonwu on 2017/7/7.
//  Copyright © 2017年 jasonwu. All rights reserved.
//

#import "ZLPlayingManager.h"
#import "ZLPlayingQueueManager.h"
#import "ZLSongModel.h"
#import <AVFoundation/AVFoundation.h>
#import "ZLDefine.h"
#import "AVPlayerItem+MCCacheSupport.h"
#import "ZLDownLoadManager.h"

@interface ZLPlayingManager ()

@property (nonatomic, strong) AVPlayer      *player;
//当前歌曲进度监听者
@property(nonatomic,strong) id timeObserver;

@property (nonatomic, copy)   loadProgressBlock     loadingProgressBlock;
@property (nonatomic, copy)   playProgressBlock     playingProgressBlock;

@end


@implementation ZLPlayingManager

+ (ZLPlayingManager *)sharedPlayingManager {
    static ZLPlayingManager *singleton = NULL;
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
        _player = nil;
        _isPlaying = false;
        _curPlayingSong = nil;
        NSString *curSongId = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentSong"];
        ZLSongModel *song = [[ZLPlayingQueueManager sharedQueueManager] getSongById:curSongId];
        if (song) {
            _curPlayingSong = song;
        }
    }
    return self;
}

- (void)playSong:(NSString *)songId loadProgress:(loadProgressBlock)loadProgress playProgress:(playProgressBlock)playProgress {
    if (!songId) {
        return;
    }
    
    _loadingProgressBlock = loadProgress;
    _playingProgressBlock = playProgress;
    
    if (_curPlayingSong) {//有歌曲在播放/暂停
        if ([_curPlayingSong.songId isEqualToString:songId]) {//当前播放/暂停 的歌曲就是本次要播放的
            if (_isPlaying) {//正在播放 不做操作
                // do nothing
                return;
            } else { //从暂停开始播放
                [self continuePlaying];
            }
        } else { //切换播放新歌曲
            [self removeAllObservers];
            ZLSongModel *song = [[ZLPlayingQueueManager sharedQueueManager] getSongById:songId];
            if (song) {
                _curPlayingSong = song;
                _isPlaying = true;
                _curPlayingTime = 0;
                _curLoadingScale = 0;
                NSURL *remoteUrl = [[ZLDownLoadManager sharedDownLoad] getDownLoadedUrl:song];
//                AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:song.songUrl];
                AVPlayerItem *item = [AVPlayerItem mc_playerItemWithRemoteURL:remoteUrl error:nil];
                if (self.player) {
                    [self.player replaceCurrentItemWithPlayerItem:item];
                } else {
                    self.player = [[AVPlayer alloc] initWithPlayerItem:item];
                }
                [self.player play];
                
                [self addNSNotificationForPlayMusicFinish];
                [self addPlayStatus];
                [self addPlayLoadTime];
                [self addMusicProgressWithItem:item];
            }
        }
    } else { //首次开始播放的歌曲
        ZLSongModel *song = [[ZLPlayingQueueManager sharedQueueManager] getSongById:songId];
        if (song) {
            _curPlayingSong = song;
            _isPlaying = true;
            _curPlayingTime = 0;
            _curLoadingScale = 0;
            
            NSURL *remoteUrl = [[ZLDownLoadManager sharedDownLoad] getDownLoadedUrl:song];
//            AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:song.songUrl];
            AVPlayerItem *item = [AVPlayerItem mc_playerItemWithRemoteURL:remoteUrl error:nil];
            _player = [[AVPlayer alloc] initWithPlayerItem:item];
            [_player play];
            
            
            [self addNSNotificationForPlayMusicFinish];
            [self addPlayStatus];
            [self addPlayLoadTime];
            [self addMusicProgressWithItem:item];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:Notif_SongStatusChanged object:nil];
}

//暂停播放 或者 单曲循环播放
- (void)continuePlaying {
    if (_player) {
        [_player play];
        _isPlaying = true;
    } else {
    
    }
     [[NSNotificationCenter defaultCenter] postNotificationName:Notif_SongStatusChanged object:nil];
}

- (void)pause {
    if (_player) {
        [_player pause];
        _isPlaying = false;
    }
     [[NSNotificationCenter defaultCenter] postNotificationName:Notif_SongStatusChanged object:nil];
}

- (void)stop {
    [self removeAllObservers];
    if (_player) {
        [_player pause];
        _player = nil;
    }
    _isPlaying = false;
    _curPlayingSong = nil;
     [[NSNotificationCenter defaultCenter] postNotificationName:Notif_SongStatusChanged object:nil];
}



- (void)playAll {
//    NSArray *allSongs = [[ZLPlayingQueueManager sharedQueueManager] getSongList];
//    for (int index = 0 ; index < allSongs.count; index ++) {
////        ZLSongModel *song = [allSongs objectAtIndex:index];
////        NSTimeInterval duration = song.duration.doubleValue;
//        
//    }
}

- (void)removeAllObservers {
    [self removePlayStatus];
    [self removePlayLoadTime];
    [self removeTimeObserver];
}

- (float)getProgressByPlayTime:(float)playTime {
    float progress = 0;
    float total = CMTimeGetSeconds(_player.currentItem.duration);
    if (playTime && total) {
        progress = playTime / total;
    }
    return progress;
}

#pragma mark - 监听音乐各种状态
//通过KVO监听播放器状态
-(void)addPlayStatus
{
    
    [self.player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
}
//移除监听播放器状态
-(void)removePlayStatus
{
    
    [self.player.currentItem removeObserver:self forKeyPath:@"status"];
}

-(void)addNSNotificationForPlayMusicFinish
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //给AVPlayerItem添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
}


/**
 单曲循环时
 自动播放结束 与手动切换 的处理逻辑不同
 @param notification 
 */
- (void)playFinished:(NSNotification*)notification {
    self.isPlaying = false;
    NSString *nextId = [[ZLPlayingQueueManager sharedQueueManager] getNextSongId];
    if ([[ZLPlayingQueueManager sharedQueueManager] isLoopOrder]) {
        nextId = self.curPlayingSong.songId;
        [self.player seekToTime:CMTimeMake(0, 1)];
    }
    [self playSong:nextId loadProgress:self.loadingProgressBlock playProgress:self.playingProgressBlock];
    [[NSNotificationCenter defaultCenter] postNotificationName:Notif_SwitchSong object:nil];
}


//KVO监听音乐缓冲状态
-(void)addPlayLoadTime
{
    if (!self.curPlayingSong) {
        return;
    }
    [self.player.currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    
}
//移除监听音乐缓冲状态
-(void)removePlayLoadTime
{
    if (!self.curPlayingSong)
    {
        return;
    }
    [self.player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
}

//监听音乐播放的进度
-(void)addMusicProgressWithItem:(AVPlayerItem *)item
{
    //移除监听音乐播放进度
    [self removeTimeObserver];
    __weak typeof(self) weakSelf = self;
    self.timeObserver =  [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        //当前播放的时间
        float current = CMTimeGetSeconds(time);
        if (current) {
            self.curPlayingTime = current;
            if (weakSelf.playingProgressBlock) {
                weakSelf.playingProgressBlock(current);
            }
        }
    }];
    
}

//移除监听音乐播放进度
-(void)removeTimeObserver
{
    if (self.timeObserver) {
        [self.player removeTimeObserver:self.timeObserver];
        self.timeObserver = nil;
    }
}

//观察者回调
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context

{
    if ([keyPath isEqualToString:@"status"]) {
        switch (self.player.status) {
            case AVPlayerStatusUnknown:
            {
                NSLog(@"未知转态");
            }
                break;
            case AVPlayerStatusReadyToPlay:
            {
                NSLog(@"准备播放");
            }
                break;
            case AVPlayerStatusFailed:
            {
                NSLog(@"加载失败");
            }
                break;
                
            default:
                break;
        }
        
    }
    
    if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSArray * timeRanges = self.player.currentItem.loadedTimeRanges;
        //本次缓冲的时间范围
        CMTimeRange timeRange = [timeRanges.firstObject CMTimeRangeValue];
        //缓冲总长度
        NSTimeInterval totalLoadTime = CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration);
        //音乐的总时间
        NSTimeInterval duration = CMTimeGetSeconds(self.player.currentItem.duration);
        //计算缓冲百分比例
        NSTimeInterval scale = totalLoadTime/duration;
        //更新缓冲进度条
//        self.loadTimeProgress.progress = scale;
        self.curLoadingScale = scale;
        if (self.loadingProgressBlock) {
            self.loadingProgressBlock(scale);
        }
    }
}

#pragma mark - 播放控制
- (void)seekToTime:(float)timeValue {
    if (self.player) {
        float timeToSeek = timeValue * CMTimeGetSeconds(self.player.currentItem.duration);
        [self.player seekToTime:CMTimeMake(timeToSeek, 1)];
    }
}

- (void)playPreSong {
    NSString *preId = [[ZLPlayingQueueManager sharedQueueManager] getPreSongId];
    [self playSong:preId loadProgress:self.loadingProgressBlock playProgress:self.playingProgressBlock];
    [[NSNotificationCenter defaultCenter] postNotificationName:Notif_SwitchSong object:nil];
}

- (void)playNextSong{
    NSString *nextId = [[ZLPlayingQueueManager sharedQueueManager] getNextSongId];
    [self playSong:nextId loadProgress:self.loadingProgressBlock playProgress:self.playingProgressBlock];
    [[NSNotificationCenter defaultCenter] postNotificationName:Notif_SwitchSong object:nil];
}

- (void)saveCurSong {
//    if (self.curPlayingSong) {
//        [[NSUserDefaults standardUserDefaults] setObject:self.curPlayingSong.songId forKey:@"CurrentSong"];
//    }
}
@end
