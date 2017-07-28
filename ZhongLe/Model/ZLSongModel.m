//
//  ZLSongMaodel.m
//  ZhongLe
//
//  Created by jasonwu on 2017/7/7.
//  Copyright © 2017年 jasonwu. All rights reserved.
//

#import "ZLSongModel.h"
#import <AVFoundation/AVFoundation.h>

@implementation ZLSongModel



/**
 @property (nonatomic, strong) NSString *songId;
 @property (nonatomic, strong) NSString *songName;
 @property (nonatomic, strong) NSString *songUrl;
 @property (nonatomic, strong) NSString *singer;
 @property (nonatomic, strong) NSNumber *duration;

 @property (nonatomic, strong) NSString *albumName;
 @property (nonatomic, strong) NSString *albumUrl;

 */
- (instancetype)initWithSongPath:(NSString *)path
{
    self = [super init];
    if (self) {
//        _songId = [[NSUUID UUID] UUIDString];
//        _songName = path;
//        
//        NSURL *songFileUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:path ofType:@".mp3"]];
//        _songUrl = songFileUrl;
//        
//        AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:songFileUrl error:nil];
//        if (audioPlayer) {
//            _duration = [NSNumber numberWithDouble:audioPlayer.duration];
//        }
    }
    return self;
}

- (instancetype)initWithDic:(NSDictionary *)songInfo
{
    self = [super init];
    if (self) {
        self.songId    = songInfo[@"songId"];
        self.songName  = songInfo[@"songName"];
        self.songUrl   = [NSURL URLWithString:songInfo[@"songUrl"]];
        self.albumUrl  = songInfo[@"albumUrl"];
        self.singer    = songInfo[@"singer"];
        NSString *strDuration = songInfo[@"duration"];
        int intDuration = strDuration.intValue/1000;
        int minute = intDuration / 60;
        int second = intDuration % 60;
        self.duration = [NSString stringWithFormat:@"%.2d:%.2d",minute,second];
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    ZLSongModel *model = [ZLSongModel new];
    
    model.songId    = [aDecoder decodeObjectForKey:@"songId"];
    model.songName  = [aDecoder decodeObjectForKey:@"songName"];
    model.songUrl   = [aDecoder decodeObjectForKey:@"songUrl"];
    model.albumUrl  = [aDecoder decodeObjectForKey:@"albumUrl"];
    model.singer    = [aDecoder decodeObjectForKey:@"singer"];
    model.albumName = [aDecoder decodeObjectForKey:@"albumName"];
    model.duration  = [aDecoder decodeObjectForKey:@"duration"];
    
    return model;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.songId forKey:@"songId"];
    [aCoder encodeObject:self.songName forKey:@"songName"];
    [aCoder encodeObject:self.songUrl forKey:@"songUrl"];
    [aCoder encodeObject:self.albumUrl forKey:@"albumUrl"];
    [aCoder encodeObject:self.singer forKey:@"singer"];
    [aCoder encodeObject:self.albumName forKey:@"albumName"];
    [aCoder encodeObject:self.duration forKey:@"duration"];

}
@end
