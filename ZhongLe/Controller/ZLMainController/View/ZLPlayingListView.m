//
//  ZLPlayingListView.m
//  ZhongLe
//
//  Created by jasonwu on 2017/7/7.
//  Copyright © 2017年 jasonwu. All rights reserved.
//

#import "ZLPlayingListView.h"
#import "ZLPlayingQueueManager.h"
#import "ZLPlayingManager.h"
#import "ZLSongModel.h"
#import "ZLSongListCell.h"
#import "ZLDefine.h"
#import "ZLDownLoadManager.h"

@interface ZLPlayingListView () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation ZLPlayingListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataSource = self;
        self.delegate   = self;
    }
    return self;
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[ZLPlayingQueueManager sharedQueueManager] getSongList].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* cellIdentifier = NSStringFromSelector(_cmd);
    ZLSongListCell* cell = (ZLSongListCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[ZLSongListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    id data = [[[ZLPlayingQueueManager sharedQueueManager] getSongList] objectAtIndex:indexPath.row];
    if ([data isKindOfClass:[ZLSongModel class]]) {
        [cell setWithSongModel:data rowIndex:indexPath.row+1];
    }
    
    //检测当前cell是否是播放的音乐cell 处理UI
    NSString *songId = [[ZLPlayingQueueManager sharedQueueManager] songIdAtIndex:indexPath.row];
    ZLSongModel *playingSong =  [ZLPlayingManager sharedPlayingManager].curPlayingSong;
    if ([playingSong.songId isEqualToString:songId]) {
        [cell showAnimationView];
        if ([ZLPlayingManager sharedPlayingManager].isPlaying) {
            [cell startPlayingAnimation];
        } else {
            [cell stopPlayingAnimation];
        }
    } else {
        [cell hideAnimationView];
    }
    
    return cell;

}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SongListCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id data = [[[ZLPlayingQueueManager sharedQueueManager] getSongList] objectAtIndex:indexPath.row];
    if ([data isKindOfClass:[ZLSongModel class]]) {
        ZLSongModel *song = data;
        if (tableView.editing) {
            [[ZLDownLoadManager sharedDownLoad] addToDownLoadQueue:song];
        } else {
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:Notif_DidSelectSong object:song.songId];
        }
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    id data = [[[ZLPlayingQueueManager sharedQueueManager] getSongList] objectAtIndex:indexPath.row];
    if ([data isKindOfClass:[ZLSongModel class]]) {
        ZLSongModel *song = data;
        if (tableView.editing) {
            [[ZLDownLoadManager sharedDownLoad] removeFromDownLoadQueue:song];
        }
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    id data = [[[ZLPlayingQueueManager sharedQueueManager] getSongList] objectAtIndex:indexPath.row];
    if ([data isKindOfClass:[ZLSongModel class]]){
        ZLSongModel *song = data;
        if ([[ZLDownLoadManager sharedDownLoad] hasDownLoaded:song]) {
            return NO;
        }
    }
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

}

@end
