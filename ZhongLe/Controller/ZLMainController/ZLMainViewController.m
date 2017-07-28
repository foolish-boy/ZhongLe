//
//  ViewController.m
//  ZhongLe
//
//  Created by jasonwu on 2017/7/7.
//  Copyright © 2017年 jasonwu. All rights reserved.
//

#import "ZLMainViewController.h"
#import "DLTabedSlideView.h"
#import "ZLDefine.h"
#import "ZLAllSongViewController.h"
#import "ZLDownLoadedViewController.h"
#import "ZLPlayingStatusView.h"
#import "ZLSongModel.h"
#import "ZLPlayingManager.h"
#import "ZLPlayingViewController.h"
#import "ZLDownLoadManager.h"

typedef enum : NSUInteger {
    ListViewTypeAll = 0,
    ListViewTypeDownloaded
} ListViewType;

@interface ZLMainViewController () <DLTabedSlideViewDelegate>

@property (nonatomic, strong) DLTabedSlideView *tabedSlideView;
@property (nonatomic, strong) ZLAllSongViewController *allSongCtrl;
@property (nonatomic, strong) ZLDownLoadedViewController *downLoadCtrl;
@property (nonatomic, strong) ZLPlayingStatusView *statusView;
@property (nonatomic, assign) ListViewType listType;
@property (nonatomic, strong) UIBarButtonItem *editBarItem;
@property (nonatomic, strong) UIBarButtonItem *doneBarItem;
@property (nonatomic, strong) UIBarButtonItem *deleteAllBarItem;
@property (nonatomic, strong) UIBarButtonItem *downLoadAllBarItem;

@end

@implementation ZLMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"歌单";
    
    self.navigationItem.leftBarButtonItem = self.editBarItem;
    
    CGFloat statusViewHeight = 64;
    
    _statusView = [[ZLPlayingStatusView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - statusViewHeight, SCREEN_WIDTH, statusViewHeight)];

    
    self.tabedSlideView = [[DLTabedSlideView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT + STATUS_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT- STATUS_BAR_HEIGHT-statusViewHeight)];
    self.tabedSlideView.baseViewController = self;
    self.tabedSlideView.tabItemNormalColor = [UIColor blackColor];
    self.tabedSlideView.tabItemSelectedColor = [UIColor colorWithRed:0.833 green:0.052 blue:0.130 alpha:1.000];
    self.tabedSlideView.tabbarTrackColor = [UIColor colorWithRed:0.833 green:0.052 blue:0.130 alpha:1.000];
    self.tabedSlideView.tabbarBackgroundImage = [UIImage imageNamed:@"tabbarBk"];
    self.tabedSlideView.tabbarBottomSpacing = 0;
    self.tabedSlideView.delegate = self;
    
    DLTabedbarItem *item1 = [DLTabedbarItem itemWithTitle:@"全部" image:nil selectedImage:[UIImage imageNamed:@"goodsNew_d"]];
    DLTabedbarItem *item2 = [DLTabedbarItem itemWithTitle:@"已下载" image:nil selectedImage:[UIImage imageNamed:@"goodsHot_d"]];

    self.tabedSlideView.tabbarItems = @[item1, item2];
    [self.tabedSlideView buildTabbar];
    
    self.tabedSlideView.selectedIndex = 0;
    self.listType = ListViewTypeAll;
    
    [self.view addSubview:self.tabedSlideView];
    [self.view addSubview:_statusView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnStatusView)];
    [_statusView addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectSongStatusChanged) name:Notif_SongStatusChanged object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectSelectSong:) name:Notif_DidSelectSong object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.statusView refreshView];
}


- (void)tapOnStatusView {
    ZLSongModel *curSong = [ZLPlayingManager sharedPlayingManager].curPlayingSong;
    if (curSong) {
        [self gotoInfoView:curSong.songId playImmediately:YES];
    }
}


#pragma mark - notification
- (void)detectSelectSong:(NSNotification *)notif {
    NSString *songId = notif.object;
    [self gotoInfoView:songId playImmediately:YES];
}

- (void)gotoInfoView:(NSString *)songId playImmediately:(BOOL)immediately {
    if (!songId) {
        return;
    }
    ZLPlayingViewController *playingCtr = [ZLPlayingViewController new];
    
    if (immediately) {
        [[ZLPlayingManager sharedPlayingManager] playSong:songId loadProgress:^(float loadProgress) {
            [playingCtr loadingProgress:loadProgress];
        } playProgress:^(float curPlayTime) {
            [playingCtr playingProgress:curPlayTime];
        }];
    }
    
    [self.navigationController presentViewController:playingCtr animated:YES completion:nil];
}

