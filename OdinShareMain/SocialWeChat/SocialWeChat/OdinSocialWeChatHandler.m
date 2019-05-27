//
//  OdinSocialWeChatHandler.m
//  SocialWeChat
//
//  Created by nathan on 2019/4/2.
//  Copyright © 2019 Odin. All rights reserved.
//

#import "OdinSocialWeChatHandler.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "OdinWXApiRequestHandler.h"
#import "OdinHttpTool.h"
#import "OdinHttpTool.h"

static NSString *wxBaseUrl=@"https://api.weixin.qq.com/sns/oauth2";
static NSString *wxUserInfoBaseUrl=@"https://api.weixin.qq.com/sns";

@interface OdinSocialWeChatHandler ()<WXApiDelegate>

@end

static OdinSocialWeChatHandler *singleton = nil;

@implementation OdinSocialWeChatHandler

#pragma mark -- life cycle
+ (instancetype)defaultManager
{
    if (singleton==nil) {
        singleton=[[OdinSocialWeChatHandler alloc]init];
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

/**
 平台是否安装
 
 @param platformType 社交平台类型
 @return 是否安装
 */
- (BOOL)odin_isInstall:(OdinSocialPlatformType)platformType{
     return [WXApi isWXAppInstalled];
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
    [WXApi registerApp:appKey];
}


/**
 分享
 
 @param object 分享的消息对象
 @param completionHandler 分享完成的回调
 */
- (void)odinSocial_ShareWithObject:(OdinSocialMessageObject *)object withCompletionHandler:(OdinSocialGetUserInfoCompletionHandler)completionHandler{
    self.shareCompletionBlock = completionHandler;
    @try {
        int scene = 0;
        if (self.socialPlatformType==OdinSocialPlatformSubTypeWechatSession) {
            scene=WXSceneSession;
        }else if ((self.socialPlatformType==OdinSocialPlatformSubTypeWechatTimeline)){
            scene=WXSceneTimeline;
        }else{
            scene=WXSceneFavorite;
        }
        [self shareTOWX:object scene:scene];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}

- (void)shareTOWX:(OdinSocialMessageObject *)object scene:(int)scene{
    if (![WXApi isWXAppInstalled]) {
        if (self.shareCompletionBlock) {
            NSError *error=[NSError errorWithDomain:@"应用未安装" code:OdinSocialPlatformErrorType_NotInstall userInfo:@{@"info":@"应用未安装"}];
            self.shareCompletionBlock(nil, error);
        }
        return ;
    }
    
    OdinShareObject  *shareObject=object.shareObject;

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
    if (!shareObject) {//分享文字
        [OdinWXApiRequestHandler sendText:object.text InScene:scene];
    }else if([shareObject isKindOfClass:[OdinShareImageObject class]]){
        NSData *imageData;
        OdinShareImageObject *imgOBj=(OdinShareImageObject *)shareObject;
        if ([imgOBj.shareImage isKindOfClass:[NSString class]]) {
            imageData=[NSData dataWithContentsOfFile:imgOBj.shareImage];
            if (imageData==nil) {
                imageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:imgOBj.shareImage]];
            }
        }else if([imgOBj.shareImage isKindOfClass:[UIImage class]]){
            imageData = UIImageJPEGRepresentation(imgOBj.shareImage, 0.7);
        }
        [OdinWXApiRequestHandler sendImageData:imageData TagName:nil MessageExt:nil Action:nil ThumbImage:thumImg InScene:scene];
    }else if([shareObject isKindOfClass:[OdinShareMusicObject class]]){
        OdinShareMusicObject *odinMusicObj=(OdinShareMusicObject *)shareObject;
        [OdinWXApiRequestHandler sendMusicURL:odinMusicObj.musicUrl dataURL:odinMusicObj.musicDataUrl Title:odinMusicObj.title Description:odinMusicObj.descr ThumbImage:thumImg InScene:scene];
    }else if([shareObject isKindOfClass:[OdinShareVideoObject class]]){
        OdinShareVideoObject *odinVideoObj=(OdinShareVideoObject *)shareObject;
        [OdinWXApiRequestHandler sendVideoURL:odinVideoObj.videoUrl Title:odinVideoObj.title Description:odinVideoObj.descr ThumbImage:thumImg InScene:scene];
    }else if([shareObject isKindOfClass:[OdinShareWebpageObject class]]){
        OdinShareWebpageObject *odinWebObj=(OdinShareWebpageObject *)shareObject;
        [OdinWXApiRequestHandler sendLinkURL:odinWebObj.webpageUrl TagName:nil Title:odinWebObj.title Description:odinWebObj.descr ThumbImage:thumImg InScene:scene];
    }
    else if([shareObject isKindOfClass:[OdinShareEmotionObject class]]){
        OdinShareEmotionObject *odinEmotionObj=(OdinShareEmotionObject *)shareObject;
        [OdinWXApiRequestHandler sendEmotionData:odinEmotionObj.emotionData ThumbImage:thumImg InScene:scene];
    }else if([shareObject isKindOfClass:[OdinShareMiniProgramObject class]]){
        OdinShareMiniProgramObject *odinMiniProgramObj=(OdinShareMiniProgramObject *)shareObject;
        [OdinWXApiRequestHandler sendMiniProgramWebpageUrl:odinMiniProgramObj.webpageUrl userName:odinMiniProgramObj.userName path:odinMiniProgramObj.path title:odinMiniProgramObj.title Description:odinMiniProgramObj.descr ThumbImage:thumImg hdImageData:odinMiniProgramObj.hdImageData withShareTicket:odinMiniProgramObj.withShareTicket miniProgramType:(NSInteger)odinMiniProgramObj.miniProgramType InScene:scene];
        
    }else if([shareObject isKindOfClass:[OdinShareFileObject class]]){
        OdinShareFileObject *odinFileObj=(OdinShareFileObject *)shareObject;
        [OdinWXApiRequestHandler sendFileData:odinFileObj.fileData fileExtension:odinFileObj.fileExtension Title:odinFileObj.title Description:odinFileObj.descr ThumbImage:thumImg InScene:scene];
    }
}

#pragma mark --handleOpenUrl
- (BOOL)odinSocial_handleOpenURL:(NSURL *)url{
    return  [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)odinSocial_handleOpenURL:(NSURL *)url options:(NSDictionary *)options{
    return  [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)odinSocial_handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return  [WXApi handleOpenURL:url delegate:self];
}


#pragma mark --WXApiDelegate
// 从微信分享过后点击返回应用的时候调用
- (void)onResp:(BaseResp *)resp {
    
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *authResp=(SendAuthResp *)resp;
        NSError *error;
        if (authResp.errCode!=0) {
            error=[NSError errorWithDomain:authResp.errStr code:OdinSocialPlatformErrorType_AuthorizeFailed userInfo:@{@"info":authResp.errStr}];
        }else{
            //存授权信息
        }
        
        if (self.authCompletionBlock) {
            self.authCompletionBlock(authResp, error);
        }
    }else if([resp isKindOfClass:[SendMessageToWXResp class]]){
        //把返回的类型转换成与发送时相对于的返回类型,这里为SendMessageToWXResp
        SendMessageToWXResp *sendResp = (SendMessageToWXResp *)resp;
        
        OdinSocialShareResponse *response=[OdinSocialShareResponse shareResponseWithMessage:sendResp.errStr];
        response.originalResponse=sendResp;
        NSError *error;
        if (sendResp.errCode!=0) {
            error=[NSError errorWithDomain:sendResp.errStr code:sendResp.errCode userInfo:@{@"info":sendResp.errStr}];
        }
        if (self.shareCompletionBlock) {
            self.shareCompletionBlock(response, error);
        }
    }
}


////////////////////////////////// 授权登录 开始///////////////////////////
#pragma mark --Login
//授权
- (void)odinSocial_AuthorizeWithUserInfo:(NSDictionary *)userInfo withViewController:(UIViewController *)viewController withCompletionHandler:(OdinSocialRequestCompletionHandler)completionHandler{
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc]init];
//    snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact

    req.scope = @"snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact";
    req.state = @"123";
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendAuthReq:req viewController:viewController delegate:self];
    self.authCompletionBlock = completionHandler;
}

