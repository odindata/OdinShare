//
//  OdinSocialUIManager.h
//  OdinShareSDKUI
//
//  Created by nathan on 2019/4/22.
//  Copyright © 2019 Odin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OdinUIShareSheetConfiguration.h"
#import <OdinShareSDK/OdinSocialPlatformConfig.h>
#import <OdinShareSDK/OdinSocialMessageObject.h>

NS_ASSUME_NONNULL_BEGIN

@interface OdinSocialUIManager : NSObject

+ (instancetype)shareInstance;

/**
 显示分享菜单

 @param items  菜单项，如果传入nil，则显示已集成的平台列表
 @param shareObj 分享内容参数
 @param configuration 分享菜单的设置
 @param completionHandler 分享完成状态
 @return 分享菜单控制器
 */

- (id)showShareActionSheet:(NSArray *)items
               shareObject:(OdinSocialMessageObject *)shareObj
        sheetConfiguration:(OdinUIShareSheetConfiguration *)configuration
        currentViewController:(id)currentViewController CompletionHandler:(OdinSocialShareCompletionHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END
