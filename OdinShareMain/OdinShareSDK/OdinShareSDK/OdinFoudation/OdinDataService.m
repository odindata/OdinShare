//
//  OdinDataService.m
//  OdinShareSDK
//
//  Created by nathan on 2019/4/23.
//  Copyright © 2019 Odin. All rights reserved.
//

#import "OdinDataService.h"
#import "OdinUser.h"

@implementation OdinDataService

- (void)setCacheData:(id)data forKey:(NSString *)key domain:(NSString *)domain{
    //写入数据
    @try
    {
        NSMutableDictionary *cacheData = [self cacheDataForKey:key domain:domain];
        if (data)
        {
            [cacheData setObject:data forKey:key];
        }
        else
        {
            [cacheData removeObjectForKey:key];
        }
        
        [NSKeyedArchiver archiveRootObject:cacheData toFile:[self cacheDataFilePathForDomain:domain]];
    }
    @catch (NSException *exception)
    {
       
    }
}

- (id)cacheDataForKey:(NSString *)key domain:(NSString *)domain{
    @try
    {
        NSString *path = [self cacheDataFilePathForDomain:domain];
        NSMutableDictionary *cacheData = nil;
        NSDictionary *data = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        if ([data isKindOfClass:[NSDictionary class]])
        {
            cacheData = [NSMutableDictionary dictionaryWithDictionary:data];
        }
        
        if (!cacheData)
        {
            cacheData = [NSMutableDictionary dictionary];
        }
        
        return cacheData;
    }
    @catch (NSException *exception)
    {
        
        return [NSMutableDictionary dictionary];
    }
}

- (void)clearDataForKey:(NSString *)key domain:(NSString *)domain{
    @try
    {
        NSString *path = [self cacheDataFilePathForDomain:domain];
        NSDictionary *data = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        NSMutableDictionary *cacheData=[NSMutableDictionary dictionaryWithDictionary:data];
        if (data) {
            [cacheData removeObjectForKey:key];
        }
        
        [NSKeyedArchiver archiveRootObject:cacheData toFile:[self cacheDataFilePathForDomain:domain]];
    }
    @catch (NSException *exception)
    {
        
        
    }
}
/**
 *  缓存文件路径
 *
 *  @return 路径
 */
- (NSString *)cacheDataFilePathForDomain:(NSString *)domain
{
    static NSString *basePath = nil;
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        
        basePath = [NSString stringWithFormat:@"%@/Library/Caches/OdinFCacheData", NSHomeDirectory()];
        
    });
    
    if ([domain isKindOfClass:[NSString class]])
    {
        return [basePath stringByAppendingFormat:@"-%@", domain];
    }
    
    return basePath;
}
@end
