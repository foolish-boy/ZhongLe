//
//  UIImageScale.m
//  caidian
//
//  Created by  heyang on 1/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIImageScale.h"


@implementation UIImage (scale)

-(UIImage*)scaleToSize:(CGSize)size {
    
	UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    if (self.size.width * size.height == size.width * self.size.height) {
        [self drawInRect:CGRectMake(0,0,size.width,size.height)];
    } else if (self.size.width * size.height > size.width * self.size.height) { // width is large
        float height = size.width * self.size.height / self.size.width;
        [self drawInRect:CGRectMake(0, (size.height - height) / 2, size.width, height)];
    } else { // height is large
        float width = size.height * self.size.width / self.size.height;
        [self drawInRect:CGRectMake((size.width - width) / 2, 0, width, size.height)];
    }
	UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return scaledImage;
}

-(UIImage*)scaleToMaximumSize:(CGSize)size {
    if (fabs(self.size.width / self.size.height - size.width / size.height) > fabs(self.size.width / self.size.height - size.height / size.width)) {
        float tmp = size.width;
        size.width = size.height;
        size.height = tmp;
    }
    if (self.size.width * size.height == size.width * self.size.height) {
        UIGraphicsBeginImageContext(size);
        [self drawInRect:CGRectMake(0,0,size.width,size.height)];
    } else if (self.size.width * size.height > size.width * self.size.height) { // width is large
        float height = size.width * self.size.height / self.size.width;
        UIGraphicsBeginImageContext(CGSizeMake(size.width, floor(height)));
        [self drawInRect:CGRectMake(0, 0, size.width, height)];
    } else { // height is large
        float width = size.height * self.size.width / self.size.height;
        UIGraphicsBeginImageContext(CGSizeMake(floor(width), size.height));
        [self drawInRect:CGRectMake(0, 0, width, size.height)];
    }
	UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return scaledImage;
}

-(UIImage*)scaleToMinimumSize:(CGSize)size {
	UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    if (self.size.width * size.height == size.width * self.size.height) {
        [self drawInRect:CGRectMake(0,0,size.width,size.height)];
    } else if (self.size.width * size.height > size.width * self.size.height) { // width is large
        float width = size.height * self.size.width / self.size.height;
        [self drawInRect:CGRectMake(- (width - size.width) / 2, 0, width, size.height)];
    } else { // height is large
        float height = size.width * self.size.height / self.size.width;
        [self drawInRect:CGRectMake(0, - (height - size.height) / 2, size.width, height)];
    }
	UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return scaledImage;
}

-(UIImage*)pixelScaleToMinimumSize:(CGSize)size {
	UIGraphicsBeginImageContext(size);
    if (self.size.width * size.height == size.width * self.size.height) {
        [self drawInRect:CGRectMake(0,0,size.width,size.height)];
    } else if (self.size.width * size.height > size.width * self.size.height) { // width is large
        float width = size.height * self.size.width / self.size.height;
        [self drawInRect:CGRectMake(- (width - size.width) / 2, 0, width, size.height)];
    } else { // height is large
        float height = size.width * self.size.height / self.size.width;
        [self drawInRect:CGRectMake(0, - (height - size.height) / 2, size.width, height)];
    }
	UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return scaledImage;
}

-(UIImage*)retinaScaleToMaximumSize:(CGSize)size {
    if (fabs(self.size.width / self.size.height - size.width / size.height) > fabs(self.size.width / self.size.height - size.height / size.width)) {
        float tmp = size.width;
        size.width = size.height;
        size.height = tmp;
    }
    if (self.size.width * size.height == size.width * self.size.height) {
        UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
        [self drawInRect:CGRectMake(0,0,size.width,size.height)];
    } else if (self.size.width * size.height > size.width * self.size.height) { // width is large
        float height = size.width * self.size.height / self.size.width;
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(size.width, floor(height)), NO, [UIScreen mainScreen].scale);
        [self drawInRect:CGRectMake(0, 0, size.width, height)];
    } else { // height is large
        float width = size.height * self.size.width / self.size.height;
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(floor(width), size.height), NO, [UIScreen mainScreen].scale);
        [self drawInRect:CGRectMake(0, 0, width, size.height)];
    }
	UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return scaledImage;
}

