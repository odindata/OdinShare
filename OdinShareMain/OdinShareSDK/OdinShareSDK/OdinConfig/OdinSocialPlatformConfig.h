//
//  OdinSocialPlatformConfig.h
//  OdinShareSDK
//
//  Created by nathan on 2019/3/22.
//  Copyright © 2019 Odin. All rights reserved.
//

#import <Foundation/Foundation.h>
/////////////////////////////////编译参数////////////////////////////////////////////
#define odin_wx 1
#define odin_qq 1
#define odin_alipay 1
#define odin_weibo 1
/////////////////////////////////编译参数////////////////////////////////////////////


/**
 *  授权，分享，UserProfile等操作的回调
 *
 *  @param result 表示回调的结果
 *  @param error  表示回调的错误码
 */
typedef void (^OdinSocialRequestCompletionHandler)(id result,NSError *error);

/**
 *  授权，分享，UserProfile等操作的回调
 *
 *  @param shareResponse 表示回调的结果
 *  @param error  表示回调的错误码
 */
typedef void (^OdinSocialShareCompletionHandler)(id shareResponse,NSError *error);

/**
 *  授权，分享，UserProfile等操作的回调
 *
 *  @param authResponse 表示回调的结果
 *  @param error  表示回调的错误码
 */
typedef void (^OdinSocialAuthCompletionHandler)(id authResponse,NSError *error);

/**
 *  授权，分享，UserProfile等操作的回调
 *
 *  @param userInfoResponse 表示回调的结果
 *  @param error  表示回调的错误码
 */
typedef void (^OdinSocialGetUserInfoCompletionHandler)(id userInfoResponse,NSError *error);


/////////////////////////////////////////////////////////////////////////////
//平台的失败错误码--start
/////////////////////////////////////////////////////////////////////////////
/**
 *  U-Share返回错误类型
 */
typedef NS_ENUM(NSInteger, OdinSocialPlatformErrorType) {
    OdinSocialPlatformErrorType_Unknow            = 2000,            // 未知错误
    OdinSocialPlatformErrorType_NotSupport        = 2001,            // 没有配置-ObjC， 或则SDK版本不支持或则客户端版本不支持
    OdinSocialPlatformErrorType_AuthorizeFailed   = 2002,            // 授权失败
    OdinSocialPlatformErrorType_ShareFailed       = 2003,            // 分享失败
    OdinSocialPlatformErrorType_RequestForUserProfileFailed = 2004,  // 请求用户信息失败
    OdinSocialPlatformErrorType_ShareDataNil      = 2005,             // 分享内容为空
    OdinSocialPlatformErrorType_ShareDataTypeIllegal = 2006,          // 分享内容不支持
    OdinSocialPlatformErrorType_CheckUrlSchemaFail = 2007,            // schemaurl fail
    OdinSocialPlatformErrorType_NotInstall        = 2008,             // 应用未安装
    OdinSocialPlatformErrorType_Cancel            = 2009,             // 取消操作
    OdinSocialPlatformErrorType_NotNetWork        = 2010,             // 网络异常
    OdinSocialPlatformErrorType_SourceError       = 2011,             // 第三方错误
    
    OdinSocialPlatformErrorType_ProtocolNotOverride = 2013,   // 对应的    OdinSocialPlatformProvider的方法没有实现
    OdinSocialPlatformErrorType_NotUsingHttps      = 2014,   // 没有用https的请求,@see OdinSocialGlobal isUsingHttpsWhenShareContent
    
};

/////////////////////////////////////////////////////////////////////////////
//平台的失败错误码--end
/////////////////////////////////////////////////////////////////////////////



/////////////////////////////////////////////////////////////////////////////
//平台的类型--start
/////////////////////////////////////////////////////////////////////////////
/**
 *  平台类型
 */
