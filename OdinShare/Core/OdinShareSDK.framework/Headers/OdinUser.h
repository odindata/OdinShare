//
//  OdinUser.h
//  OdinShareSDK
//
//  Created by nathan on 2019/4/23.
//  Copyright © 2019 Odin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OdinUser : NSObject<NSCoding>
    
- (instancetype)initWithDictionary:(NSDictionary *)dict;


/**
 属于哪个平台的用户
 */
@property (nonatomic, copy, nullable) NSString * sharingPlatfrom;

/**
 用户标识
 */
@property (nonatomic, copy, readonly, nullable) NSString * uid;

/**
 应用的用户标识
 */
@property (nonatomic, copy, readonly, nullable) NSString * appUid;

/**
 用户头像
 */
@property (nonatomic, copy, nullable) NSString * avatar;

/**
 用户昵称
 */
@property (nonatomic, copy, nullable) NSString * nickname;
    
/**
 age
 */
@property (nonatomic, assign) NSInteger age;
    
/**
 sex
 */
@property (nonatomic, assign) NSInteger sex;

/**
 用户昵称
 */
@property (nonatomic, copy, nullable) NSString * country;

/**
 用户昵称
 */
@property (nonatomic, copy, nullable) NSString * province;

/**
 用户昵称
 */
@property (nonatomic, copy, nullable) NSString * city;
  
    
    /**
 签名信息
 */
@property (nonatomic, copy, nullable) NSString * sign;

/**
 原始用户信息
 */
@property (nonatomic, copy, nullable) NSDictionary * originUserData;
@end

NS_ASSUME_NONNULL_END