-(UIImage*)retinaScaleToMinimumSize:(CGSize)size {
	UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    if (self.size.width * size.height == size.width * self.size.height) {
        [self drawInRect:CGRectMake(0,0,size.width,size.height)];
    } else if (self.size.width * size.height > size.width * self.size.height) { // width is large
        float width = size.height * self.size.width / self.size.height;
        [self drawInRect:CGRectMake(- (width - size.width) / 2, 0, width, size.height)];
    } else { // height is large
        float height = size.width * self.size.height / self.size.width;
        [self drawInRect:CGRectMake(0, - (height - size.height) / 2, size.width, height)];
    }
	UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return scaledImage;
}

-(UIImage *)scaleCropToSize:(CGSize)size {
	UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    if (self.size.width * size.height == size.width * self.size.height) {
        [self drawInRect:CGRectMake(0,0,size.width,size.height)];
    } else if (self.size.width * size.height > size.width * self.size.height) { // width is large
        float width = self.size.height * size.width / size.height;
        [self drawInRect:CGRectMake((width - self.size.width) / 2, 0, width, self.size.height)];
    } else { // height is large
        float height = self.size.width * size.height / size.width;
        [self drawInRect:CGRectMake(0, (height - self.size.height) / 2, self.size.width, height)];
    }
	UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return scaledImage;
}

//截取部分图像
-(UIImage*)getSubImage:(CGRect)rect
{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    CGImageRelease(subImageRef);
    return smallImage;
}

- (UIImage*)scaleToFitSize:(CGSize)size {
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    float verticalRadio = size.height*1.0/height;
    float horizontalRadio = size.width*1.0/width;
    float radio = 1;
    if(verticalRadio>1 && horizontalRadio>1)
    {
        radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;
    }
    else
    {
        radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio;
    }
    width = width*radio;
    height = height*radio;
    int xPos = (size.width - width)/2;
    int yPos = (size.height-height)/2;
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(xPos, yPos, width, height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}


// CropRect is assumed to be in UIImageOrientationUp, as it is delivered this way from the UIImagePickerController when using AllowsImageEditing is on.
// The sourceImage can be in any orientation, the crop will be transformed to match
// The output image bounds define the final size of the image, the image will be scaled to fit,(AspectFit) the bounds, the fill color will be
// used for areas that are not covered by the scaled image.
-(UIImage *)cropRect:(CGRect)cropRect aspectFitBounds:(CGSize)finalImageSize fillColor:(UIColor *)fillColor {
    
    CGImageRef sourceImageRef = self.CGImage;
    
    //Since the crop rect is in UIImageOrientationUp we need to transform it to match the source image.
    CGAffineTransform rectTransform = [self transformSize:self.size orientation:self.imageOrientation];
    CGRect transformedRect = CGRectApplyAffineTransform(cropRect, rectTransform);
    
    //Now we get just the region of the source image that we are interested in.
    CGImageRef cropRectImage = CGImageCreateWithImageInRect(sourceImageRef, transformedRect);
    
    //Figure out which dimension fits within our final size and calculate the aspect correct rect that will fit in our new bounds
    CGFloat horizontalRatio = finalImageSize.width / CGImageGetWidth(cropRectImage);
    CGFloat verticalRatio = finalImageSize.height / CGImageGetHeight(cropRectImage);
    CGFloat ratio = MAX(horizontalRatio, verticalRatio); //Aspect fill
    CGSize aspectFitSize = CGSizeMake(CGImageGetWidth(cropRectImage) * ratio, CGImageGetHeight(cropRectImage) * ratio);
    
    
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 finalImageSize.width,
                                                 finalImageSize.height,
                                                 CGImageGetBitsPerComponent(cropRectImage),
                                                 0,
                                                 CGImageGetColorSpace(cropRectImage),
                                                 CGImageGetBitmapInfo(cropRectImage));
    
    if (context == NULL) {
        NSLog(@"NULL CONTEXT!");
    }
    
    //Fill with our background color
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, finalImageSize.width, finalImageSize.height));
    
    //We need to rotate and transform the context based on the orientation of the source image.
    CGAffineTransform contextTransform = [self transformSize:finalImageSize orientation:self.imageOrientation];
    CGContextConcatCTM(context, contextTransform);
    
    //Give the context a hint that we want high quality during the scale
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    
    //Draw our image centered vertically and horizontally in our context.
    CGContextDrawImage(context, CGRectMake((finalImageSize.width-aspectFitSize.width)/2, (finalImageSize.height-aspectFitSize.height)/2, aspectFitSize.width, aspectFitSize.height), cropRectImage);
    
    //Start cleaning up..
    CGImageRelease(cropRectImage);
    
    CGImageRef finalImageRef = CGBitmapContextCreateImage(context);
    UIImage *finalImage = [UIImage imageWithCGImage:finalImageRef];
    
    CGContextRelease(context);
    CGImageRelease(finalImageRef);
    return finalImage;
}

