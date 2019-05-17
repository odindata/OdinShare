//
//  OdinColor.h
//  OdinShareSDKUI
//
//  Created by nathan on 2019/4/22.
//  Copyright © 2019 Odin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OdinColor : NSObject

/**
 *  获取颜色对象
 *
 *  @param rgb RGB颜色值
 *
 *  @return 颜色对象
 */
+ (UIColor *)colorWithRGB:(NSUInteger)rgb;

/**
 *  获取颜色对象
 *
 *  @param argb ARGB颜色值
 *
 *  @return 颜色对象
 */
+ (UIColor *)colorWithARGB:(NSUInteger)argb;


@end

NS_ASSUME_NONNULL_END
