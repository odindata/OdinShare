//
//  OdinSocialSinaHandler.m
//  SocialSina
//
//  Created by nathan on 2019/4/1.
//  Copyright © 2019 Odin. All rights reserved.
//

#import "OdinSocialSinaHandler.h"
#import <WeiboSDK.h>
#import <Photos/Photos.h>

#define odin_weiboUserUrl @"https://api.weibo.com/2/users/show.json"

@interface OdinSocialSinaHandler ()<WeiboSDKDelegate,WBMediaTransferProtocol,WBHttpRequestDelegate>
@property(nonatomic,strong) WBMessageObject *messageObject;
@end

@implementation OdinSocialSinaHandler

#pragma mark --life cycle
+ (instancetype)defaultManager
{
    static OdinSocialSinaHandler *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[OdinSocialSinaHandler alloc] init];
    });
    return singleton;
}

- (instancetype)init
{
    if (self = [super init])
    {
        
    }
    return self;
}

#pragma mark -- public method

/**
 平台是否安装
 
 @param platformType 社交平台类型
 @return 是否安装
 */
- (BOOL)odin_isInstall:(OdinSocialPlatformType)platformType{
    return [WeiboSDK isWeiboAppInstalled];
}

/**
 设置平台key、secret、redirectUrl
 
 @param appKey key
 @param appSecret secre
 @param redirectURL url
 */
- (void)odinSocial_setAppKey:(NSString *)appKey withAppSecret:(NSString *)appSecret withRedirectURL:(NSString *)redirectURL{
    self.redirectURL=redirectURL;
    self.appID=appKey;
    self.appSecret=appSecret;
    [WeiboSDK registerApp:appKey];
}

/**
 分享
 
 @param object 分享的消息对象
 @param completionHandler 分享完成的回调
 */
- (void)odinSocial_ShareWithObject:(OdinSocialMessageObject *)object withCompletionHandler:(OdinSocialRequestCompletionHandler)completionHandler{
    self.shareCompletionBlock = completionHandler;
    @try {
        [self shareToSina:object];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}

#pragma mark -- share prviateMethod
- (void)shareToSina:(OdinSocialMessageObject *)object{
    _messageObject = [self messageToShare:object];
    if (![object.shareObject isKindOfClass:[OdinShareImageObject class]]&&![object.shareObject isKindOfClass:[OdinShareVideoObject class]]) {
        [self shareMessage];
    }else{
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status != PHAuthorizationStatusAuthorized)
            {
                if (self.shareCompletionBlock) {
                    NSError *error=[NSError errorWithDomain:@"相册权限未开启" code:OdinSocialPlatformErrorType_ShareFailed userInfo:@{@"info":@"相册权限未开启"}];
                    self.shareCompletionBlock(nil, error);
                }
            }
        }];
    }
}

#pragma mark -- Openurl
- (BOOL)odinSocial_handleOpenURL:(NSURL *)url{
    return  [WeiboSDK handleOpenURL:url delegate:self];
}

- (BOOL)odinSocial_handleOpenURL:(NSURL *)url options:(NSDictionary *)options{
    return  [WeiboSDK handleOpenURL:url delegate:self];
}

- (BOOL)odinSocial_handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return  [WeiboSDK handleOpenURL:url delegate:self];
}

