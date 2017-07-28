//
//  ZLPlayingAnimationView.m
//  ZhongLe
//
//  Created by jasonwu on 2017/7/13.
//  Copyright © 2017年 jasonwu. All rights reserved.
//

#import "ZLPlayingAnimationView.h"
#import "UIColor+App.h"

@interface ZLPlayingAnimationView ()

@property (nonatomic, strong) UIView    *jumpingLineOne;
@property (nonatomic, strong) UIView    *jumpingLineTwo;
@property (nonatomic, strong) UIView    *jumpingLineThree;
@property (nonatomic, strong) UIView    *jumpingLineFour;

@property (nonatomic, assign) float     originYOne;
@property (nonatomic, assign) float     originYTwo;
@property (nonatomic, assign) float     originYThree;
@property (nonatomic, assign) float     originYFour;

@end

static const float lineWidth = 2.0;
static const float lineGap   = 2.0;

@implementation ZLPlayingAnimationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.jumpingLineOne];
        [self addSubview:self.jumpingLineTwo];
        [self addSubview:self.jumpingLineThree];
        [self addSubview:self.jumpingLineFour];
        
        float oneHeight = frame.size.height/2.0;
        float twoHeight = frame.size.height;
        float threeHeight = frame.size.height/2.0;
        float fourHeight = frame.size.height * 2.0/3.0;
        
        _originYOne = frame.size.height - oneHeight;
        _originYTwo = frame.size.height - twoHeight;
        _originYThree = frame.size.height - threeHeight;
        _originYFour = frame.size.height - fourHeight;
        self.jumpingLineOne.frame = CGRectMake(0, _originYOne, lineWidth, oneHeight);
        self.jumpingLineTwo.frame = CGRectMake(lineWidth + lineGap, _originYTwo, lineWidth, twoHeight);
        self.jumpingLineThree.frame = CGRectMake((lineWidth + lineGap) * 2, _originYThree, lineWidth, threeHeight);
        self.jumpingLineFour.frame = CGRectMake((lineWidth + lineGap) * 3, _originYFour, lineWidth, fourHeight);
        
    }
    return self;
}
#pragma mark - 动画

- (void)startAnimation {
    //change
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse animations:^{
        CGRect frameOne = self.jumpingLineOne.frame;
        frameOne.origin.y = 5;
        frameOne.size.height =self.frame.size.height - frameOne.origin.y;
        self.jumpingLineOne.frame = frameOne;
        
        CGRect frameTwo = self.jumpingLineTwo.frame;
        frameTwo.origin.y = self.frame.size.height/2.0;
        frameTwo.size.height =self.frame.size.height - frameTwo.origin.y;
        self.jumpingLineTwo.frame = frameTwo;
        
        CGRect frameThree = self.jumpingLineThree.frame;
        frameThree.origin.y = 0;
        frameThree.size.height =self.frame.size.height - frameThree.origin.y;
        frameThree.size.height = self.frame.size.height;
        self.jumpingLineThree.frame = frameThree;
        
        CGRect frameFour = self.jumpingLineFour.frame;
        frameFour.origin.y = self.frame.size.height/2.0;
        frameFour.size.height =self.frame.size.height - frameFour.origin.y;
        self.jumpingLineFour.frame = frameFour;
    } completion:^(BOOL finished) {

    }];

}

- (void)stopAnimation {
    [self.jumpingLineOne.layer removeAllAnimations];
    [self.jumpingLineTwo.layer removeAllAnimations];
    [self.jumpingLineThree.layer removeAllAnimations];
    [self.jumpingLineFour.layer removeAllAnimations];

    CGRect frameOne = self.jumpingLineOne.frame;
    frameOne.origin.y = _originYOne;
    frameOne.size.height =self.frame.size.height - frameOne.origin.y;
    self.jumpingLineOne.frame = frameOne;

    CGRect frameTwo = self.jumpingLineTwo.frame;
    frameTwo.origin.y = _originYTwo;
    frameTwo.size.height =self.frame.size.height - frameTwo.origin.y;
    self.jumpingLineTwo.frame = frameTwo;

    CGRect frameThree = self.jumpingLineThree.frame;
    frameThree.origin.y = _originYThree;
    frameThree.size.height =self.frame.size.height - frameThree.origin.y;
    self.jumpingLineThree.frame = frameThree;

    CGRect frameFour = self.jumpingLineFour.frame;
    frameFour.origin.y = _originYFour;
    frameFour.size.height =self.frame.size.height - frameFour.origin.y;
    self.jumpingLineFour.frame = frameFour;
}

#pragma mark - lazy load
- (UIView *)jumpingLineOne {
    if (!_jumpingLineOne) {
        _jumpingLineOne = [UIView new];
        _jumpingLineOne.backgroundColor = [UIColor greenThemeColor];
    }
    return _jumpingLineOne;
}
- (UIView *)jumpingLineTwo {
    if (!_jumpingLineTwo) {
        _jumpingLineTwo = [UIView new];
        _jumpingLineTwo.backgroundColor = [UIColor greenThemeColor];
    }
    return _jumpingLineTwo;
}
- (UIView *)jumpingLineThree {
    if (!_jumpingLineThree) {
        _jumpingLineThree = [UIView new];
        _jumpingLineThree.backgroundColor = [UIColor greenThemeColor];
    }
    return _jumpingLineThree;
}
- (UIView *)jumpingLineFour {
    if (!_jumpingLineFour) {
        _jumpingLineFour = [UIView new];
        _jumpingLineFour.backgroundColor = [UIColor greenThemeColor];
    }
    return _jumpingLineFour;
}
@end
