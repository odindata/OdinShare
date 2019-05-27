//
//  WXMediaMessage+odinMessageConstruct.h
//  SocialWeChat
//
//  Created by nathan on 2019/4/9.
//  Copyright © 2019 Odin. All rights reserved.
//

#import "WXApiObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface WXMediaMessage (odinMessageConstruct)

+ (WXMediaMessage *)messageWithTitle:(NSString *)title
                         Description:(NSString *)description
                              Object:(id)mediaObject
                          MessageExt:(NSString *)messageExt
                       MessageAction:(NSString *)action
                          ThumbImage:(UIImage *)thumbImage
                            MediaTag:(NSString *)tagName;

@end

NS_ASSUME_NONNULL_END
