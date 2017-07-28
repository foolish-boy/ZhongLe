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
        [self downLoadTask:song];
    }
}


- (void)downLoadTask:(ZLSongModel *)requestSong {
    if (!requestSong) {
        return;
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:requestSong.songUrl];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request
                                                    completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                        if (!error) {
                                                            
                                                            NSLog(@"%@",location.path);
                                                            NSError *fileError;
                                                            //                                                            NSString *path = [[self.storePath stringByAppendingPathComponent:[[requestUrl absoluteString] mc_md5]] stringByAppendingPathExtension:[requestUrl pathExtension]];
                                                            NSString *mp3Path = [[self.storePath stringByAppendingPathComponent:requestSong.songId] stringByAppendingPathExtension:[requestSong.songUrl pathExtension]];
                                                            NSString *infoPath = [[self.storePath stringByAppendingPathComponent:requestSong.songId] stringByAppendingPathExtension:@"info"];
                                                            
                                                            [[NSFileManager defaultManager] copyItemAtPath:location.path toPath:mp3Path error:&fileError];
                                                            if (fileError) {
                                                                NSLog(@"save failed");
                                                                [[NSNotificationCenter defaultCenter] postNotificationName:Notif_DownLoadSongFail object:nil];
                                                            } else {
                                                                NSLog(@"save success");
                                                                [NSKeyedArchiver archiveRootObject:requestSong toFile:infoPath];
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
    NSURL *requestUrl = requestSong.songUrl;
    NSString *path = [[self.storePath stringByAppendingPathComponent:requestSong.songId] stringByAppendingPathExtension:[requestUrl pathExtension]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return true;
    }
    return false;
}

- (NSURL *)getDownLoadedUrl:(ZLSongModel *)requestSong {
    if (!requestSong) {
        return nil;
    }
    NSURL *requestUrl = requestSong.songUrl;
    if ([self hasDownLoaded:requestSong]) {
        NSString *path = [[self.storePath stringByAppendingPathComponent:requestSong.songId] stringByAppendingPathExtension:[requestUrl pathExtension]];
        return [[NSURL alloc] initFileURLWithPath:path];//不能用URLWithString
    }
    return requestUrl;
}

- (NSArray *)getDownLoadedSongIdList {
    NSMutableArray *songIdList = [[NSMutableArray alloc] init];
    NSArray *fileList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.storePath error:nil];
    for (NSString *file in fileList) {
        if ([file hasSuffix:@".mp3"]) {
            NSArray *arr = [file componentsSeparatedByString:@"."];
            if (arr.count == 2) {
                NSString *songId = arr[0];
                [songIdList addObject:songId];
            }
        }
    }
    return songIdList;
}


- (void)removeSong:(NSString *)songId {
    if (!songId) {
        return;
    }
    NSString *mp3Path = [[self.storePath stringByAppendingPathComponent:songId] stringByAppendingPathExtension:@"mp3"];
    NSString *infoPath = [[self.storePath stringByAppendingPathComponent:songId] stringByAppendingPathExtension:@"info"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:mp3Path]) {
        [[NSFileManager defaultManager] removeItemAtPath:mp3Path error:nil];
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:infoPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:infoPath error:nil];
    }
}

- (void)clearSongs {
    NSArray *list = [self getDownLoadedSongIdList];
    for (NSString *songId in list) {
        [self removeSong:songId];
    }
}


@end