//Creates a transform that will correctly rotate and translate for the passed orientation.
//Based on code from niftyBean.com
- (CGAffineTransform) transformSize:(CGSize)imageSize orientation:(UIImageOrientation)orientation {
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (orientation) {
        case UIImageOrientationLeft: { // EXIF #8
            CGAffineTransform txTranslate = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            CGAffineTransform txCompound = CGAffineTransformRotate(txTranslate,M_PI_2);
            transform = txCompound;
            break;
        }
        case UIImageOrientationDown: { // EXIF #3
            CGAffineTransform txTranslate = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            CGAffineTransform txCompound = CGAffineTransformRotate(txTranslate,M_PI);
            transform = txCompound;
            break;
        }
        case UIImageOrientationRight: { // EXIF #6
            CGAffineTransform txTranslate = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            CGAffineTransform txCompound = CGAffineTransformRotate(txTranslate,-M_PI_2);
            transform = txCompound;
            break;
        }
        case UIImageOrientationUp: // EXIF #1 - do nothing
        default: // EXIF 2,4,5,7 - ignore
            break;
    }
    return transform;
    
}

- (UIImage *) resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality {
    BOOL drawTransposed;
    
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            drawTransposed = YES;
            break;
            
        default:
            drawTransposed = NO;
    }
    
    return [self resizedImage:newSize
                    transform:[self transformForOrientation:newSize]
               drawTransposed:drawTransposed
         interpolationQuality:quality];
}

- (UIImage *) resizedImage:(CGSize)newSize
                 transform:(CGAffineTransform)transform
            drawTransposed:(BOOL)transpose
      interpolationQuality:(CGInterpolationQuality)quality {
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGRect transposedRect = CGRectMake(0, 0, newRect.size.height, newRect.size.width);
    CGImageRef imageRef = self.CGImage;
    
    // Build a context that's the same dimensions as the new size
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                newRect.size.width,
                                                newRect.size.height,
                                                CGImageGetBitsPerComponent(imageRef),
                                                0,
                                                CGImageGetColorSpace(imageRef),
                                                CGImageGetBitmapInfo(imageRef));
    
    // Rotate and/or flip the image if required by its orientation
    CGContextConcatCTM(bitmap, transform);
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(bitmap, quality);
    
    // Draw into the context; this scales the image
    CGContextDrawImage(bitmap, transpose ? transposedRect : newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
    UIImage * newImage = [UIImage imageWithCGImage:newImageRef];
    
    // Clean up
    CGContextRelease(bitmap);
    CGImageRelease(newImageRef);
    
    return newImage;
} /* resizedImage */

- (CGAffineTransform) transformForOrientation:(CGSize)newSize {
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:           // EXIF = 3
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, newSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:           // EXIF = 6
        case UIImageOrientationLeftMirrored:   // EXIF = 5
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:          // EXIF = 8
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, 0, newSize.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    } /* switch */
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:     // EXIF = 2
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:   // EXIF = 5
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, newSize.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    return transform;
} /* transformForOrientation */


@end
