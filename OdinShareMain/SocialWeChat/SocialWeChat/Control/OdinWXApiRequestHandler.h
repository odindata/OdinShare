//
//  OdinWXApiRequestHandler.h
//  SocialWeChat
//
//  Created by nathan on 2019/4/9.
//  Copyright © 2019 Odin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApiObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface OdinWXApiRequestHandler : NSObject

+ (BOOL)sendText:(NSString *)text
         InScene:(enum WXScene)scene;

+ (BOOL)sendImageData:(NSData *)imageData
              TagName:(nonnull NSString *)tagName
           MessageExt:(nonnull NSString *)messageExt
               Action:(nonnull NSString *)action
           ThumbImage:(nonnull UIImage *)thumbImage
              InScene:(enum WXScene)scene;

+ (BOOL)sendLinkURL:(NSString *)urlString
            TagName:(nonnull NSString *)tagName
              Title:(NSString *)title
        Description:(nonnull NSString *)description
         ThumbImage:(UIImage *)thumbImage
            InScene:(enum WXScene)scene;

+ (BOOL)sendMusicURL:(NSString *)musicURL
             dataURL:(NSString *)dataURL
               Title:(nonnull NSString *)title
         Description:(nonnull NSString *)description
          ThumbImage:(UIImage *)thumbImage
             InScene:(enum WXScene)scene;

+ (BOOL)sendVideoURL:(NSString *)videoURL
               Title:(nonnull NSString *)title
         Description:(nonnull NSString *)description
          ThumbImage:(UIImage *)thumbImage
             InScene:(enum WXScene)scene;

+ (BOOL)sendEmotionData:(NSData *)emotionData
             ThumbImage:(UIImage *)thumbImage
                InScene:(enum WXScene)scene;

+ (BOOL)sendFileData:(NSData *)fileData
       fileExtension:(NSString *)extension
               Title:(nonnull NSString *)title
         Description:(nonnull NSString *)description
          ThumbImage:(UIImage *)thumbImage
             InScene:(enum WXScene)scene;

+ (BOOL)sendMiniProgramWebpageUrl:(NSString *)webpageUrl
                         userName:(NSString *)userName
                             path:(NSString *)path
                            title:(NSString *)title
                      Description:(nonnull NSString *)description
                       ThumbImage:(UIImage *)thumbImage
                      hdImageData:(NSData *)hdImageData
                  withShareTicket:(BOOL)withShareTicket
                  miniProgramType:(WXMiniProgramType)programType
                          InScene:(enum WXScene)scene;

@end

NS_ASSUME_NONNULL_END
