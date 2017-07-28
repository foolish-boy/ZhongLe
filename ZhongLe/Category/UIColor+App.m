//
//  UIColor+App.m
//  Coco
//
//  Created by PeterZhou on 14-6-12.
//  Copyright (c) 2014年 Instanza Inc. All rights reserved.
//

#import "UIColor+App.h"
#import "UIColor+Hex.h"

@implementation UIColor (App)

+ (UIColor *)greenThemeColor {
    return  [UIColor colorWithHex:0x36CA8F];
}

+ (UIColor *)whiteBackgroundColor {
    return [UIColor colorWithHex:0xffffff];
}

+ (UIColor *)grayBackgroundColor {
    return [UIColor colorWithHex:0xefeff4];
}

+ (UIColor *)blueFontColor {
    return [UIColor colorWithHex:0x0079ff];
}

+ (UIColor *)blueButtonNormalColor {
    return [self blueFontColor];
}

+ (UIColor *)blueButtonHighlightColor {
    return [UIColor colorWithHex:0x0054b2];
}

+ (UIColor *)blueButtonDisableColor {
    return [UIColor colorWithHex:0xa6d0ff];
}

+ (UIColor *)blackFontColor {
    return [UIColor colorWithHex:0x000000];
}

+ (UIColor *)grayFontColor {
    return [UIColor colorWithHex:0x8e8e93];
}

+ (UIColor *)grayLineColor {
    return [UIColor colorWithHex:0xc8c8cc];
}

+ (UIColor *)cellSelectedColor {
    return [UIColor colorWithHex:0xd9d9d9];
}

+ (UIColor *)sectionHeaderColor {
    return [self navBackgroundColor];
}

+ (UIColor *)navBackgroundColor {
    return [UIColor colorWithHex:0xf8f8f8];
}

+ (UIColor *)navTintColor {
    return [self blueButtonNormalColor];
}

@end
