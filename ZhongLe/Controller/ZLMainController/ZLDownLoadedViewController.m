//
//  ZLDownLoadedViewController.m
//  ZhongLe
//
//  Created by jasonwu on 2017/7/25.
//  Copyright © 2017年 jasonwu. All rights reserved.
//

#import "ZLDownLoadedViewController.h"
#import "ZLDownLoadedListView.h"
#import "ZLDefine.h"
#import "ZLPlayingViewController.h"
#import "ZLPlayingManager.h"

@interface ZLDownLoadedViewController ()

@property (nonatomic, strong) ZLDownLoadedListView *listView;

@end

@implementation ZLDownLoadedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _listView = [[ZLDownLoadedListView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_listView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectSelectSong:) name:Notif_DidSelectSong object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectSongStatusChanged) name:Notif_SongStatusChanged object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectSongDownloaded:) name:Notif_DownLoadSongSuccess object:nil];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.listView reloadData];
}


- (void)layoutView {
    self.listView.frame = self.view.bounds;
}

- (void)beginEdit {
    [self.listView setEditing:YES animated:YES];
}

- (void)endEdit {
    [self.listView setEditing:NO animated:YES];
}

- (void)refreshView {
    [self.listView reloadData];
}
#pragma mark - notification
- (void)detectSelectSong:(NSNotification *)notif {
    NSString *songId = notif.object;
//    [self gotoInfoView:songId playImmediately:YES];
}

- (void)detectSongStatusChanged {
    [self.listView reloadData];
}

- (void)detectSongDownloaded:(NSNotification *)notif {
    [self.listView reloadData];
}
@end