- (void)detectSongStatusChanged {
    [self.statusView refreshView];
}


- (NSInteger)numberOfTabsInDLTabedSlideView:(DLTabedSlideView *)sender{
    return 2;
}
- (UIViewController *)DLTabedSlideView:(DLTabedSlideView *)sender controllerAt:(NSInteger)index{
    switch (index) {
        case 0:
        {
            if (!self.allSongCtrl) {
                self.allSongCtrl = [[ZLAllSongViewController alloc] init];
            }
            return self.allSongCtrl;
        }
        case 1:
        {
            if (!self.downLoadCtrl) {
                self.downLoadCtrl = [[ZLDownLoadedViewController alloc] init];
            }
            return self.downLoadCtrl;
        }
        default:
            return nil;
    }
}

- (void)DLTabedSlideView:(DLTabedSlideView *)sender didSelectedAt:(NSInteger)index {
    switch (index) {
        case 0:
        {
            self.listType = ListViewTypeAll;
            [self.allSongCtrl layoutView];
            break;
        }
        case 1:
        {
            self.listType = ListViewTypeDownloaded;
            [self.downLoadCtrl layoutView];
            break;
        }
        default:
            break;
    }
    [self.allSongCtrl endEdit];
    [self.downLoadCtrl endEdit];
    self.navigationItem.leftBarButtonItem = self.editBarItem;
    self.navigationItem.rightBarButtonItem = nil;
}

#pragma mark - barButtomItem event
- (void)editBarButtonClicked:(id)sender {
    if (self.listType == ListViewTypeDownloaded) {
        self.navigationItem.rightBarButtonItem = self.deleteAllBarItem;
        self.navigationItem.leftBarButtonItem = self.doneBarItem;
        [self.downLoadCtrl beginEdit];
    } else if (self.listType == ListViewTypeAll) {
        self.navigationItem.rightBarButtonItem = self.downLoadAllBarItem;
        self.navigationItem.leftBarButtonItem = self.doneBarItem;
        [self.allSongCtrl beginEdit];
    }
}

- (void)doneBarButtonClicked:(id)sender {
    if (self.listType == ListViewTypeDownloaded) {
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem = self.editBarItem;
        [self.downLoadCtrl endEdit];
    } else if (self.listType == ListViewTypeAll) {
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem = self.editBarItem;
        [self.allSongCtrl endEdit];
    }
    
}

- (void)deleteAllButtonClicked:(id)sender {
    if (self.listType == ListViewTypeDownloaded) {
        [[ZLDownLoadManager sharedDownLoad] clearSongs];
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem = self.editBarItem;
        [self.downLoadCtrl refreshView];
        [self.downLoadCtrl endEdit];
    }

}

- (void)downLoadAllButtonClicked:(id)sender {
    if (self.listType == ListViewTypeAll) {
        [[ZLDownLoadManager sharedDownLoad] downLoadAll];
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem = self.editBarItem;
        [self.allSongCtrl endEdit];
    }
}


#pragma mark - setter

- (UIBarButtonItem *)editBarItem {
    if (!_editBarItem) {
        _editBarItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑"
                                                        style:UIBarButtonItemStylePlain
                                                       target:self action:@selector(editBarButtonClicked:)];
    }
    return _editBarItem;
}

- (UIBarButtonItem *)doneBarItem {
    if (!_doneBarItem) {
        _doneBarItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(doneBarButtonClicked:)];
    }
    return _doneBarItem;
}

- (UIBarButtonItem *)deleteAllBarItem {
    if (!_deleteAllBarItem) {
        _deleteAllBarItem = [[UIBarButtonItem alloc] initWithTitle:@"删除全部" style:UIBarButtonItemStylePlain target:self action:@selector(deleteAllButtonClicked:)];
    }
    return _deleteAllBarItem;
}


- (UIBarButtonItem *)downLoadAllBarItem {
    if (!_downLoadAllBarItem) {
        _downLoadAllBarItem = [[UIBarButtonItem alloc] initWithTitle:@"下载" style:UIBarButtonItemStylePlain target:self action:@selector(downLoadAllButtonClicked:)];
    }
    return _downLoadAllBarItem;
}
@end
