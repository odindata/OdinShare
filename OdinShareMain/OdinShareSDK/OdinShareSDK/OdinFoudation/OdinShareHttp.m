//
//  OdinHttp.m
//  OdinShareSDK
//
//  Created by nathan on 2019/5/9.
//  Copyright © 2019 Odin. All rights reserved.
//

#import "OdinShareHttp.h"

@implementation OdinShareHttp

+ (void)post:(NSString *)urlString parameters:(nullable id)parameters success:(nullable void (^)(id _Nullable responseObject))success failure:(nullable void (^)(NSError *error))failure{
    NSURL *URL = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    request.timeoutInterval = 6.f;
    if (parameters) {
        NSString *postBody = [self convertToJsonData:parameters];
        [request setHTTPBody:[postBody dataUsingEncoding:NSUTF8StringEncoding]];
    }
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            if (failure) {
                failure(error);
            }
        }else{
            if (success) {
                NSDictionary *responseObject=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                NSString *code=responseObject[@"code"];
                NSString *msg=responseObject[@"msg"];
                if (code.integerValue==0) {
                    success(responseObject[@"data"]);
                }else{
                    error=[NSError errorWithDomain:msg code:0 userInfo:nil];
                    if (failure) {
                        failure(error);
                    }
                }
            }
        }
    }];
    [task resume];
}
    
+ (void)get:(NSString *)urlString parameters:(nullable id)parameters header:(nullable id)header success:(nullable void (^)(id _Nullable responseObject))success failure:(nullable void (^)(NSError *error))failure{
    NSURL *URL = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"GET"];
    
    [request setAllHTTPHeaderFields:header];
    
    request.timeoutInterval = 6.f;
    if (parameters) {
        NSString *postBody = [self convertToJsonData:parameters];
        [request setHTTPBody:[postBody dataUsingEncoding:NSUTF8StringEncoding]];
    }
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            if (failure) {
                failure(error);
            }
        }else{
            if (success) {
                NSDictionary *responseObject=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                NSString *code=responseObject[@"code"];
                NSString *msg=responseObject[@"msg"];
                if (code.integerValue==0) {
                    success(responseObject[@"data"]);
                }else{
                    error=[NSError errorWithDomain:msg code:0 userInfo:nil];
                    if (failure) {
                        failure(error);
                    }
                }
            }
        }
    }];
    [task resume];
}

+ (NSString *)convertToJsonData:(NSDictionary *)dict{
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    
    if (!jsonData) {
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
    
}
@end
