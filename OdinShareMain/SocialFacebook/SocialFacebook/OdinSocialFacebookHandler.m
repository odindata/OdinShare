//
//  SocialFacebook.m
//  SocialFacebook
//
//  Created byFBSDKLoginKit nathan on 2019/4/15.
//  Copyright © 2019 Odin. All rights reserved.
//

#import "OdinSocialFacebookHandler.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

#define odin_facebookUserUrl @"https://graph.facebook.com/v2.8/me"

@interface OdinSocialFacebookHandler ()<FBSDKSharingDelegate>

@end

@implementation OdinSocialFacebookHandler

static OdinSocialFacebookHandler *singleton = nil;
#pragma mark --life cycle
+ (instancetype)defaultManager
{
    if (singleton==nil) {
        singleton=[[OdinSocialFacebookHandler alloc]init];
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
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://"]];
}

/**
 设置平台key、secret、redirectUrl
 
 @param appKey key
 @param appSecret secre
 @param redirectURL url
 */
- (void)odinSocial_setAppKey:(NSString *)appKey withAppSecret:(NSString *)appSecret withRedirectURL:(NSString *)redirectURL{
    [[FBSDKApplicationDelegate sharedInstance] application:[UIApplication sharedApplication]
                             didFinishLaunchingWithOptions:nil];
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
    [self shareToFacebook:object];
}


#pragma mark -- share PrivateMethod
- (void)shareToFacebook:(OdinSocialMessageObject *)object {
    
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
    
    
     UIViewController *fromVc=self.currentViewController;
    //文字
    if (!shareObject) {
        
    }else if([shareObject isKindOfClass:[OdinShareImageObject class]]){
        OdinShareImageObject *odinImgObj=(OdinShareImageObject*)shareObject;
        
        FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
        
        if (odinImgObj.shareImageArray) {
            NSMutableArray *tempPhotoArr=[NSMutableArray array];
            if ([odinImgObj.shareImageArray.firstObject isKindOfClass:[UIImage class]]) {
                for (UIImage *img in odinImgObj.shareImageArray) {
                    FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] init];
                    photo.image=img;
                    [tempPhotoArr addObject:photo];
                }
            }else if (([odinImgObj.shareImageArray.firstObject isKindOfClass:[NSData class]])){
                for (NSData *imgData in odinImgObj.shareImageArray) {
                    FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] init];
                    photo.image=[UIImage imageWithData:imgData];
                    [tempPhotoArr addObject:photo];
                }
            }else if (([odinImgObj.shareImageArray.firstObject isKindOfClass:[NSString class]])){
                for (NSString *imgPath in odinImgObj.shareImageArray) {
                    FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] init];
                    photo.image=[UIImage imageWithContentsOfFile:imgPath];
                    if (photo.image==nil) {
                        NSURL *imgUrl=[NSURL URLWithString:imgPath];
                        if ([imgUrl.scheme isEqualToString:@"http"]) {
                            photo.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgPath]]];
                        }else{
                            photo.imageURL=imgUrl;
                        }
                    }
                    [tempPhotoArr addObject:photo];
                }
            }
            
            content.photos=tempPhotoArr;
        }else{
            FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] init];
            if ([odinImgObj.shareImage isKindOfClass:[UIImage class]]) {
                photo.image=odinImgObj.shareImage;
            }else if ([odinImgObj.shareImage isKindOfClass:[NSData class]]){
                photo.image=[UIImage imageWithData:odinImgObj.shareImage];
            }else if ([odinImgObj.shareImage isKindOfClass:[NSString class]]){
                photo.image=[UIImage imageWithContentsOfFile:odinImgObj.shareImage];
                if (photo.image==nil) {
                    NSURL *imgUrl=[NSURL URLWithString:odinImgObj.shareImage];
                    if ([imgUrl.scheme isEqualToString:@"http"]) {
                        photo.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:odinImgObj.shareImage]]];
                    }else{
                        photo.imageURL=imgUrl;
                    }
                }
                
            }
            photo.userGenerated = YES;
            content.photos = @[photo];
        }
      
        //Facebook 应用
        FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
        dialog.fromViewController = fromVc;
        dialog.shareContent = content;
        dialog.mode = FBSDKShareDialogModeNative;
        dialog.delegate=self;
        [dialog show];
        
    }else if([shareObject isKindOfClass:[OdinShareWebpageObject class]]){
        OdinShareWebpageObject *odinWebObj=(OdinShareWebpageObject *)shareObject;
        FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
        content.contentURL = [NSURL URLWithString:odinWebObj.webpageUrl];
        
        //Facebook 应用
        FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
        dialog.fromViewController = fromVc;
        dialog.shareContent = content;
        dialog.mode = FBSDKShareDialogModeNative;
        dialog.delegate=self;
        [dialog show];
        
        
    }else if ([shareObject isKindOfClass:[OdinShareVideoObject class]]){
        OdinShareVideoObject *odinVidoObj=(OdinShareVideoObject*)shareObject;
        
        FBSDKShareVideo *video = [[FBSDKShareVideo alloc] init];
        if (odinVidoObj.videoUrl) {
            
        }
        video.videoURL = [NSURL URLWithString:odinVidoObj.videoUrl];
        FBSDKShareVideoContent *content = [[FBSDKShareVideoContent alloc] init];
        content.video = video;
        
        //Facebook 应用
        FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
        dialog.fromViewController = fromVc;
        dialog.shareContent = content;
        dialog.mode = FBSDKShareDialogModeNative;
        dialog.delegate=self;
        [dialog show];
    }
    
}

