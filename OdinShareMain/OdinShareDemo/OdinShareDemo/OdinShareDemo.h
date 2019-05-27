//
//  OdinShareDemo.h
//  OdinShareDemo
//
//  Created by nathan on 2019/3/27.
//  Copyright © 2019 Odin. All rights reserved.
//

#import <Foundation/Foundation.h>
#ifndef OdinShareDemo_h
#define OdinShareDemo_h

/**
 *  平台类型
 */
typedef NS_ENUM(NSUInteger, SSDKPlatformType){
    /**
     *  未知
     */
    SSDKPlatformTypeUnknown             = 0,
    /**
     *  新浪微博
     */
    SSDKPlatformTypeSinaWeibo           = 1,
    /**
     *  腾讯微博
     */
    SSDKPlatformTypeTencentWeibo        = 2,
    /**
     *  豆瓣
     */
    SSDKPlatformTypeDouBan              = 5,
    /**
     *  QQ空间
     */
    SSDKPlatformSubTypeQZone            = 6,
    /**
     *  人人网
     */
    SSDKPlatformTypeRenren              = 7,
    /**
     *  开心网
     */
    SSDKPlatformTypeKaixin              = 8,
    /**
     *  Facebook
     */
    SSDKPlatformTypeFacebook            = 10,
    /**
     *  Twitter
     */
    SSDKPlatformTypeTwitter             = 11,
    /**
     *  印象笔记
     */
    SSDKPlatformTypeYinXiang            = 12,
    /**
     *  Google+
     */
    SSDKPlatformTypeGooglePlus          = 14,
    /**
     *  Instagram
     */
    SSDKPlatformTypeInstagram           = 15,
    /**
     *  LinkedIn
     */
    SSDKPlatformTypeLinkedIn            = 16,
    /**
     *  Tumblr
     */
    SSDKPlatformTypeTumblr              = 17,
    /**
     *  邮件
     */
    SSDKPlatformTypeMail                = 18,
    /**
     *  短信
     */
    SSDKPlatformTypeSMS                 = 19,
    /**
     *  打印
     */
    SSDKPlatformTypePrint               = 20,
    /**
     *  拷贝
     */
    SSDKPlatformTypeCopy                = 21,
    /**
     *  微信好友
     */
    SSDKPlatformSubTypeWechatSession    = 22,
    /**
     *  微信朋友圈
     */
    SSDKPlatformSubTypeWechatTimeline   = 23,
    /**
     *  QQ好友
     */
    SSDKPlatformSubTypeQQFriend         = 24,
    /**
     *  Instapaper
     */
    SSDKPlatformTypeInstapaper          = 25,
    /**
     *  Pocket
     */
    SSDKPlatformTypePocket              = 26,
    /**
     *  有道云笔记
     */
    SSDKPlatformTypeYouDaoNote          = 27,
    /**
     *  Pinterest
     */
    SSDKPlatformTypePinterest           = 30,
    /**
     *  Flickr
     */
    SSDKPlatformTypeFlickr              = 34,
    /**
     *  Dropbox
     */
    SSDKPlatformTypeDropbox             = 35,
    /**
     *  VKontakte
     */
    SSDKPlatformTypeVKontakte           = 36,
    /**
     *  微信收藏
     */
    SSDKPlatformSubTypeWechatFav        = 37,
    /**
     *  易信好友
     */
    SSDKPlatformSubTypeYiXinSession     = 38,
    /**
     *  易信朋友圈
     */
    SSDKPlatformSubTypeYiXinTimeline    = 39,
    /**
     *  易信收藏
     */
    SSDKPlatformSubTypeYiXinFav         = 40,
    /**
     *  明道
     */
    SSDKPlatformTypeMingDao             = 41,
    /**
     *  Line
     */
    SSDKPlatformTypeLine                = 42,
    /**
     *  WhatsApp
     */
    SSDKPlatformTypeWhatsApp            = 43,
    /**
     *  KaKao Talk
     */
    SSDKPlatformSubTypeKakaoTalk        = 44,
    /**
     *  KaKao Story
     */
    SSDKPlatformSubTypeKakaoStory       = 45,
    /**
     *  Facebook Messenger
     */
    SSDKPlatformTypeFacebookMessenger   = 46,
    /**
     *  Telegram
     */
    SSDKPlatformTypeTelegram            = 47,
    /**
     *  支付宝好友
     */
    SSDKPlatformTypeAliSocial           = 50,
    /**
     *  支付宝朋友圈
     */
    SSDKPlatformTypeAliSocialTimeline   = 51,
    /**
     *  钉钉
     */
    SSDKPlatformTypeDingTalk            = 52,
    /**
     *  youtube
     */
    SSDKPlatformTypeYouTube             = 53,
    /**
     *  美拍
     */
    SSDKPlatformTypeMeiPai              = 54,
    /**
     *  中国移动
     */
    SSDKPlatformTypeCMCC                = 55,
    /**
     * Reddit
     */
    SSDKPlatformTypeReddit              = 56,
    /**
     * 天翼
     */
    SSDKPlatformTypeESurfing            = 57,
    /**
     * Facebook账户系统
     */
    SSDKPlatformTypeFacebookAccount     = 58,
    /**
     *  易信
     */
    SSDKPlatformTypeYiXin               = 994,
    /**
     *  KaKao
     */
    SSDKPlatformTypeKakao               = 995,
    /**
     *  印象笔记国际版
     */
    SSDKPlatformTypeEvernote            = 996,
    /**
     *  微信平台,
     */
    SSDKPlatformTypeWechat              = 997,
    /**
     *  QQ平台
     */
    SSDKPlatformTypeQQ                  = 998,
    /**
     *  任意平台
     */
    SSDKPlatformTypeAny                 = 999
};

#import <OdinShareSDK/OdinShareSDK.h>
#endif /* OdinShareDemo_h */
