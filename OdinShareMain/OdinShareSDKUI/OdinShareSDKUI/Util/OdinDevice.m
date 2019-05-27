//
//  OdinDevice.m
//  OdinShareSDKUI
//
//  Created by nathan on 2019/4/22.
//  Copyright © 2019 Odin. All rights reserved.
//

#import "OdinDevice.h"

@implementation OdinDevice


+ (NSInteger)versionCompare:(NSString *)other
{
    if (![other isKindOfClass:[NSString class]])
    {
        //非法版本号都视为比当前版本要低
        return NSOrderedDescending;
    }
    
    NSArray *oneComponents =
    [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"a"];
    NSArray *twoComponents = [other componentsSeparatedByString:@"a"];
    
    NSArray *oneVerComponents = nil;
    NSArray *twoVerComponents = nil;
    
    if (oneComponents.count > 0) {
        oneVerComponents = [oneComponents[0] componentsSeparatedByString:@"."];
    }
    
    if (twoComponents.count > 0) {
        twoVerComponents = [twoComponents[0] componentsSeparatedByString:@"."];
    }
    
    __block NSComparisonResult mainDiff = NSOrderedSame;
    [oneVerComponents
     enumerateObjectsUsingBlock:^(NSString *_Nonnull obj, NSUInteger idx,
                                  BOOL *_Nonnull stop) {
         
         NSInteger oneVer = [obj integerValue];
         if (twoVerComponents.count > idx) {
             NSInteger twoVer = [twoVerComponents[idx] integerValue];
             if (oneVer > twoVer) {
                 mainDiff = NSOrderedDescending;
                 *stop = YES;
             } else if (oneVer < twoVer) {
                 mainDiff = NSOrderedAscending;
                 *stop = YES;
             }
             
         } else {
             mainDiff = NSOrderedDescending;
             *stop = YES;
         }
         
     }];
    
    if (mainDiff != NSOrderedSame) {
        return mainDiff;
    }
    
    if (oneVerComponents.count < twoVerComponents.count) {
        //比较版本号比设备版本号多一个子版本部分的时候，证明比较版本号的版本较高
        return NSOrderedAscending;
    }
    
    //
    //    // The parts before the "a"
    //    NSString *oneMain = [oneComponents objectAtIndex:0];
    //    NSString *twoMain = [twoComponents objectAtIndex:0];
    //
    //    // If main parts are different, return that result, regardless of alpha
    //    part
    //    NSComparisonResult mainDiff;
    //    if ((mainDiff = [oneMain compare:twoMain]) != NSOrderedSame)
    //    {
    //        return mainDiff;
    //    }
    //
    // At this point the main parts are the same; just deal with alpha stuff
    // If one has an alpha part and the other doesn't, the one without is newer
    if ([oneComponents count] < [twoComponents count]) {
        return NSOrderedDescending;
        
    } else if ([oneComponents count] > [twoComponents count]) {
        return NSOrderedAscending;
        
    } else if ([oneComponents count] == 1) {
        // Neither has an alpha part, and we know the main parts are the same
        return NSOrderedSame;
    }
    
    // At this point the main parts are the same and both have alpha parts.
    // Compare the alpha parts
    // numerically. If it's not a valid number (including empty string) it's
    // treated as zero.
    NSNumber *oneAlpha =
    [NSNumber numberWithInt:[[oneComponents objectAtIndex:1] intValue]];
    NSNumber *twoAlpha =
    [NSNumber numberWithInt:[[twoComponents objectAtIndex:1] intValue]];
    
    return [oneAlpha compare:twoAlpha];
}


+ (BOOL)isPad
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        return YES;
    }
    return NO;
}

@end
