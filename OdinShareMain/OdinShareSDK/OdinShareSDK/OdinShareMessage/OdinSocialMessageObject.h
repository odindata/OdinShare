//
//  OdinSocialMessageObject.h
//  OdinShareSDK
//
//  Created by nathan on 2019/3/23.
//  Copyright © 2019 Odin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OdinSocialMessageObject : NSObject
/**
 * @text 非纯文本分享文本
 */
@property (nonatomic, copy) NSString  *text;
/**
 * 分享的所媒体内容对象
 */
@property (nonatomic, strong) id shareObject;
/**
 * 其他相关参数，见相应平台说明
 */
@property (nonatomic, strong) NSDictionary *moreInfo;

+ (OdinSocialMessageObject *)messageObject;

+ (OdinSocialMessageObject *)messageObjectWithMediaObject:(id)mediaObject;

@end


@interface OdinShareObject : NSObject

/**
 * 标题
 * @note 标题的长度依各个平台的要求而定
 */
@property (nonatomic, copy) NSString *title;

/**
 * 描述
 * @note 描述内容的长度依各个平台的要求而定
 */
@property (nonatomic, copy) NSString *descr;

/**
 * 缩略图 UIImage或者NSData类型或者NSString类型（图片url）
 */
@property (nonatomic, strong) id thumbImage;

/**
 * @param title 标题
 * @param descr 描述
 * @param thumImage 缩略图（UIImage或者NSData类型，或者image_url）
 *
 */
+ (id)shareObjectWithTitle:(NSString *)title
                     descr:(NSString *)descr
                 thumImage:(id)thumImage;


+ (void)odin_imageDataWithImage:(id)image withCompletion:(void (^)(NSData *imageData,NSError* error))completion;

@end


@interface OdinShareImageObject : OdinShareObject

/** 分享单个图片（支持UIImage，NSdata以及图片链接Url NSString类对象集合）
 * @note 图片大小根据各个平台限制而定
 */
@property (nonatomic, retain) id shareImage;

/** 分享图片数组，支持 UIImage、NSData 类型
 * @note 仅支持分享到：
 *      微博平台，最多可分享9张图片
 *      QZone平台，最多可分享20张图片
 */
@property (nonatomic, copy) NSArray *shareImageArray;

/**
 * @param title 标题
 * @param descr 描述
 * @param thumImage 缩略图（UIImage或者NSData类型，或者image_url）
 *
 */
+ (OdinShareImageObject *)shareObjectWithTitle:(NSString *)title
                                       descr:(NSString *)descr
                                   thumImage:(id)thumImage;

@end

@interface OdinShareMusicObject : OdinShareObject

/** 音乐网页的url地址
 * @note 长度不能超过10K
 */
@property (nonatomic, retain) NSString *musicUrl;
/** 音乐lowband网页的url地址
 * @note 长度不能超过10K
 */
@property (nonatomic, retain) NSString *musicLowBandUrl;
/** 音乐数据url地址
 * @note 长度不能超过10K
 */
@property (nonatomic, retain) NSString *musicDataUrl;

/**音乐lowband数据url地址
 * @note 长度不能超过10K
 */
@property (nonatomic, retain) NSString *musicLowBandDataUrl;

/**
 * @param title 标题
 * @param descr 描述
 * @param thumImage 缩略图（UIImage或者NSData类型，或者image_url）
 *
 */
+ (OdinShareMusicObject *)shareObjectWithTitle:(NSString *)title
                                       descr:(NSString *)descr
                                   thumImage:(id)thumImage;

@end


@interface OdinShareVideoObject : OdinShareObject

/**
 视频网页的url
 
 @warning 不能为空且长度不能超过255
 */
@property (nonatomic, strong) NSString *videoUrl;

/**
 视频lowband网页的url
 
 @warning 长度不能超过255
 */
@property (nonatomic, strong) NSString *videoLowBandUrl;

/**
 视频数据流url
 
 @warning 长度不能超过255
 */
@property (nonatomic, strong) NSString *videoStreamUrl;

/**
 视频lowband数据流url
 
 @warning 长度不能超过255
 */
@property (nonatomic, strong) NSString *videoLowBandStreamUrl;


/**
 * @param title 标题
 * @param descr 描述
 * @param thumImage 缩略图（UIImage或者NSData类型，或者image_url）
 *
 */
+ (OdinShareVideoObject *)shareObjectWithTitle:(NSString *)title
                                       descr:(NSString *)descr
                                   thumImage:(id)thumImage;

@end


@interface OdinShareWebpageObject : OdinShareObject

/** 网页的url地址
 * @note 不能为空且长度不能超过10K
 */
@property (nonatomic, retain) NSString *webpageUrl;

/**
 * @param title 标题
 * @param descr 描述
 * @param thumImage 缩略图（UIImage或者NSData类型，或者image_url）
 *
 */
+ (OdinShareWebpageObject *)shareObjectWithTitle:(NSString *)title
                                         descr:(NSString *)descr
                                     thumImage:(id)thumImage;

@end

/**
 *  表情的类
 *  表请的缩略图数据请存放在UMShareEmotionObject中
 *  注意：emotionData和emotionURL成员不能同时为空,若同时出现则取emotionURL
 */
@interface OdinShareEmotionObject : OdinShareObject

/**
 *  表情数据，如GIF等
 * @note 微信的话大小不能超过10M
 */
@property (nonatomic, strong) NSData *emotionData;

/**
 * @param title 标题
 * @param descr 描述
 * @param thumImage 缩略图（UIImage或者NSData类型，或者image_url）
 *
 */
+ (OdinShareEmotionObject *)shareObjectWithTitle:(NSString *)title
                                         descr:(NSString *)descr
                                     thumImage:(id)thumImage;

@end



#pragma mark - UMMiniProgramObject

typedef NS_ENUM(NSUInteger, OdinShareWXMiniProgramType){
    OdinShareWXMiniProgramTypeRelease = 0,       //**< 正式版  */
    OdinShareWXMiniProgramTypeTest = 1,        //**< 开发版  */
    OdinShareWXMiniProgramTypePreview = 2,         //**< 体验版  */
};

/*! @brief 多媒体消息中包含 分享微信小程序的数据对象
 *
 * @see UMShareObject
 */
@interface OdinShareMiniProgramObject : OdinShareObject

/**
 低版本微信网页链接
 */
@property (nonatomic, strong) NSString *webpageUrl;

/**
 小程序username
 */
@property (nonatomic, strong) NSString *userName;

/**
 小程序页面的路径
 */
@property (nonatomic, strong) NSString *path;

/**
 小程序新版本的预览图 128k
 */
@property (nonatomic, strong) NSData *hdImageData;

/**
 分享小程序的版本（正式，开发，体验）
 正式版 尾巴正常显示
 开发版 尾巴显示“未发布的小程序·开发版”
 体验版 尾巴显示“未发布的小程序·体验版”
 */
@property (nonatomic, assign) OdinShareWXMiniProgramType miniProgramType;

/**
 是否使用带 shareTicket 的转发
 */
@property (nonatomic, assign) BOOL withShareTicket;

@end

#pragma mark - OdinFileObject
/*! @brief 多媒体消息中包含的文件数据对象
 *
 * @see UMShareObject
 */
@interface OdinShareFileObject : OdinShareObject

/** 文件后缀名
 * @note 长度不超过64字节
 */
@property (nonatomic, retain) NSString  *fileExtension;

/** 文件真实数据内容
 * @note 大小不能超过10M
 */
@property (nonatomic, retain) NSData    *fileData;


@end

NS_ASSUME_NONNULL_END
