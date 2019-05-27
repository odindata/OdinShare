//
//  OdinSocialHandler.m
//  OdinShareSDK
//
//  Created by nathan on 2019/3/28.
//  Copyright © 2019 Odin. All rights reserved.
//

#import "OdinSocialHandler.h"

@interface OdinSocialHandler (){
    OdinSocialPlatformType _socialPlatformType;
     OdinSocialPlatformType _socialLoginPlatformType;
}

@end

@implementation OdinSocialHandler


+(NSArray*) socialPlatformTypes{
    return nil;
}

+ (instancetype)defaultManager{
    return [[self alloc]init];
}

- (void)setSocialPlatformType:(OdinSocialPlatformType)socialPlatformType{
    _socialPlatformType=socialPlatformType;
}

- (OdinSocialPlatformType )socialPlatformType{
    return _socialPlatformType;
}

- (void)setSocialLoginPlatformType:(OdinSocialPlatformType)socialLoginPlatformType{
    _socialLoginPlatformType=socialLoginPlatformType;
}

- (OdinSocialPlatformType )socialLoginPlatformType{
    return _socialLoginPlatformType;
}

@end