typedef NS_ENUM(NSUInteger, OdinSocialPlatformType){
    /**
     *  未知
     */
    OdinSocialPlatformTypeUnknown             = 0,
    /**
     *  新浪微博
     */
    OdinSocialPlatformTypeSinaWeibo           = 1,
    /**
     *  腾讯微博
     */
    OdinSocialPlatformTypeTencentWeibo        = 2,
    /**
     *  豆瓣
     */
    OdinSocialPlatformTypeDouBan              = 5,
    /**
     *  QQ空间
     */
    OdinSocialPlatformSubTypeQZone            = 6,
    /**
     *  人人网
     */
    OdinSocialPlatformTypeRenren              = 7,
    /**
     *  开心网
     */
    OdinSocialPlatformTypeKaixin              = 8,
    /**
     *  Facebook
     */
    OdinSocialPlatformTypeFacebook            = 10,
    /**
     *  Twitter
     */
    OdinSocialPlatformTypeTwitter             = 11,
    /**
     *  印象笔记
     */
    OdinSocialPlatformTypeYinXiang            = 12,
    /**
     *  Google+
     */
    OdinSocialPlatformTypeGooglePlus          = 14,
    /**
     *  Instagram
     */
    OdinSocialPlatformTypeInstagram           = 15,
    /**
     *  LinkedIn
     */
    OdinSocialPlatformTypeLinkedIn            = 16,
    /**
     *  Tumblr
     */
    OdinSocialPlatformTypeTumblr              = 17,
    /**
     *  邮件
     */
    OdinSocialPlatformTypeMail                = 18,
    /**
     *  短信
     */
    OdinSocialPlatformTypeSMS                 = 19,
    /**
     *  打印
     */
    OdinSocialPlatformTypePrint               = 20,
    /**
     *  拷贝
     */
    OdinSocialPlatformTypeCopy                = 21,
    /**
     *  微信好友
     */
    OdinSocialPlatformSubTypeWechatSession    = 22,
    /**
     *  微信朋友圈
     */
    OdinSocialPlatformSubTypeWechatTimeline   = 23,
    /**
     *  QQ好友
     */
    OdinSocialPlatformSubTypeQQFriend         = 24,
    /**
     *  Instapaper
     */
    OdinSocialPlatformTypeInstapaper          = 25,
    /**
     *  Pocket
     */
    OdinSocialPlatformTypePocket              = 26,
    /**
     *  有道云笔记
     */
    OdinSocialPlatformTypeYouDaoNote          = 27,
    /**
     *  Pinterest
     */
    OdinSocialPlatformTypePinterest           = 30,
    /**
     *  Flickr
     */
    OdinSocialPlatformTypeFlickr              = 34,
    /**
     *  Dropbox
     */
    OdinSocialPlatformTypeDropbox             = 35,
    /**
     *  VKontakte
     */
    OdinSocialPlatformTypeVKontakte           = 36,
    /**
     *  微信收藏
     */
    OdinSocialPlatformSubTypeWechatFav        = 37,
    /**
     *  易信好友
     */
    OdinSocialPlatformSubTypeYiXinSession     = 38,
    /**
     *  易信朋友圈
     */
    OdinSocialPlatformSubTypeYiXinTimeline    = 39,
    /**
     *  易信收藏
     */
    OdinSocialPlatformSubTypeYiXinFav         = 40,
    /**
     *  明道
     */
    OdinSocialPlatformTypeMingDao             = 41,
    /**
     *  Line
     */
    OdinSocialPlatformTypeLine                = 42,
    /**
     *  WhatsApp
     */
    OdinSocialPlatformTypeWhatsApp            = 43,
    /**
     *  KaKao Talk
     */
    OdinSocialPlatformSubTypeKakaoTalk        = 44,
    /**
     *  KaKao Story
     */
    OdinSocialPlatformSubTypeKakaoStory       = 45,
    /**
     *  Facebook Messenger
     */
    OdinSocialPlatformTypeFacebookMessenger   = 46,
    /**
     *  Telegram
     */
    OdinSocialPlatformTypeTelegram            = 47,
    /**
     *  支付宝好友
     */
    OdinSocialPlatformTypeAliSocial           = 50,
    /**
     *  支付宝朋友圈
     */
    OdinSocialPlatformTypeAliSocialTimeline   = 51,
    /**
     *  钉钉
     */
    OdinSocialPlatformTypeDingTalk            = 52,
    /**
     *  youtube
     */
    OdinSocialPlatformTypeYouTube             = 53,
    /**
     *  美拍
     */
    OdinSocialPlatformTypeMeiPai              = 54,
    /**
     *  中国移动
     */
    OdinSocialPlatformTypeCMCC                = 55,
    /**
     * Reddit
     */
    OdinSocialPlatformTypeReddit              = 56,
    /**
     * 天翼
     */
    OdinSocialPlatformTypeESurfing            = 57,
    /**
     * Facebook账户系统
     */
    OdinSocialPlatformTypeFacebookAccount     = 58,
    /**
     *  支付宝
     */
    OdinSocialPlatformTypeAliPay           = 993,
    /**
     *  易信
     */
    OdinSocialPlatformTypeYiXin               = 994,
    /**
     *  KaKao
     */
    OdinSocialPlatformTypeKakao               = 995,
    /**
     *  印象笔记国际版
     */
    OdinSocialPlatformTypeEvernote            = 996,
    /**
     *  微信平台,
     */
    OdinSocialPlatformTypeWechat              = 997,
    /**
     *  QQ平台
     */
    OdinSocialPlatformTypeQQ                  = 998,
    /**
     *  任意平台
     */
    OdinSocialPlatformTypeAny                 = 999
};

/////////////////////////////////////////////////////////////////////////////
//平台的类型--end
/////////////////////////////////////////////////////////////////////////////


NS_ASSUME_NONNULL_BEGIN

@interface OdinSocialPlatformConfig : NSObject

@end

NS_ASSUME_NONNULL_END
