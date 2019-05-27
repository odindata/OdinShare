//
//  SendMessageToWXReq+odinRequestWithTextOrMediaMessage.h
//  SocialWeChat
//
//  Created by nathan on 2019/4/9.
//  Copyright © 2019 Odin. All rights reserved.
//

#import "WXApiObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface SendMessageToWXReq (odinRequestWithTextOrMediaMessage)

+ (SendMessageToWXReq *)requestWithText:(nonnull NSString *)text
                         OrMediaMessage:(nonnull WXMediaMessage *)message
                                  bText:(BOOL)bText
                                InScene:(enum WXScene)scene;

@end

NS_ASSUME_NONNULL_END
