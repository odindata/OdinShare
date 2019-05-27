//
//  OdinSocialResponse.h
//  OdinShareSDK
//
//  Created by nathan on 2019/3/26.
//  Copyright © 2019 Odin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OdinSocialResponse : NSObject
@property (nonatomic, copy) NSString  *uid;//用户id
@property (nonatomic, copy) NSString  *openid;//QQ，微信用户openid，其他平台没有
@property (nonatomic, copy) NSString  *refreshToken;//
@property (nonatomic, copy) NSDate    *expiration;//授权token（accessToken）过期时间
@property (nonatomic, copy) NSString  *accessToken;
@property (nonatomic, copy) NSString  *unionId;
/**
 usid 兼容U-Share 4.x/5.x 版本，与4/5版本数值相同
 即，对应微信平台：openId，QQ平台openId，其他平台不变
 */
@property (nonatomic, copy) NSString  *usid;
@property (nonatomic, assign) OdinSocialPlatformType  platformType;//对应的平台类型
/**
 * 第三方原始数据
 */
@property (nonatomic, strong) id  originalResponse;
@end


@interface OdinSocialShareResponse : OdinSocialResponse

@property (nonatomic, copy) NSString  *message;

+ (OdinSocialShareResponse *)shareResponseWithMessage:(NSString *)message;

@end

@interface OdinSocialAuthResponse : OdinSocialResponse

@end

@interface OdinSocialUserInfoResponse : OdinSocialResponse

/**
 第三方平台昵称
 */
@property (nonatomic, copy) NSString  *name;

/**
 第三方平台头像地址
 */
@property (nonatomic, copy) NSString  *iconurl;

/**
 通用平台性别属性
 QQ、微信、微博返回 "男", "女"
 Facebook返回 "male", "female"
 */
@property (nonatomic, copy) NSString  *unionGender;

@property (nonatomic, copy) NSString  *gender;

@end

NS_ASSUME_NONNULL_END
