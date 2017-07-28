//
//  AppDelegate.m
//  ZhongLe
//
//  Created by jasonwu on 2017/7/7.
//  Copyright © 2017年 jasonwu. All rights reserved.
//

#import "AppDelegate.h"
#import "ZLMainViewController.h"
#import "ZLPlayingQueueManager.h"
#import "ZLDownLoadManager.h"
#import "ZLPlayingManager.h"
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    sleep(2);
    // 初始化
    self.window                    = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor    = [UIColor whiteColor];
    ZLMainViewController *mainVC  = [ZLMainViewController new];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:mainVC];
    [self.window makeKeyAndVisible];
    
    //获取音频会话11
    AVAudioSession *session = [AVAudioSession sharedInstance];
    //设置类型是播放。
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    //激活音频会话。
    [session setActive:YES error:nil];
    
    [[ZLPlayingQueueManager sharedQueueManager] loadAllSongsFromPlist];
    [[ZLDownLoadManager sharedDownLoad] loadDownLoadedSongs];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[ZLPlayingQueueManager sharedQueueManager] savePlayOrder];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[ZLPlayingQueueManager sharedQueueManager] savePlayOrder];
    [[ZLPlayingManager sharedPlayingManager] stop];
}


@end
