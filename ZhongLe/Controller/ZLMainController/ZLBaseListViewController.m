//
//  ZLBaseListViewController.m
//  ZhongLe
//
//  Created by jasonwu on 2017/7/28.
//  Copyright © 2017年 jasonwu. All rights reserved.
//

#import "ZLBaseListViewController.h"
#import "ZLDefine.h"

@interface ZLBaseListViewController ()

@end

@implementation ZLBaseListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectSongStatusChanged) name:Notif_SongStatusChanged object:nil];
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
- (void)detectSongStatusChanged {
    [self.listView reloadData];
}


@end
