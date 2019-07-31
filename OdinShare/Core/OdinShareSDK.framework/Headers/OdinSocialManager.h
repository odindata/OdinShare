//
//  OdinSocialManager.h
//  OdinShareSDK
//
//  Created by nathan on 2019/3/22.
//  Copyright © 2019 Odin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OdinSocialPlatformConfig.h"
#import "OdinSocialMessageObject.h"
@class OdinUser;

NS_ASSUME_NONNULL_BEGIN

@interface OdinSocialManager : NSObject

+ (OdinSocialManager *)defaultManager;
/**
 *  设置平台的appkey
 *
 *  @param platformType 平台类型 @see OdinSocialPlatformType
 *  @param appKey       第三方平台的appKey（QQ平台为appID）
 *  @param appSecret    第三方平台的appSecret（QQ平台为appKey）
 *  @param redirectURL  redirectURL
 */
- (BOOL)setPlaform:(OdinSocialPlatformType)platformType
            appKey:(NSString *)appKey
         appSecret:(nullable NSString *)appSecret
       redirectURL:(nullable NSString *)redirectURL;

/**
 *  分享接口
 *
 *  @param platformType 平台类型 @see OdinSocialPlatformType
 *  @param messageObject
 *  @param currentViewController 用于弹出类似邮件分享、短信分享等这样的系统页面
 *  @param completion   回调
 *  @discuss currentViewController 只正对sms,email等平台需要传入viewcontroller的平台，其他不需要的平台可以传入nil
 */
- (void)shareToPlatform:(OdinSocialPlatformType)platformType
          messageObject:(OdinSocialMessageObject *)messageObject
  currentViewController:(id)currentViewController
             completion:(OdinSocialRequestCompletionHandler)completion;


/**
 *  取消授权
 *
 *  @param platformType 平台类型 @see OdinSocialPlatformType
 *  @param completion   回调
 */
- (void)cancelAuthWithPlatform:(OdinSocialPlatformType)platformType
                    completion:(OdinSocialRequestCompletionHandler)completion;

/**
 *  授权并获取用户信息
 *  @param platformType 平台类型 @see OdinSocialPlatformType
 *  @param currentViewController 用于弹出类似邮件分享、短信分享等这样的系统页面
 *  @param completion   回调
 */
- (void)getUserInfoWithPlatform:(OdinSocialPlatformType)platformType
          currentViewController:(id)currentViewController
                     completion:(OdinSocialRequestCompletionHandler)completion;

/**
 *  获得从sso或者web端回调到本app的回调
 *
 *  @param url 第三方sdk的打开本app的回调的url
 *
 *  @return 是否处理  YES代表处理成功，NO代表不处理
 */
-(BOOL)handleOpenURL:(NSURL *)url;

/**
 *  获得从sso或者web端回调到本app的回调
 *
 *  @param url               第三方sdk的打开本app的回调的url
 *  @param sourceApplication 回调的源程序
 *  @param annotation        annotation
 *
 *  @return 是否处理  YES代表处理成功，NO代表不处理
 *
 *  @note 此函数在6.3版本加入
 */
-(BOOL)handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

/**
 *  获得从sso或者web端回调到本app的回调
 *
 *  @param url     第三方sdk的打开本app的回调的url
 *  @param options 回调的参数
 *
 *  @return 是否处理  YES代表处理成功，NO代表不处理
 *
 *  @note 此函数在6.3版本加入
 */
-(BOOL)handleOpenURL:(NSURL *)url options:(NSDictionary*)options;

- (BOOL)isAuth:(OdinSocialPlatformType)type;


/**
 *  平台是否安装
 *
 *  @param platformType 平台类型 @see UMSocialPlatformType
 *
 *  @return YES 代表安装，NO 代表未安装
 *  @note 调用前请检查是否配置好平台相关白名单
 *  在判断QQ空间的App的时候，QQApi判断会出问题
 */
-(BOOL) isInstall:(OdinSocialPlatformType )platformType;

- (OdinUser *)getUserInfo:(OdinSocialPlatformType )platformType;
@end

NS_ASSUME_NONNULL_END
