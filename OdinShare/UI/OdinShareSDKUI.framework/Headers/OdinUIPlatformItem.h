//
//  OdinUIPlatformItem.h
//  OdinShareSDKUI
//
//  Created by nathan on 2019/4/22.
//  Copyright © 2019 Odin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <OdinShareSDK/OdinSocialPlatformConfig.h>

NS_ASSUME_NONNULL_BEGIN

@interface OdinUIPlatformItem : NSObject

+ (instancetype)itemWithPlatformType:(OdinSocialPlatformType)platformType;

@property (copy, nonatomic) NSString *platformId;
@property (strong, nonatomic)  UIImage *iconNormal;
@property (strong, nonatomic)  UIImage *iconSimple;
@property (strong, nonatomic)  NSString *platformName;
@property (assign, nonatomic)  OdinSocialPlatformType platformType;
- (void)addTarget:(id)target action:(SEL)selector;

/**
 *  触发点击
 */
- (void)triggerClick;

@end

NS_ASSUME_NONNULL_END