#pragma mark --privateMethod
- (WBMessageObject *)messageToShare:(OdinSocialMessageObject *)object{
    WBMessageObject *message=[WBMessageObject message];
    OdinShareObject *shareObj=object.shareObject;
    
    NSData *thumbnailData;
    if (shareObj&&shareObj.thumbImage) {
        if ([shareObj.thumbImage isKindOfClass:[NSString class]]) {
            thumbnailData=[NSData dataWithContentsOfFile:shareObj.thumbImage];
            if (thumbnailData==nil) {
                thumbnailData=[NSData dataWithContentsOfURL:[NSURL URLWithString:shareObj.thumbImage]];
            }
        }else if ([shareObj.thumbImage isKindOfClass:[NSData class]]){
            thumbnailData=shareObj.thumbImage;
        }else if ([shareObj.thumbImage isKindOfClass:[UIImage class]]){
            thumbnailData=UIImageJPEGRepresentation(shareObj.thumbImage, .9);
        }
    }
    
    if (!shareObj) {
        message.text=object.text;
    }else if([shareObj isKindOfClass:[OdinShareImageObject class]]){
        OdinShareImageObject *odinImgObj=(OdinShareImageObject *)shareObj;
        WBImageObject *imgMessageObj=[WBImageObject object];
        NSMutableArray *imgs=[NSMutableArray array];
        for (id imgObj in odinImgObj.shareImageArray) {
            if ([imgObj isKindOfClass:[UIImage class]]) {
                [imgs addObject:imgObj];
            }else{
                [imgs addObject:[UIImage imageWithData:imgObj]];
            }
        }
        [imgMessageObj addImages:imgs];
        if (imgs.count==0) {
            if ([odinImgObj.shareImage isKindOfClass:[UIImage class]]) {
                imgMessageObj.imageData=UIImageJPEGRepresentation(odinImgObj.shareImage, .9);
            }else if([odinImgObj.shareImage isKindOfClass:[NSData class]]){
                imgMessageObj.imageData=odinImgObj.shareImage;
            }else{
                imgMessageObj.imageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:odinImgObj.shareImage]];
            }
        }
        imgMessageObj.delegate=self;
        message.text=object.text;
        message.imageObject=imgMessageObj;
        if (imgs.count==0) {
            self.messageObject=message;
            [self shareMessage];
        }
        
    }else if ([shareObj isKindOfClass:[OdinShareWebpageObject class]]){
        OdinShareWebpageObject *odinWeObj=(OdinShareWebpageObject *)shareObj;

        WBWebpageObject *webpage = [WBWebpageObject object];
        webpage.objectID = @"identifier1";
        webpage.title = odinWeObj.title;
        webpage.description = odinWeObj.descr;
        webpage.thumbnailData = thumbnailData;
        webpage.webpageUrl =odinWeObj.webpageUrl;
        message.mediaObject = webpage;
        
    }else if ([shareObj isKindOfClass:[OdinShareVideoObject class]]){
        OdinShareVideoObject *odinVideoObj=(OdinShareVideoObject*)shareObj;
        
        WBNewVideoObject *videoObject = [WBNewVideoObject object];
        NSURL *videoUrl = [NSURL URLWithString:odinVideoObj.videoUrl];
        if ([videoUrl.scheme isEqualToString:@"assets-library"]) {
            PHFetchResult *fetchResult = [PHAsset fetchAssetsWithALAssetURLs:@[videoUrl] options:nil];
            PHAsset *asset = fetchResult.firstObject;
            [videoObject addVideoAsset:asset];
        }else{
            [videoObject addVideo:videoUrl];
        }
        videoObject.delegate = self;
        message.videoObject = videoObject;
        
    }
    return message;
}

- (void)shareMessage{
    dispatch_async(dispatch_get_main_queue(), ^{
        WBAuthorizeRequest *authrRequest=[WBAuthorizeRequest request];
        authrRequest.scope=@"all";
        authrRequest.redirectURI=self.redirectURL;
        WBSendMessageToWeiboRequest *request=[WBSendMessageToWeiboRequest requestWithMessage:self.messageObject authInfo:authrRequest access_token:nil];
        if (![WeiboSDK sendRequest:request]) {
            if (self.shareCompletionBlock) {
                NSError *error=[NSError errorWithDomain:@"发送失败" code:OdinSocialPlatformErrorType_ShareFailed userInfo:@{@"info":@"发送失败"}];
                self.shareCompletionBlock(nil, error);
            }
        } });
}

#pragma mark -- WeiboSDKDelegate
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
    
    NSString *message=@"发送成功";
    switch (response.statusCode) {
        case WeiboSDKResponseStatusCodeUserCancel:
            message=@"用户取消发送";
            break;
            
        case WeiboSDKResponseStatusCodeSentFail:
            message=@"发送失败";
            break;
        case WeiboSDKResponseStatusCodeAuthDeny:
            message=@"授权失败";
            break;
        case WeiboSDKResponseStatusCodeUserCancelInstall:
            message=@"用户用户取消安装微博客户端发送";
            break;
        case WeiboSDKResponseStatusCodeShareInSDKFailed:
            message=@"分享失败 详情见response UserInfo";
            break;
        case WeiboSDKResponseStatusCodeUnsupport:
            message=@"不支持的请求";
            break;
        case WeiboSDKResponseStatusCodeUnknown:
            message=@"未知错误";
            break;
        default:
            break;
    }
    
    
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        WBSendMessageToWeiboResponse *sendResp=(WBSendMessageToWeiboResponse *)response;
        OdinSocialShareResponse *response=[OdinSocialShareResponse shareResponseWithMessage:message];
        response.originalResponse=sendResp;
        NSError *error;
        if (sendResp.statusCode!=WeiboSDKResponseStatusCodeSuccess) {
            if (sendResp.statusCode==WeiboSDKResponseStatusCodeUserCancel) {
                error=[NSError errorWithDomain:message code:OdinSocialPlatformErrorType_Cancel userInfo:@{@"info":message}];
            }else{
                error=[NSError errorWithDomain:message code:OdinSocialPlatformErrorType_ShareFailed userInfo:@{@"info":message}];
            }
            
        }
        if (self.shareCompletionBlock) {
            self.shareCompletionBlock(response, error);
        }
    }else if([response isKindOfClass:WBAuthorizeResponse.class]){
        WBAuthorizeResponse *authResponse=(WBAuthorizeResponse *)response;
        [self authHanlder:authResponse message:message];
    }
}

