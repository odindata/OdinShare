//
//  OdinHttp.h
//  OdinShareSDK
//
//  Created by nathan on 2019/5/9.
//  Copyright © 2019 Odin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OdinShareHttp : NSObject

+ (instancetype)shareInstance;

+ (NSString *)getBaseUrl:(BOOL)onceAgin;

+ (void)post:(NSString *)urlString parameters:(nullable id)parameters success:(nullable void (^)(id _Nullable responseObject))success failure:(nullable void (^)(NSError *error))failure;

+ (void)get:(NSString *)urlString parameters:(nullable id)parameters header:(nullable id)header success:(nullable void (^)(id _Nullable responseObject))success failure:(nullable void (^)(NSError *error))failure;
@end

NS_ASSUME_NONNULL_END
