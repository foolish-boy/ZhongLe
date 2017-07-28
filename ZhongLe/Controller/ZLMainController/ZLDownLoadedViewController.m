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

@property (nonatomic, strong) ZLDownLoadedListView *downloadListView;

@end

@implementation ZLDownLoadedViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _downloadListView = [[ZLDownLoadedListView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_downloadListView];
        
        super.listView = _downloadListView;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectSongDownloaded:) name:Notif_DownLoadSongSuccess object:nil];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)detectSongDownloaded:(NSNotification *)notif {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.downloadListView reloadData];
    });
}
@end
