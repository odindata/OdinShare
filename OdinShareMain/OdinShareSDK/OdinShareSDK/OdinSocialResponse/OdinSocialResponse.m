//
//  OdinSocialResponse.m
//  OdinShareSDK
//
//  Created by nathan on 2019/3/26.
//  Copyright © 2019 Odin. All rights reserved.
//

#import "OdinSocialResponse.h"

@implementation OdinSocialResponse

@end

@implementation OdinSocialShareResponse

+ (OdinSocialShareResponse *)shareResponseWithMessage:(NSString *)message{
    OdinSocialShareResponse *response=[[OdinSocialShareResponse alloc]init];
    response.message=message;
    return  response;
}

@end

@implementation OdinSocialUserInfoResponse

@end
