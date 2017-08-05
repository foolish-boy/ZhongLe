//
//  ZLSpiderManager.h
//  ZhongLe
//
//  Created by jasonwu on 2017/8/3.
//  Copyright © 2017年 jasonwu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZLSpiderManager : NSObject

+ (ZLSpiderManager *)sharedSpider;

- (void)startSpider:(NSString *)url;

@end
