//
//  SendMessageToWXReq+odinRequestWithTextOrMediaMessage.m
//  SocialWeChat
//
//  Created by nathan on 2019/4/9.
//  Copyright © 2019 Odin. All rights reserved.
//

#import "SendMessageToWXReq+odinRequestWithTextOrMediaMessage.h"

@implementation SendMessageToWXReq (odinRequestWithTextOrMediaMessage)

+ (SendMessageToWXReq *)requestWithText:(nonnull NSString *)text
                         OrMediaMessage:(WXMediaMessage *)message
                                  bText:(BOOL)bText
                                InScene:(enum WXScene)scene {
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = bText;
    req.scene = scene;
    if (req.scene == WXSceneSpecifiedSession) {
        req.toUserOpenId = @"oyAaTjoAesTaqxEm8pm2FQ4UZMkM";
    }
    if (bText)
        req.text = text;
    else
        req.message = message;
    return req;
}

@end