//取消授权
-(void)odinSocial_cancelAuthWithCompletionHandler:(OdinSocialRequestCompletionHandler)completionHandler{
    //TODO...
}

//获取用户信息
-(void)odinSocial_RequestForUserProfileWithCompletionHandler:(OdinSocialGetUserInfoCompletionHandler)completionHandler{
    self.userinfoCompletionBlock = completionHandler;
    //先授权登录
    [self odinSocial_AuthorizeWithUserInfo:nil withViewController:nil withCompletionHandler:^(id result, NSError *error) {
        if (!error) {
         
            //获取token
            SendAuthResp *authResp=result;
            NSString *accessUrlStr = [NSString stringWithFormat:@"%@/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code", wxBaseUrl, self.appID, self.appSecret, authResp.code];
          
            [OdinHttpTool getWithUrlString:accessUrlStr parameters:nil success:^(NSDictionary * _Nonnull data) {
                //请求失败
                if ([data.allKeys containsObject:@"errcode"]) {
                    NSError *error=[NSError errorWithDomain:data[@"errmsg"] code:OdinSocialPlatformErrorType_AuthorizeFailed userInfo:@{@"info":data[@"errmsg"]}];
                    if (completionHandler) {
                        completionHandler(data,error);
                    }
                }else{
                    NSString *access_token=data[@"access_token"];
                    NSString *openid=data[@"openid"];
                    NSString * refresh_token=data[@"refresh_token"];
                    NSString *expires_in=data[@"expires_in"];
                    
                    //获取用户信息
                    NSString *userUrlStr = [NSString stringWithFormat:@"%@/userinfo?access_token=%@&openid=%@", wxUserInfoBaseUrl, access_token, openid];
                    [OdinHttpTool getWithUrlString:userUrlStr parameters:nil success:^(NSDictionary * _Nonnull infoData) {
                        if (([data.allKeys containsObject:@"errcode"])) {
                            NSError *error=[NSError errorWithDomain:data[@"errmsg"] code:OdinSocialPlatformErrorType_RequestForUserProfileFailed userInfo:@{@"info":data[@"errmsg"]}];
                            if (completionHandler) {
                                completionHandler(data,error);
                            }
                        }else{
                            OdinSocialUserInfoResponse *userInfoResponse=[[OdinSocialUserInfoResponse alloc]init];
                            userInfoResponse.originalResponse=infoData;
                            userInfoResponse.name=infoData[@"nickname"];
                            userInfoResponse.iconurl=infoData[@"headimgurl"];
                            userInfoResponse.unionGender=infoData[@"sex"];
                            userInfoResponse.gender=infoData[@"sex"];
                            userInfoResponse.openid=infoData[@"openid"];
                            userInfoResponse.uid=infoData[@"unionid"];
                            userInfoResponse.expiration=[NSDate dateWithTimeIntervalSinceNow:expires_in.integerValue];
                            userInfoResponse.refreshToken=refresh_token;
                            userInfoResponse.accessToken=access_token;
                        
                            //存缓存数据
                            OdinUser *userInfo=[OdinUser new];
                            userInfo.sharingPlatfrom=[NSString stringWithFormat:@"%lu",(unsigned long)OdinSocialPlatformTypeWechat];
                            [userInfo setValue:infoData[@"unionid"] forKey:@"uid"];
                            userInfo.avatar=infoData[@"headimgurl"];
                            userInfo.nickname=infoData[@"nickname"];
                            userInfo.province=infoData[@"province"];
                            userInfo.city=infoData[@"city"];
                            userInfo.country=infoData[@"country"];
                            userInfo.sex=[infoData[@"sex"] integerValue];
                            userInfo.sign=access_token;
                            [userInfo setValue:infoData[@"unionid"]forKey:@"uid"];
                            userInfo.originUserData=infoData;
                            NSString *domain = [NSString stringWithFormat:@"OdinShareSDK-Platform-%lu-%@",(unsigned long)OdinSocialPlatformTypeWechat,self.appID];
                            [[OdinDataService new] setCacheData:userInfo forKey:@"currentUser" domain:domain];
                            if (completionHandler) {
                                completionHandler(userInfoResponse,nil);
                            }
                           
                        }
                    } failure:^(NSError * _Nonnull error) {
                        if (completionHandler) {
                            completionHandler(nil,error);
                        }
                    }];
                }
            } failure:^(NSError * _Nonnull error) {
                if (completionHandler) {
                    completionHandler(nil,error);
                }
            }];
            
        }else{
            if (completionHandler) {
                completionHandler(result,error);
            }
        }
    }];
}

////////////////////////////////// 授权登录 结束///////////////////////////
@end
