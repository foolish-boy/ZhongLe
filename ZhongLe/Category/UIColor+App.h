//
//  UIColor+App.h
//  Coco
//
//  Created by PeterZhou on 14-6-12.
//  Copyright (c) 2014年 Instanza Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (App)

+ (UIColor *)greenThemeColor;
//白色背景色，用于chat/contact等
+ (UIColor *)whiteBackgroundColor;
//灰色背景色，用于setting等
+ (UIColor *)grayBackgroundColor;

//蓝色字体
+ (UIColor *)blueFontColor;
//蓝色按钮normal状态
+ (UIColor *)blueButtonNormalColor;
//蓝色按钮highlight状态
+ (UIColor *)blueButtonHighlightColor;
//蓝色按钮disabled状态
+ (UIColor *)blueButtonDisableColor;

//黑色字体（用于标题、主要展示）
+ (UIColor *)blackFontColor;
//灰色字体（用于正文、辅助展示）
+ (UIColor *)grayFontColor;

#pragma mark - table related
//灰色分隔线
+ (UIColor *)grayLineColor;
//cell selected状态颜色
+ (UIColor *)cellSelectedColor;
//section header背景色
+ (UIColor *)sectionHeaderColor;

#pragma mark - navigation + tab
//背景色
+ (UIColor *)navBackgroundColor;
//tint color
+ (UIColor *)navTintColor;

@end
