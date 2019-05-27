//
//  OdinColor.m
//  OdinShareSDKUI
//
//  Created by nathan on 2019/4/22.
//  Copyright © 2019 Odin. All rights reserved.
//

#import "OdinColor.h"

@implementation OdinColor

+ (UIColor *)colorWithRGB:(NSUInteger)rgb
{
    CGFloat b = (rgb & 0xff) / 255.0;
    CGFloat g = (rgb >> 8 & 0xff) / 255.0;
    CGFloat r = (rgb >> 16 & 0xff) / 255.0;
    
    return [UIColor colorWithRed:r green:g blue:b alpha:1];
}

+ (UIColor *)colorWithARGB:(NSUInteger)argb
{
    CGFloat b = (argb & 0xff) / 255.0;
    CGFloat g = (argb >> 8 & 0xff) / 255.0;
    CGFloat r = (argb >> 16 & 0xff) / 255.0;
    CGFloat a = (argb >> 24 & 0xff) / 255.0;
    
    return [UIColor colorWithRed:r green:g blue:b alpha:a];
}

@end
