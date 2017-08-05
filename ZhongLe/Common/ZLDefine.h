//
//  ZLDefine.h
//  ZhongLe
//
//  Created by jasonwu on 2017/7/11.
//  Copyright © 2017年 jasonwu. All rights reserved.
//


#ifndef ZLDefine_h
#define ZLDefine_h

//system
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define RLMD [RLMRealm defaultRealm]

//Sreen size
#define SCREEN_SIZE         [UIScreen mainScreen].bounds.size
#define SCREEN_WIDTH        SCREEN_SIZE.width
#define SCREEN_HEIGHT       SCREEN_SIZE.height
#define SCREEN_SCALE        [UIDevice currentDevice].screenScale

#define NAVIGATION_BAR_HEIGHT           44.0f
#define STATUS_BAR_HEIGHT               [[UIApplication sharedApplication] statusBarFrame].size.height

//device version
#define IsIOS10OrHigher     SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10.0")
#define IsIOS9OrHigher      SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")
#define IsIOS8OrHigher      SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")
#define IsIOS7OrHigher      SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")
#define IsIOS6OrHigher      SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")
#define IsIOS5_0_X  (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5.0") && SYSTEM_VERSION_LESS_THAN(@"5.1"))
#define IsIOS6OrLower       SYSTEM_VERSION_LESS_THAN(@"7.0")
#define IsIOS7              (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") && SYSTEM_VERSION_LESS_THAN(@"8.0"))

//Notification
#define Notif_DidSelectSong             @"Notif_DidSelectSong"
#define Notif_SongStatusChanged         @"Notif_SongStatusChanged"
#define Notif_SwitchSong                @"Notif_SwitchSong"
#define Notif_LongPressSongListCell     @"Notif_LongPressSongListCell"
#define Notif_DownLoadSongSuccess       @"Notif_DownLoadSongSuccess"
#define Notif_DownLoadSongFail          @"Notif_DownLoadSongFail"
#define Notif_SpiderSongsSuccess        @"Notif_SpiderSongsSuccess"

#define STORE_DIRECTORY  @"DownLoads/"


#endif /* ZLDefine_h */


