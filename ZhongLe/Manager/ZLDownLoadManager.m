//
//  ZLDownLoadManager.m
//  ZhongLe
//
//  Created by jasonwu on 2017/7/26.
//  Copyright © 2017年 jasonwu. All rights reserved.
//

#import "ZLDownLoadManager.h"
#import "ZLSongModel.h"
#import "NSString+EX.h"
#import "ZLDefine.h"

@interface ZLDownLoadManager ()

@property (nonatomic, strong) NSString *storePath;
@property (nonatomic, strong) NSMutableArray *downLoadQueue;
@property (nonatomic, strong) NSMutableArray *downLoadSongs;

@end

@implementation ZLDownLoadManager

+ (ZLDownLoadManager *)sharedDownLoad {
    static ZLDownLoadManager *singleton = nil;
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
        _downLoadQueue = [NSMutableArray new];
        _downLoadSongs = [NSMutableArray new];
        NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        _storePath = [filePath stringByAppendingPathComponent:STORE_DIRECTORY];
        if (![[NSFileManager defaultManager] fileExistsAtPath:_storePath])
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:_storePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    return self;
}

- (void)addToDownLoadQueue:(ZLSongModel *)song {
    if (song && ![self.downLoadQueue containsObject:song]) {
        [self.downLoadQueue addObject:song];
    }
}
- (void)removeFromDownLoadQueue:(ZLSongModel *)song {
    if (song && [self.downLoadQueue containsObject:song]) {
        [self.downLoadQueue removeObject:song];
    }
}
- (void)downLoadAll {
    for (ZLSongModel *song in self.downLoadQueue) {
        [self startDownLoad:song];
    }
}


- (void)startDownLoad:(ZLSongModel *)requestSong {
    if (!requestSong) {
        return;
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:requestSong.songUrl];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDownloadTask *task =
        [session downloadTaskWithRequest:request
                       completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                           if (!error) {
                            //下载的歌曲 存入../Library/Cacahes/DownLoads/
                            //每首歌曲对应两个文件 songId.mp3  songId.info
                            //分别是mp3资源文件和ZLSongModel序列化信息
                            NSError *fileError;
                            
                            [[NSFileManager defaultManager] copyItemAtPath:location.path
                                                                    toPath:[self getMP3Path:requestSong.songId] error:&fileError];
                            if (fileError) {
                                NSLog(@"save failed");
                                [[NSNotificationCenter defaultCenter] postNotificationName:Notif_DownLoadSongFail object:nil];
                            } else {
                                NSLog(@"save success");
                                [NSKeyedArchiver archiveRootObject:requestSong toFile:[self getInfoPath:requestSong.songId]];
                                [self addSong:requestSong];
                                
                                [[NSNotificationCenter defaultCenter] postNotificationName:Notif_DownLoadSongSuccess object:nil];
                                
                                if ([self.downLoadQueue containsObject:requestSong]) {
                                    [self.downLoadQueue removeObject:requestSong];
                                }
                            }
                        }
        }];
    [task resume];
}


- (BOOL)hasDownLoaded:(ZLSongModel *)requestSong {
    if (!requestSong) {
        return NO;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self getMP3Path:requestSong.songId]]) {
        return true;
    }
    return false;
}

- (NSURL *)getDownLoadedUrl:(ZLSongModel *)requestSong {
    if (!requestSong) {
        return nil;
    }
    if ([self hasDownLoaded:requestSong]) {
        return [[NSURL alloc] initFileURLWithPath:[self getMP3Path:requestSong.songId]];//不能用URLWithString
    }
    return requestSong.songUrl;
}

- (void)loadDownLoadedSongs {
    NSArray *fileList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.storePath error:nil];
    for (NSString *file in fileList) {
        if ([file hasSuffix:@"mp3"]) {
            NSString *infoFile = [file stringByReplacingOccurrencesOfString:@"mp3" withString:@"info"];
            NSString *infoPath = [self.storePath stringByAppendingPathComponent:infoFile];
            if ([[NSFileManager defaultManager] fileExistsAtPath:infoPath]) {
                ZLSongModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:infoPath];
                [self.downLoadSongs addObject:model];
            }
        }
    }
}

- (NSArray *)getDownLoadedSongList {
    return self.downLoadSongs;
}


- (void)removeSong:(ZLSongModel *)song {
    if (!song) {
        return;
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self getMP3Path:song.songId]]) {
        [[NSFileManager defaultManager] removeItemAtPath:[self getMP3Path:song.songId] error:nil];
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self getInfoPath:song.songId]]) {
        [[NSFileManager defaultManager] removeItemAtPath:[self getInfoPath:song.songId] error:nil];
    }
    if ([self.downLoadSongs containsObject:song]) {
        [self.downLoadSongs removeObject:song];
    }
}

- (void)clearSongs {
    NSArray *list = [NSArray arrayWithArray:[self getDownLoadedSongList]];
    for (ZLSongModel *song in list) {
        [self removeSong:song];
    }
}

- (ZLSongModel *)songOfIndex:(int)index {
    if (index >= 0 && index < self.downLoadSongs.count) {
        return [self.downLoadSongs objectAtIndex:index];
    }
    return nil;
}

#pragma mark - private methods
- (NSString *)getMP3Path:(NSString *)songId {
    return [[self.storePath stringByAppendingPathComponent:songId] stringByAppendingPathExtension:@"mp3"];
}

- (NSString *)getInfoPath:(NSString *)songId {
    return [[self.storePath stringByAppendingPathComponent:songId] stringByAppendingPathExtension:@"info"];

}

- (void)addSong:(ZLSongModel *)song {
    if (song && ![self.downLoadSongs containsObject:song]) {
        [self.downLoadSongs addObject:song];
    }
}

@end
