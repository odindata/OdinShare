//
//  MOBFImageUtils.m
//  MOBFoundation
//
//  Created by vimfung on 15-1-19.
//  Copyright (c) 2015年 MOB. All rights reserved.
//

#import "OdinFImage.h"

@implementation OdinFImage

+ (UIImage *)clipImage:(UIImage *)image withRect:(CGRect)rect
{
    if (![image isKindOfClass:[UIImage class]])
    {
        return nil;
    }
    
    rect.origin.x = rect.origin.x < 0 ? 0 : rect.origin.x;
    rect.origin.y = rect.origin.y < 0 ? 0 : rect.origin.y;
    rect.size.width = rect.size.width < 0 ? 0 : rect.size.width;
    rect.size.height = rect.size.height < 0 ? 0 : rect.size.height;
    
    if (CGRectIsEmpty(rect))
    {
        //空图片对象
        return [UIImage new];
    }
    
    switch (image.imageOrientation)
    {
        case UIImageOrientationLeft:
            rect = CGRectMake(rect.origin.y,
                              rect.origin.x,
                              rect.size.height,
                              rect.size.width);
            break;
        case UIImageOrientationRight:
            rect = CGRectMake(rect.origin.y,
                              image.size.width - rect.size.width - rect.origin.x,
                              rect.size.height,
                              rect.size.width);
            break;
        case UIImageOrientationDown:
            rect = CGRectMake(image.size.width - rect.size.width - rect.origin.x,
                              image.size.height - rect.size.height - rect.origin.y,
                              rect.size.width,
                              rect.size.height);
            break;
        default:
            break;
    }
    
    CGImageRef clipImageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    
    CGRect clipBounds = CGRectMake(0, 0, CGImageGetWidth(clipImageRef), CGImageGetHeight(clipImageRef));
    
    UIGraphicsBeginImageContext(clipBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, clipBounds, clipImageRef);
    UIImage* clipImage = [UIImage imageWithCGImage:clipImageRef
                                             scale:image.scale
                                       orientation:image.imageOrientation];
    
    CGImageRelease(clipImageRef);
    UIGraphicsEndImageContext();
    
    return clipImage;
}

+ (UIImage *)roundRectImage:(UIImage *)image
                   withSize:(CGSize)size
                  ovalWidth:(CGFloat)ovalWidth
                 ovalHeight:(CGFloat)ovalHeight
                   ovalType:(MOBFOvalType)ovalType
{
    if (![image isKindOfClass:[UIImage class]])
    {
        return nil;
    }
    
    size.width = size.width < 0 ? 0 : size.width;
    size.height = size.height < 0 ? 0 : size.height;
    
    if (size.width == 0 || size.height == 0)
    {
        //空对象
        return [UIImage new];
    }
    
    int w = size.width;
    int h = size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
    CGRect rect = CGRectMake(0, 0, w, h);
    
    CGContextBeginPath(context);
    [self drawRoundedRectWithContext:context rect:rect ovalWidth:ovalWidth ovalHeight:ovalHeight ovalType:ovalType];
    CGContextClosePath(context);
    
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), image.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    UIImage * targetImage = [UIImage imageWithCGImage:imageMasked];
    CGImageRelease(imageMasked);
    
    return targetImage;
}

+ (UIImage *)scaleImage:(UIImage *)image withSize:(CGSize)size
{
    if (![image isKindOfClass:[UIImage class]])
    {
        return nil;
    }
    
    size.width = size.width < 0 ? 0 : size.width;
    size.height = size.height < 0 ? 0 : size.height;
    
    if (size.width == 0 || size.height == 0)
    {
        return [UIImage new];
    }
    
    CGFloat w = image.size.width;
    CGFloat h = image.size.height;
    
    UIImage *resultImg = nil;
    
    CGFloat b = (CGFloat)size.width / w < (CGFloat)size.height / h ? (CGFloat)size.width / w : (CGFloat)size.height / h;
    CGSize itemSize = CGSizeMake(b * w, b * h);
    
    UIGraphicsBeginImageContext(itemSize);
    CGRect imageRect = CGRectMake(0, 0, b*w, b*h);
    [image drawInRect:imageRect];
    resultImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImg;
}

+ (UIImage *)imageName:(NSString *)name bundle:(NSBundle *)bundle
{
    if (![name isKindOfClass:[NSString class]] || ![bundle isKindOfClass:[NSBundle class]])
    {
        return nil;
    }
    
    NSRange range = [name rangeOfString:[NSString stringWithFormat:@".%@",[name pathExtension]]];
    if (range.location != NSNotFound)
    {
        NSString *fileName = [name substringToIndex:range.location];
        NSString *path = [bundle pathForResource:fileName ofType:[name pathExtension]];
        return [UIImage imageWithContentsOfFile:path];
    }
    
    return nil;
}

+ (UIImage *)imageByView:(UIView *)view
{
    return [self imageByView:view opaque:YES];
}

+ (UIImage *)imageByView:(UIView *)view opaque:(BOOL)opaque
{
    if (![view isKindOfClass:[UIView class]])
    {
        return nil;
    }
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - Private

+ (void)drawRoundedRectWithContext:(CGContextRef)context
                              rect:(CGRect)rect
                         ovalWidth:(CGFloat)ovalWidth
                        ovalHeight:(CGFloat)ovalHeight
                          ovalType:(MOBFOvalType)ovalType
{
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0)
    {
        CGContextAddRect(context, rect);
        return;
    }
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect) / ovalWidth;
    fh = CGRectGetHeight(rect) / ovalHeight;
    
    CGContextMoveToPoint(context, fw, fh/2);  // Start at lower right corner
    if (ovalType & MOBFOvalTypeRightTop)
    {
        CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);  // Top right corner
    }
    else
    {
        CGContextAddLineToPoint(context, fw, fh);
    }
    
    if (ovalType & MOBFOvalTypeLeftTop)
    {
        CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // Top left corner
    }
    else
    {
        CGContextAddLineToPoint(context, 0, fh);
    }
    
    if (ovalType & MOBFOvalTypeLeftBottom)
    {
        CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // Lower left corner
    }
    else
    {
        CGContextAddLineToPoint(context, 0, 0);
    }
    
    if (ovalType & MOBFOvalTypeRightBottom)
    {
        CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // Back to lower right
    }
    else
    {
        CGContextAddLineToPoint(context, fw, 0);
    }
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

@end
