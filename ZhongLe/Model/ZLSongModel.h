//
//  ZLSongModel.h
//  ZhongLe
//
//  Created by jasonwu on 2017/7/7.
//  Copyright © 2017年 jasonwu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZLSongModel : NSObject <NSCoding>

@property (nonatomic, strong) NSString *songId;
@property (nonatomic, strong) NSString *songName;
@property (nonatomic, strong) NSURL    *songUrl;
@property (nonatomic, strong) NSString *singer;
@property (nonatomic, strong) NSString *duration;
//album
@property (nonatomic, strong) NSString *albumName;
@property (nonatomic, strong) NSString *albumUrl;

- (instancetype)initWithSongPath:(NSString *)path;

- (instancetype)initWithDic:(NSDictionary *)songInfo;
@end
