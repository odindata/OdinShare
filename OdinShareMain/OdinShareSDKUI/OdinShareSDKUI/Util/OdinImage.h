//
//  OdinImage.h
//  OdinShareSDKUI
//
//  Created by nathan on 2019/4/22.
//  Copyright © 2019 Odin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OdinImage : NSObject

/**
 *  获取图片对象
 *
 *  @param name   图片名称
 *  @param bundle 资源包对象
 *
 *  @return 图片对象
 */
+ (UIImage *)imageName:(NSString *)name bundle:(NSBundle *)bundle;

@end

NS_ASSUME_NONNULL_END
