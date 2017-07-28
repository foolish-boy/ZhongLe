
#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>
#import <UIKit/UIKit.h>

@interface UIImage (EX)

+ (UIImage *)alphaImage:(CGFloat)alpha width:(CGFloat)width height:(CGFloat)height;

+ (UIImage *)imageWithColor:(UIColor *)color withSize:(CGSize)size;

- (UIImage*)iconImageWithWidth:(double)width height:(double)height cornerRadius:(double)radius;
- (UIImage*)iconImageWithWidth:(double)width height:(double)height cornerRadius:(double)radius border:(double)border borderColor:(UIColor*)color;

- (UIImage*)iconAvatarImageWithWidth:(double)width cornerRadius:(double)radius;
- (UIImage*)iconImageWithWidth:(double)width cornerRadius:(double)radius;
- (UIImage*)iconImageWithWidth:(double)width cornerRadius:(double)radius border:(double)border borderColor:(UIColor*)color;

//上圆角
- (UIImage *)topCornerWithWidth:(double)width height:(double)height cornerRadius:(double)radius;

//下圆角
- (UIImage *)bottomCornerWithWidth:(double)width height:(double)height cornerRadius:(double)radius;

//中间不变 两边拉伸
- (UIImage *)stretchableBothSides:(CGFloat)left width:(CGFloat)toWidth;

//上下不变 拉中间
- (UIImage *)stretchableTopBottom:(int)top height:(CGFloat)toHeight local:(BOOL)isLocal;

- (UIImage*)stretchableTop:(int)top left:(int)left size:(CGSize)size;

- (UIImage*)circleImage;
- (UIImage*)grayImage;
- (UIImage*)linghtImage;
- (UIImage*)scaleToSize:(CGSize)size;
- (UIImage*)scaleToSize:(CGSize)size tiled:(BOOL)tiled;
- (UIImage*)stackBlur:(NSUInteger)inradius;

- (UIImage *)addCorner:(UIImage *)cornerIcon;

- (UIImage *)imageByApplyingAlpha:(CGFloat) alpha;

/**
 修正照片方向
 */
- (UIImage *)fixOrientation;

+(UIImage*)imageFromSampleBuffer:(CMSampleBufferRef)nextBuffer;
+(UIImage*)cropImage:(UIImage*)originalImage withRect:(CGRect)inRect;
+(UIImage*)getSafeImage:(UIImage*)inImg;

/**
 Image drawn with bazier path.
 @param path The bezier path to draw.
 @param color The stroke color for bezier path.
 @param backgroundColor The fill color for bezier path.
 */
+ (UIImage *)imageWithBezierPath:(UIBezierPath *)path color:(UIColor *)color backgroundColor:(UIColor *)backgroundColor;

+ (UIImage *)roundedImageWithSize:(CGSize)size color:(UIColor *)color radius:(CGFloat)radius;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

- (UIImage *)clipImageWithPath:(CGMutablePathRef)path;

- (UIImage *)mergeImagesAndRects:(UIImage *)firstImage, ... NS_REQUIRES_NIL_TERMINATION;

- (UIImage *)mergeImage:(UIImage *)imageB atPoint:(CGPoint)startPoint alpha:(float)alpha;

- (UIImage*)maskImage:(UIImage *)maskImage;

- (UIImage*)stretchWithInsets:(UIEdgeInsets)insets;
@end
