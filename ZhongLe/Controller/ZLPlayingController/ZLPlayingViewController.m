//
//  ZLPlayingViewController.m
//  ZhongLe
//
//  Created by jasonwu on 2017/7/12.
//  Copyright © 2017年 jasonwu. All rights reserved.
//

#import "ZLPlayingViewController.h"
#import "ZLPlayingManager.h"
#import "ZLSongModel.h"
#import "ZLPlayingInfoView.h"

@interface ZLPlayingViewController ()

@property (nonatomic, strong) ZLPlayingInfoView *infoView;

@end

@implementation ZLPlayingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _infoView = [[ZLPlayingInfoView alloc] initWithFrame:self.view.bounds];
    _infoView.baseController = self;
    [self.view addSubview:_infoView];
    
    
    ZLSongModel *curSong = [ZLPlayingManager sharedPlayingManager].curPlayingSong;
    [_infoView refreshViewWithModel:curSong];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([ZLPlayingManager sharedPlayingManager].isPlaying) {
        [_infoView checkStartCoverAnimation];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)playingProgress:(float)playTime{
    [_infoView refreshPlayingProgress:playTime];
}

- (void)loadingProgress:(float)progress {
    [_infoView refreshLoadingProgress:progress];
}
@end