#pragma mark -- FBSDKSharingDelegate
- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results {
    OdinSocialShareResponse *response=[OdinSocialShareResponse shareResponseWithMessage:@"分享成功"];
    response.originalResponse=results;
    if (self.shareCompletionBlock) {
        self.shareCompletionBlock(response, nil);
    }
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error {
    NSError *errorT=[NSError errorWithDomain:@"分享失败" code:OdinSocialPlatformErrorType_ShareFailed userInfo:error.userInfo];
    OdinSocialShareResponse *response=[OdinSocialShareResponse shareResponseWithMessage:@"分享失败"];
    if (self.shareCompletionBlock) {
        self.shareCompletionBlock(response, errorT);
    }
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer {
    NSError *error=[NSError errorWithDomain:@"取消分享" code:OdinSocialPlatformErrorType_Cancel userInfo:@{@"info":@"取消分享"}];
    OdinSocialShareResponse *response=[OdinSocialShareResponse shareResponseWithMessage:@"取消分享"];
    if (self.shareCompletionBlock) {
        self.shareCompletionBlock(response, error);
    }
}

#pragma mark -- OpenUrl
- (BOOL)odinSocial_handleOpenURL:(NSURL *)url options:(NSDictionary *)options{
    return  [[FBSDKApplicationDelegate sharedInstance] application:[UIApplication sharedApplication]
                                                           openURL:url
                                                 sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                        annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
}

/////////////////////////授权登录  开始////////////////////////////////////
-(void)odinSocial_RequestForUserProfileWithCompletionHandler:(OdinSocialGetUserInfoCompletionHandler)completionHandler{
    self.userinfoCompletionBlock = completionHandler;
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions: @[@"public_profile",@"email",@"user_friends"]
     fromViewController:self.currentViewController
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         NSLog(@"facebook login result.grantedPermissions = %@,error = %@",result.grantedPermissions,error);
         if (error) {
             NSError *errorR=[NSError errorWithDomain:[error localizedDescription] code:OdinSocialPlatformErrorType_AuthorizeFailed userInfo:@{@"info":[error localizedDescription]}];
             if (self.userinfoCompletionBlock) {
                 self.userinfoCompletionBlock(nil, errorR);
             }
             
         } else if (result.isCancelled) {
             NSError *errorR=[NSError errorWithDomain:@"用户取消登录" code:OdinSocialPlatformErrorType_Cancel userInfo:@{@"info":@"用户取消登录"}];
             if (self.userinfoCompletionBlock) {
                 self.userinfoCompletionBlock(nil, errorR);
             }
             
         } else {
             
             OdinSocialUserInfoResponse *userInfoResponse=[[OdinSocialUserInfoResponse alloc]init];
             userInfoResponse.uid=result.token.userID;//用户id
             userInfoResponse.accessToken=result.token.tokenString;
             
             FBSDKGraphRequest *graphRequest=[[FBSDKGraphRequest alloc]initWithGraphPath:@"me" parameters: @{@"fields": @"id,name,first_name,middle_name,last_name,gender,locale,languages,link,age_range,third_party_id,installed,timezone,updated_time,verified,birthday,cover,currency,devices,education,email,hometown,interested_in,location,political,favorite_athletes,favorite_teams,picture,quotes,relationship_status,religion,security_settings,video_upload_limits,website,work"} HTTPMethod:@"GET"];
             [graphRequest startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id userResult, NSError *error) {
                 if (error==nil) {
                     userInfoResponse.originalResponse=userResult;
                     userInfoResponse.iconurl=userResult[@"picture"][@"data"][@"url"];
                     //存缓存数据
                     OdinUser *userInfo=[OdinUser new];
                     userInfo.sharingPlatfrom=[NSString stringWithFormat:@"%lu",(unsigned long)OdinSocialPlatformTypeFacebook];
                     [userInfo setValue:result.token.userID forKey:@"uid"];
                     userInfo.sign=result.token.tokenString;
                     userInfo.avatar=userResult[@"picture"][@"data"][@"url"];
                     if (userResult[@"gender"]) {
                         if ([(userResult[@"gender"]) hasPrefix:@"m"]) {
                             userInfo.sex=1;
                         }
                         if ([(userResult[@"gender"]) hasPrefix:@"f"]) {
                             userInfo.sex=2;
                         }
                     }
                     userInfo.originUserData=userResult;
                     NSString *domain = [NSString stringWithFormat:@"OdinShareSDK-Platform-%lu-%@",(unsigned long)self.socialPlatformType,self.appID];
                     [[OdinDataService new] setCacheData:userInfo forKey:@"currentUser" domain:domain];
                     
                     if (self.userinfoCompletionBlock) {
                         self.userinfoCompletionBlock(userInfoResponse, nil);
                     }
                 }else{
                     NSError *errorR=[NSError errorWithDomain:[error localizedDescription] code:OdinSocialPlatformErrorType_RequestForUserProfileFailed userInfo:@{@"info":[error localizedDescription]}];
                     if (self.userinfoCompletionBlock) {
                         self.userinfoCompletionBlock(nil, errorR);
                     }
                 }
             }];
         }
     }];
}

- (void)odinSocial_cancelAuthWithCompletionHandler:(OdinSocialRequestCompletionHandler)completionHandler{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logOut];
}

/////////////////////////授权登录  结束////////////////////////////////////
@end
