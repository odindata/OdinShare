//
//  OdinDataService.h
//  OdinShareSDK
//
//  Created by nathan on 2019/4/23.
//  Copyright © 2019 Odin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class OdinUser;
NS_ASSUME_NONNULL_BEGIN

@interface OdinDataService : NSObject

/**
 *  设置缓存数据
 *
 *  @param data     数据
 *  @param key      标识
 *  @param domain   数据域
 */
- (void)setCacheData:(id)data forKey:(NSString *)key domain:(NSString *)domain;

/**
 *  获取缓存数据
 *
 *  @param key 标识
 *  @param domain   数据域
 *
 *  @return 数据
 */
- (id)cacheDataForKey:(NSString *)key domain:(NSString *)domain;


/**
 *  清楚缓存数据
 *
 *  @param key 标识
 *  @param domain   数据域
 *
 *
 */
- (void)clearDataForKey:(NSString *)key domain:(NSString *)domain;

@end

NS_ASSUME_NONNULL_END
