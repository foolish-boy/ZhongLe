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

@property (nonatomic, strong) ZLPlayingListView *listView;

@end

@implementation ZLAllSongViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _listView = [[ZLPlayingListView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_listView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectSelectSong:) name:Notif_DidSelectSong object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectSongStatusChanged) name:Notif_SongStatusChanged object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectLongPressSongCell:) name:Notif_LongPressSongListCell object:nil];
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

- (void)detectLongPressSongCell:(NSNotification *)notif {
    ZLSongModel *pressSong = notif.object;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"下载" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[ZLDownLoadManager sharedDownLoad] downLoadTask:pressSong];
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:saveAction];
    [self presentViewController:alert animated:YES completion:nil];
}



@end
