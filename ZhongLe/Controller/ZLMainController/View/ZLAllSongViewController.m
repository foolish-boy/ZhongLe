//
//  ZLAllSongViewController.m
//  ZhongLe
//
//  Created by jasonwu on 2017/7/25.
//  Copyright © 2017年 jasonwu. All rights reserved.
//

#import "ZLAllSongViewController.h"
#import "ZLPlayingListView.h"
#import "ZLDefine.h"
#import "ZLPlayingManager.h"
#import "ZLPlayingViewController.h"
#import "ZLSongModel.h"
#import "ZLDownLoadManager.h"

@interface ZLAllSongViewController ()

@property (nonatomic, strong) ZLPlayingListView *playingListView;

@end

@implementation ZLAllSongViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _playingListView = [[ZLPlayingListView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_playingListView];
        
        super.listView = _playingListView;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectSpiderSongsSuccess) name:Notif_SpiderSongsSuccess object:nil];
    }
    return self;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)detectSpiderSongsSuccess {
    [self.listView reloadData];
}


@end
