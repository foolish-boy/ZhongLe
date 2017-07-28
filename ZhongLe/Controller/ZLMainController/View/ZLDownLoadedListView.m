//
//  ZLDownLoadedSongListView.m
//  ZhongLe
//
//  Created by jasonwu on 2017/7/25.
//  Copyright © 2017年 jasonwu. All rights reserved.
//

#import "ZLDownLoadedListView.h"
#import "ZLPlayingQueueManager.h"
#import "ZLPlayingManager.h"
#import "ZLSongModel.h"
#import "ZLSongListCell.h"
#import "ZLDefine.h"
#import "ZLDownLoadManager.h"

@implementation ZLDownLoadedListView

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
    return [[ZLPlayingQueueManager sharedQueueManager] getDownLoadedSongList].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* cellIdentifier = NSStringFromSelector(_cmd);
    ZLSongListCell* cell = (ZLSongListCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[ZLSongListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    id data = [[[ZLPlayingQueueManager sharedQueueManager] getDownLoadedSongList] objectAtIndex:indexPath.row];
    if ([data isKindOfClass:[ZLSongModel class]]) {
        [cell setWithSongModel:data rowIndex:indexPath.row+1];
    }
    
    //检测当前cell是否是播放的音乐cell 处理UI
    NSString *songId = [[ZLPlayingQueueManager sharedQueueManager] downLoadedSongIdAtIndex:indexPath.row];
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
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    id data = [[[ZLPlayingQueueManager sharedQueueManager] getDownLoadedSongList] objectAtIndex:indexPath.row];
    if ([data isKindOfClass:[ZLSongModel class]]) {
        ZLSongModel *song = data;
        [[NSNotificationCenter defaultCenter] postNotificationName:Notif_DidSelectSong object:song.songId];
    }
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ZLSongListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        ZLSongModel *model = cell.curModel;
        if (model) {
            [[ZLDownLoadManager sharedDownLoad] removeSong:model.songId];
        }
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end
