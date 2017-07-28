//
//  ZLBaseListViewController.h
//  ZhongLe
//
//  Created by jasonwu on 2017/7/28.
//  Copyright © 2017年 jasonwu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZLBaseListViewController : UIViewController

@property (nonatomic, strong) UITableView *listView;

- (void)refreshView;
- (void)layoutView;
- (void)beginEdit;
- (void)endEdit;

@end
