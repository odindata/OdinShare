//
//  OdinSocialHandler.h
//  OdinShareSDK
//
//  Created by nathan on 2019/3/28.
//  Copyright © 2019 Odin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OidnSocialPlatformProvider.h"

NS_ASSUME_NONNULL_BEGIN

@interface OdinSocialHandler : NSObject<OdinSocialPlatformProvider>

#pragma mark - 子类需要重载的类
//+(void)load;
+(NSArray*) socialPlatformTypes;
+ (instancetype)defaultManager;

#pragma mark -

@property (nonatomic, copy) NSString *appID;

@property (nonatomic, copy) NSString *appSecret;

@property (nonatomic, copy) NSString *redirectURL;


/**
 * 当前ViewController（用于一些特定平台弹出相应的页面，默认使用当前ViewController）
 * since 6.3把currentViewController修改为弱引用，防止用户传入后强引用用户传入的UIViewController，导致内存不释放，
 * 注意：如果传入currentViewController的时候，一定要保证在（执行对应的分享，授权，获得用户信息的接口需要传入此接口的时候）存在，否则导致弱引用为nil,没有弹出界面的效果。
 */
@property (nonatomic, weak) UIViewController *currentViewController;

@property (nonatomic, copy) OdinSocialShareCompletionHandler shareCompletionBlock;

@property (nonatomic, copy) OdinSocialAuthCompletionHandler authCompletionBlock;

@property (nonatomic, copy) OdinSocialGetUserInfoCompletionHandler userinfoCompletionBlock;

@end

NS_ASSUME_NONNULL_END
