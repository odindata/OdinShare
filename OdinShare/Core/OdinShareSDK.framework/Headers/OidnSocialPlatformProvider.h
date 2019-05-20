//
//  OidnSocialPlatformProvider.h
//  OdinShareSDK
//
//  Created by nathan on 2019/3/28.
//  Copyright © 2019 Odin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OdinSocialPlatformConfig.h"
#import "OdinSocialMessageObject.h"
/**
 *  每个平台的必须实现的协议
 */
@protocol OdinSocialPlatformProvider <NSObject>

@optional
/**
 *  当前OdinSocialPlatformType对应操作的OdinSocialPlatformType
 *  @discuss 当前很多平台对应多个平台类型，出现一对多的关系
 *  例如：QQ提供OdinSocialPlatformType_Qzone 和 OdinSocialPlatformType_QQ,用户点击分享或者认证的时候，需要区分用户分享或者认证的对应的哪个平台
 */
@property(nonatomic,assign)OdinSocialPlatformType socialPlatformType;

@property(nonatomic,assign)OdinSocialPlatformType socialLoginPlatformType;

- (BOOL)odin_isInstall:(OdinSocialPlatformType )platformType;
/**
 *  初始化平台
 *
 *  @param appKey      对应的appkey
 *  @param appSecret   对应的appSecret
 *  @param redirectURL 对应的重定向url
 *  @discuss appSecret和redirectURL如果平台必须要的话就传入，不需要就传入nil
 */
-(void)odinSocial_setAppKey:(NSString *)appKey
            withAppSecret:(NSString *)appSecret
          withRedirectURL:(NSString *)redirectURL;

/**
 *  分享
 *
 *  @param object            分享的对象数据模型
 *  @param completionHandler 分享后的回调
 */
-(void)odinSocial_ShareWithObject:(OdinSocialMessageObject *)object
          withCompletionHandler:(OdinSocialShareCompletionHandler)completionHandler;



/**
 *  授权
 *
 *  @param userInfo          用户的授权的自定义数据
 *  @param completionHandler 授权后的回调
 *  @parm  viewController   分享需要的viewController
 *  @discuss userInfo在有些平台可以带入，如果没有就传入nil.
 *           这个函数用于sms,email等需要传入viewController的平台
 */
-(void)odinSocial_AuthorizeWithUserInfo:(NSDictionary *)userInfo
                   withViewController:(UIViewController*)viewController
                withCompletionHandler:(OdinSocialAuthCompletionHandler)completionHandler;

/**
 *  授权成功后获得用户的信息
 *
 *  @param completionHandler 请求的回调
 */
-(void)odinSocial_RequestForUserProfileWithCompletionHandler:(OdinSocialGetUserInfoCompletionHandler)completionHandler;

/**
 *  取消授权
 *
 *  @param completionHandler 授权后的回调
 *  @discuss userInfo在有些平台可以带入，如果没有就传入nil.
 */
-(void)odinSocial_cancelAuthWithCompletionHandler:(OdinSocialRequestCompletionHandler)completionHandler;

/**
 *  获得从sso或者web端回调到本app的回调
 *
 *  @param url 第三方sdk的打开本app的回调的url
 *
 *  @return 是否处理  YES代表处理成功，NO代表不处理
 */
-(BOOL)odinSocial_handleOpenURL:(NSURL *)url;
-(BOOL)odinSocial_handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
-(BOOL)odinSocial_handleOpenURL:(NSURL *)url options:(NSDictionary*)options;

@end