#pragma mark -- WBMediaTransferProtocol
- (void)wbsdk_TransferDidReceiveObject:(id)object{
    
    if (self.messageObject.imageObject&&(self.messageObject.imageObject.image==nil||self.messageObject.imageObject.finalAssetArray.count>0)) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //分享多图是检查是否安装新浪
            if (![WeiboSDK isWeiboAppInstalled]) {
                if (self.shareCompletionBlock) {
                    NSError *error=[NSError errorWithDomain:@"未安装应用" code:OdinSocialPlatformErrorType_NotInstall userInfo:@{@"info":@"未安装应用"}];
                    self.shareCompletionBlock(nil, error);
                }
                return;
            }else{
                [self shareMessage];
            }
        });
    }
}

- (void)wbsdk_TransferDidFailWithErrorCode:(WBSDKMediaTransferErrorCode)errorCode andError:(NSError *)error {
    //媒体转换失败
    if (self.shareCompletionBlock) {
        self.shareCompletionBlock(nil, error);
    }
}

///////////////////////////////授权登录 开始///////////////////////////
#pragma mark  -- auth PublicMethod
-(void)odinSocial_RequestForUserProfileWithCompletionHandler:(OdinSocialGetUserInfoCompletionHandler)completionHandler{
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = self.redirectURL;
    request.scope = @"all";
    [WeiboSDK sendRequest:request];
    self.userinfoCompletionBlock = completionHandler;
}

- (void)odinSocial_cancelAuthWithCompletionHandler:(OdinSocialRequestCompletionHandler)completionHandler{
    OdinUser *user=[[OdinSocialManager defaultManager] getUserInfo:OdinSocialPlatformTypeSinaWeibo];
    NSString *token=user.sign;
    [WeiboSDK logOutWithToken:token delegate:self withTag:@"user"];
}

#pragma mark  -- WBHttpRequestDelegate 取消授权监听
-(void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error{
    
}

- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result{
    
}

#pragma mark -- auth private method
/**
 授权登录的处理
 
 @param authResponse 授权的响应
 @param message 授权结果
 */
- (void)authHanlder:(WBAuthorizeResponse *)authResponse message:(NSString *)message{
    __block OdinSocialUserInfoResponse *userInfoResponse=[[OdinSocialUserInfoResponse alloc]init];
    if (authResponse.statusCode==WeiboSDKResponseStatusCodeSuccess){
        [WBHttpRequest requestWithURL:odin_weiboUserUrl httpMethod:@"GET" params:@{@"access_token":authResponse.accessToken,@"uid":authResponse.userID} queue:nil withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
            if (error==nil) {
                NSDictionary *userResult=(NSDictionary *)result;
                userInfoResponse.originalResponse=result;
                userInfoResponse.name=userResult[@"name"];
                userInfoResponse.iconurl=userResult[@"profile_image_url"];
                
                NSString *gender=@"男";
                if([userResult[@"gender"] isEqualToString:@"f"]){
                    gender=@"女";
                }
                if([userResult[@"gender"] isEqualToString:@"n"]){
                    gender=@"未知";
                }
                userInfoResponse.unionGender=gender;
                userInfoResponse.gender=gender;
                userInfoResponse.uid=authResponse.userID;//用户id
                userInfoResponse.expiration=authResponse.expirationDate;
                userInfoResponse.refreshToken=authResponse.refreshToken;
                userInfoResponse.accessToken=authResponse.accessToken;
                
                //存缓存数据
                OdinUser *userInfo=[OdinUser new];
                userInfo.sharingPlatfrom=[NSString stringWithFormat:@"%lu",(unsigned long)OdinSocialPlatformTypeSinaWeibo];
                [userInfo setValue:authResponse.userID forKey:@"uid"];
                userInfo.nickname=userResult[@"name"];
                NSInteger sex=0;
                if ([gender isEqualToString:@"男"]) {
                    sex=1;
                }
                if ([gender isEqualToString:@"女"]) {
                    sex=2;
                }
                userInfo.sex=sex;
                userInfo.sign=authResponse.accessToken;
                userInfo.avatar=userResult[@"profile_image_url"];
                userInfo.originUserData=userResult;
                NSString *domain = [NSString stringWithFormat:@"OdinShareSDK-Platform-%lu-%@",(unsigned long)self.socialPlatformType,self.appID];
                [[OdinDataService new] setCacheData:userInfo forKey:@"currentUser" domain:domain];
                
            }else{
                userInfoResponse=nil;
            }
            if (self.userinfoCompletionBlock) {
                self.userinfoCompletionBlock(userInfoResponse, error);
            }
        }];
        
    }else{
        NSError *error;
        if (authResponse.statusCode!=WeiboSDKResponseStatusCodeSuccess) {
            error=[NSError errorWithDomain:message code:OdinSocialPlatformErrorType_RequestForUserProfileFailed userInfo:@{@"info":message}];
            userInfoResponse=nil;
        }
        
        if (authResponse.statusCode==WeiboSDKResponseStatusCodeUserCancel) {
            error=[NSError errorWithDomain:message code:OdinSocialPlatformErrorType_Cancel userInfo:@{@"info":message}];
            userInfoResponse=nil;
        }
        if (self.userinfoCompletionBlock) {
            self.userinfoCompletionBlock(userInfoResponse, error);
        }
    }
}
///////////////////////////////授权登录 结束///////////////////////////
@end
