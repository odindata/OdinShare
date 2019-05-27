//
//  SoicalInstagram.m
//  SoicalInstagram
//
//  Created by nathan on 2019/4/16.
//  Copyright © 2019 Odin. All rights reserved.
//

#import "OdinSoicalInstagramHandler.h"
#import <Photos/Photos.h>

typedef void (^CreateAssetCompletionHandler) (NSString *localId);
typedef void (^GetAssetCompletionHandler) (NSURL *assetURL);

@implementation OdinSoicalInstagramHandler

static OdinSoicalInstagramHandler *singleton = nil;

#pragma mark --life cycle
+ (instancetype)defaultManager
{
    if (singleton==nil) {
        singleton=[[OdinSoicalInstagramHandler alloc]init];
    }
    return singleton;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [super allocWithZone:zone];
    });
    return singleton;
}
#pragma mark -- public method

/**
 平台是否安装
 
 @param platformType 社交平台类型
 @return 是否安装
 */
- (BOOL)odin_isInstall:(OdinSocialPlatformType)platformType{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"instagram://"]];
}

/**
 设置平台key、secret、redirectUrl
 
 @param appKey key
 @param appSecret secre
 @param redirectURL url
 */
- (void)odinSocial_setAppKey:(NSString *)appKey withAppSecret:(NSString *)appSecret withRedirectURL:(NSString *)redirectURL{
    self.appID=appKey;
    self.appSecret=appSecret;
    self.redirectURL=redirectURL;
}

/**
 分享
 
 @param object 分享的消息对象
 @param completionHandler 分享完成的回调
 */
- (void)odinSocial_ShareWithObject:(OdinSocialMessageObject *)object withCompletionHandler:(OdinSocialShareCompletionHandler)completionHandler{
    self.shareCompletionBlock = completionHandler;
    [self shareToInstagram:object];
}

#pragma mark -- privatemMethod
- (void)shareToInstagram:(OdinSocialMessageObject *)object {
    
    OdinShareObject *shareObject=object.shareObject;
    
    UIImage *thumImg;
    if (shareObject&&shareObject.thumbImage) {
        if ([shareObject.thumbImage isKindOfClass:[NSString class]]) {
            thumImg=[UIImage imageWithContentsOfFile:shareObject.thumbImage];
            if (thumImg==nil) {
                thumImg=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:shareObject.thumbImage]]];
            }
        }else if ([shareObject.thumbImage isKindOfClass:[NSData class]]){
            thumImg=[UIImage imageWithData:shareObject.thumbImage];
        }else if ([shareObject.thumbImage isKindOfClass:[UIImage class]]){
            thumImg=shareObject.thumbImage;
        }
    }
    
    //文字
    if (!shareObject) {
        
    }else if([shareObject isKindOfClass:[OdinShareImageObject class]]){
        OdinShareImageObject *odinImgObj=(OdinShareImageObject *)shareObject;
        UIImage *image;
        if ([odinImgObj.shareImage isKindOfClass:[UIImage class]]) {
            image=odinImgObj.shareImage;
        }else if ([odinImgObj.shareImage isKindOfClass:[NSString class]]){
            image=[UIImage imageWithContentsOfFile:odinImgObj.shareImage];
            if (image==nil) {
                image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:odinImgObj.shareImage]]];
            }
        }else if ([odinImgObj.shareImage isKindOfClass:[NSData class]]){
            image=[UIImage imageWithData:odinImgObj.shareImage];
        }
        [self executeInstagramShare:@"image" image:image videoUrl:nil fromViewController:nil locationString:nil];
    }else if([shareObject isKindOfClass:[OdinShareWebpageObject class]]){
       
    }else if ([shareObject isKindOfClass:[OdinShareVideoObject class]]){
        OdinShareVideoObject *odinVideoObj=(OdinShareVideoObject *)shareObject;
        [self executeInstagramShare:@"video" image:nil videoUrl:[NSURL URLWithString:odinVideoObj.videoUrl] fromViewController:nil locationString:nil];
    }
}

-(void)openInstagramForURL:(NSURL *)url {
    
    NSString *escapedString = [url.absoluteString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]];
    NSURL *instagramURL = [NSURL URLWithString:[NSString stringWithFormat:@"instagram://library?AssetPath=%@", escapedString]];
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
            NSString *version = [UIDevice currentDevice].systemVersion;
            if (version.doubleValue >= 10.0) {
                [[UIApplication sharedApplication] openURL:instagramURL options:@{} completionHandler:nil];
            } else {
                 [[UIApplication sharedApplication] openURL:instagramURL];
            }
        } else {
            NSString *errStr=@"应用未安装";
            NSError *errorT=[NSError errorWithDomain:errStr code:OdinSocialPlatformErrorType_NotInstall userInfo:@{@"info":errStr}];
            OdinSocialShareResponse *response=[OdinSocialShareResponse shareResponseWithMessage:errStr];
            if (self.shareCompletionBlock) {
                self.shareCompletionBlock(response, errorT);
            }
        }
    });
}

-(void)executeInstagramShare:(NSString *)fileType image:(UIImage *)image videoUrl:(NSURL *)videoUrl fromViewController:(UIViewController *)viewController locationString:(NSString *)locationString {
    if ([fileType isEqualToString:@"video"]) {
        [self openInstagramForURL:videoUrl];
    }else{
        __block NSString* localId;
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            PHAssetChangeRequest * assetReq = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
            localId = [[assetReq placeholderForCreatedAsset] localIdentifier];
        } completionHandler:^(BOOL success, NSError *error) {
            if (!success){
                OdinSocialShareResponse *response=[OdinSocialShareResponse shareResponseWithMessage:error.domain];
                if (self.shareCompletionBlock) {
                    self.shareCompletionBlock(response, error);
                }
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *escapedString = [localId stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]];
                    NSURL *instagramURL = [NSURL URLWithString:[NSString stringWithFormat:@"instagram://library?AssetPath=%@", escapedString]];
                    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
                        NSString *version = [UIDevice currentDevice].systemVersion;
                        if (version.doubleValue >= 10.0) {
                            [[UIApplication sharedApplication] openURL:instagramURL options:@{} completionHandler:nil];
                        } else {
                            [[UIApplication sharedApplication] openURL:instagramURL];
                        }
                    } else {
                        NSString *errStr=@"应用未安装";
                        NSError *errorT=[NSError errorWithDomain:errStr code:OdinSocialPlatformErrorType_NotInstall userInfo:@{@"info":errStr}];
                        OdinSocialShareResponse *response=[OdinSocialShareResponse shareResponseWithMessage:errStr];
                        if (self.shareCompletionBlock) {
                            self.shareCompletionBlock(response, errorT);
                        }
                    }
                });
            }
        }];
    }
}

@end
