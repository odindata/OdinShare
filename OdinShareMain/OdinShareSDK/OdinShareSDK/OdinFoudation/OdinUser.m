//
//  OdinUser.m
//  OdinShareSDK
//
//  Created by nathan on 2019/4/23.
//  Copyright © 2019 Odin. All rights reserved.
//

#import "OdinUser.h"

@implementation OdinUser

- (instancetype)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
    
- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    
    [aCoder encodeObject:_sharingPlatfrom forKey:@"sharingPlatfrom"];
    [aCoder encodeObject:_uid forKey:@"uid"];
    [aCoder encodeObject:_appUid forKey:@"appUid"];
    [aCoder encodeObject:_avatar forKey:@"avatar"];
    [aCoder encodeObject:_nickname forKey:@"nickname"];
    [aCoder encodeInteger:_age forKey:@"age"];
    [aCoder encodeInteger:_sex forKey:@"sex"];
    [aCoder encodeObject:_country forKey:@"country"];
    [aCoder encodeObject:_province forKey:@"province"];
    [aCoder encodeObject:_city forKey:@"city"];
    [aCoder encodeObject:_sign forKey:@"sign"];
    [aCoder encodeObject:_originUserData forKey:@"originUserData"];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder {
    if (self = [super init]) {
        _sharingPlatfrom= [aDecoder decodeObjectForKey:@"sharingPlatfrom"];;
        _uid =  [aDecoder decodeObjectForKey:@"uid"];
        _appUid =  [aDecoder decodeObjectForKey:@"appUid"];
        _avatar =  [aDecoder decodeObjectForKey:@"avatar"];
        _nickname =  [aDecoder decodeObjectForKey:@"nickname"];
        _age =  [aDecoder decodeIntegerForKey:@"age"];
        _sex =  [aDecoder decodeIntegerForKey:@"sex"];
        _country =  [aDecoder decodeObjectForKey:@"country"];
        _province =  [aDecoder decodeObjectForKey:@"province"];
        _city =  [aDecoder decodeObjectForKey:@"city"];
        _sign =  [aDecoder decodeObjectForKey:@"sign"];
        _originUserData=[aDecoder decodeObjectForKey:@"originUserData"];
    }
    return self;
}

@end
