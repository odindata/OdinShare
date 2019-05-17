//
//  OdinDevice.h
//  OdinShareSDKUI
//
//  Created by nathan on 2019/4/22.
//  Copyright © 2019 Odin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OdinDevice : NSObject

/**
 *  与当前系统版本比较
 *
 *  @param other 需要对比的版本
 *
 *  @return < 0 低于指定版本； = 0 跟指定版本相同；> 0 高于指定版本
 */
+ (NSInteger)versionCompare:(NSString *)other;



/**
 *  判断当前设备是否为iPad
 *
 *  @return YES 是，NO 否
 */
+ (BOOL)isPad;

@end

NS_ASSUME_NONNULL_END
