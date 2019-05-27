//
//  OdinImage.m
//  OdinShareSDKUI
//
//  Created by nathan on 2019/4/22.
//  Copyright © 2019 Odin. All rights reserved.
//

#import "OdinImage.h"

@implementation OdinImage

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

@end
