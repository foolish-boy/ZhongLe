//
//  ZLSpiderManager.m
//  ZhongLe
//
//  Created by jasonwu on 2017/8/3.
//  Copyright © 2017年 jasonwu. All rights reserved.
//

#import "ZLSpiderManager.h"
#import "TFHpple.h"
#import "OCGumbo.h"
#import "OCGumbo+Query.h"
#import "NSString+EX.h"
#import "ZLSongModel.h"
#import "ZLPlayingQueueManager.h"
#import "ZLDefine.h"

@implementation ZLSpiderManager

+ (ZLSpiderManager *)sharedSpider {
    static ZLSpiderManager *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc] init];
    });
    return singleton;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self startSpider:@"http://www.kugou.com/yy/html/rank.html"];
    }
    return self;
}

- (void)startSpider:(NSString *)url {

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = nil;
        NSString *htmlStr = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:&error];
        
        //获得所有<a href="http://www.kugou.com/song/gg0hpc6.html" data-active="playDwn" data-index="1" class="pc_temp_songname" title="冷漠 - 我是多想见到你" hidefocus="true">冷漠 - 我是多想见到你</a>
        OCGumboDocument *doc = [[OCGumboDocument alloc] initWithHTMLString:htmlStr];
        NSArray *songList = doc.Query(@"#rankWrap").find(@".pc_temp_songlist").find(@"li").find(@".pc_temp_songname");
        //提取到所有歌曲链接
        NSMutableArray *songUrls = [NSMutableArray new];
        for (OCGumboElement *song in songList) {
            NSString *href = song.attr(@"href");
            [songUrls addObject:href];
        }
        //    NSLog(@"%@",songUrls);
        
        NSMutableArray *spiderSongs =  [NSMutableArray new];
        for (NSString *href in songUrls) {
            NSString *detailHtml = [NSString stringWithContentsOfURL:[NSURL URLWithString:href] encoding:NSUTF8StringEncoding error:nil];
            OCGumboDocument *detailDoc = [[OCGumboDocument alloc] initWithHTMLString:detailHtml];
            NSString *dataFromSmarty = detailDoc.Query(@"head").find(@"script").first().text();
            NSString *hash = nil;
            NSArray *components = [dataFromSmarty componentsSeparatedByString:@"hash\":\""];
            if (components.count >= 2) {
                NSString *str = components[1];
                hash = [str componentsSeparatedByString:@"\","][0];
            }
            NSLog(@"%@",hash);
            NSString *realUrl = [NSString stringWithFormat:@"http://www.kugou.com/yy/index.php?r=play/getdata&hash=%@",hash];
            NSString *realHtml = [NSString stringWithContentsOfURL:[NSURL URLWithString:realUrl] encoding:NSUTF8StringEncoding error:nil];
            NSDictionary *dic = [realHtml dictionaryWithJsonString];
            NSLog(@"%@",dic);
            if (dic) {
                ZLSongModel *songModel = [self convertFromHtmlDictionry:dic[@"data"]];
                [spiderSongs addObject:songModel];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[ZLPlayingQueueManager sharedQueueManager] addSongs:spiderSongs];
            [[NSNotificationCenter defaultCenter] postNotificationName:Notif_SpiderSongsSuccess object:nil];
        });
    });

}


/**
 @property (nonatomic, strong) NSString *songId;
 @property (nonatomic, strong) NSString *songName;
 @property (nonatomic, strong) NSURL    *songUrl;
 @property (nonatomic, strong) NSString *singer;
 @property (nonatomic, strong) NSString *duration;

 @property (nonatomic, strong) NSString *albumName;
 @property (nonatomic, strong) NSString *albumUrl;

 */
- (ZLSongModel *)convertFromHtmlDictionry:(NSDictionary *)dic {
    ZLSongModel *model = [[ZLSongModel alloc] init];
    model.songId    = dic[@"hash"];
    model.songName  = dic[@"song_name"];
    model.songUrl   = [NSURL URLWithString:dic[@"play_url"]];
    model.singer    = dic[@"author_name"];

    NSString *strDuration = dic[@"timelength"];
    int intDuration = strDuration.intValue/1000;
    int minute = intDuration / 60;
    int second = intDuration % 60;
    model.duration  = [NSString stringWithFormat:@"%.2d:%.2d",minute,second];

    model.albumName = dic[@"album_name"];
    model.albumUrl  = dic[@"img"];
    return model;
}

@end
