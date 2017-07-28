//
//  UIImageScale.h
//  caidian
//
//  Created by  heyang on 1/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImage (scale)

-(UIImage *)scaleToSize:(CGSize)size;
-(UIImage *)scaleToMaximumSize:(CGSize)size;
-(UIImage *)scaleToMinimumSize:(CGSize)size;
-(UIImage *)pixelScaleToMinimumSize:(CGSize)size;
-(UIImage *)retinaScaleToMaximumSize:(CGSize)size;
-(UIImage *)retinaScaleToMinimumSize:(CGSize)size;

-(UIImage *)scaleCropToSize:(CGSize)size;

-(UIImage *)getSubImage:(CGRect)rect;
-(UIImage *)scaleToFitSize:(CGSize)size;

-(UIImage *)cropRect:(CGRect)cropRect aspectFitBounds:(CGSize)finalImageSize fillColor:(UIColor *)fillColor;

- (UIImage *) resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality;

@end
