//
//  OdinSocialQQHandler.m
//  SocialQQ
//
//  Created by nathan on 2019/3/29.
//  Copyright © 2019 Odin. All rights reserved.
//

#import "OdinSocialQQHandler.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/TencentOAuth.h>
@interface OdinSocialQQHandler()<TencentSessionDelegate,QQApiInterfaceDelegate>{
    TencentOAuth *_tencentOAuth;
    NSMutableArray *_permissionArray;   //权限列表
}
@end

@implementation OdinSocialQQHandler
static OdinSocialQQHandler *singleton = nil;

#pragma mark --life cycle
+ (instancetype)defaultManager
{
    if (singleton==nil) {
        singleton=[[OdinSocialQQHandler alloc]init];
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
    if (platformType==OdinSocialPlatformSubTypeQZone) {
        return [QQApiInterface isSupportPushToQZone];
    }
    return [QQApiInterface isSupportShareToQQ];
}

/**
 设置平台key、secret、redirectUrl

 @param appKey key
 @param appSecret secre
 @param redirectURL url
 */
- (void)odinSocial_setAppKey:(NSString *)appKey withAppSecret:(NSString *)appSecret withRedirectURL:(NSString *)redirectURL{
    _tencentOAuth=  [[TencentOAuth alloc]initWithAppId:appKey andDelegate:self];
    self.appID=appKey;
    self.appSecret=appSecret;
    self.redirectURL=redirectURL;
}

/**
 分享

 @param object 分享的消息对象
 @param completionHandler 分享完成的回调
 */
- (void)odinSocial_ShareWithObject:(OdinSocialMessageObject *)object withCompletionHandler:(OdinSocialRequestCompletionHandler)completionHandler{
    self.shareCompletionBlock = completionHandler;
    @try {
         [self shareToQQ:object];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}

#pragma mark -- share PrivateMethod
- (void)shareToQQ:(OdinSocialMessageObject *)object {
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
    
    SendMessageToQQReq *req;
    if (self.socialPlatformType==OdinSocialPlatformSubTypeQQFriend) {
        if (!shareObject) {
            QQApiTextObject *txtObj = [QQApiTextObject objectWithText:object.text];
            req = [SendMessageToQQReq reqWithContent:txtObj];
        }else if([shareObject isKindOfClass:[OdinShareImageObject class]]){
            OdinShareImageObject *odinImgObj=(OdinShareImageObject *)shareObject;
            NSData *imageData;
            if ([odinImgObj.shareImage isKindOfClass:[NSString class]]) {
                imageData=[NSData dataWithContentsOfFile:odinImgObj.shareImage];
                if (imageData==nil) {
                    imageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:odinImgObj.shareImage]];
                }
            }else if([odinImgObj.shareImage isKindOfClass:[UIImage class]]){
                imageData = UIImageJPEGRepresentation(odinImgObj.shareImage, 0.7);
            }else{
                imageData=odinImgObj.shareImage;
            }

            QQApiImageObject *imgObj = [QQApiImageObject objectWithData:imageData
                                                       previewImageData:UIImageJPEGRepresentation(thumImg, .9)
                                                                  title:odinImgObj.title
                                                            description:odinImgObj.descr];
            req = [SendMessageToQQReq reqWithContent:imgObj];
            
        }else if ([shareObject isKindOfClass:[OdinShareMusicObject class]]){
            OdinShareMusicObject *odinMusicObj=(OdinShareMusicObject *)shareObject;
    
            QQApiAudioObject *audioObj =
            [QQApiAudioObject objectWithURL:[NSURL URLWithString:odinMusicObj.musicUrl]
                                      title:odinMusicObj.title
                                description:odinMusicObj.descr
                            previewImageURL:[NSURL URLWithString:odinMusicObj.musicLowBandUrl]];
            req = [SendMessageToQQReq reqWithContent:audioObj];
            
        }else if ([shareObject isKindOfClass:[OdinShareVideoObject class]]){
            OdinShareVideoObject *odinVideoObj=(OdinShareVideoObject *)shareObject;
           
            QQApiVideoObject *videoObj = [QQApiVideoObject objectWithURL:[NSURL URLWithString:odinVideoObj.videoUrl]
                                                                   title:odinVideoObj.title
                                                             description:odinVideoObj.descr
                                                        previewImageData:UIImageJPEGRepresentation(thumImg, .9)];
            [videoObj setFlashURL:[NSURL URLWithString:odinVideoObj.videoUrl]];
            req = [SendMessageToQQReq reqWithContent:videoObj];
            
        }else if([shareObject isKindOfClass:[OdinShareWebpageObject class]]){
            
            OdinShareWebpageObject *odinWebObj=(OdinShareWebpageObject *)shareObject;
            QQApiNewsObject *newsObj = [QQApiNewsObject
                                        objectWithURL:[NSURL URLWithString:odinWebObj.webpageUrl]
                                        title:odinWebObj.title
                                        description:odinWebObj.descr
                                        previewImageURL:nil];
            req = [SendMessageToQQReq reqWithContent:newsObj];
        }
        //将内容分享到qq
        QQApiSendResultCode sent = [QQApiInterface sendReq:req];
        [self handleSendResult:sent];
    }
    //qq空间
   else{
       if([shareObject isKindOfClass:[OdinShareWebpageObject class]]){
           OdinShareWebpageObject *odinWebObj=(OdinShareWebpageObject *)shareObject;
           NSString *preImgUrl;
           if ([odinWebObj.thumbImage isKindOfClass:[NSString class]]) {
               preImgUrl=odinWebObj.thumbImage;
           }
           QQApiNewsObject *newsObj = [QQApiNewsObject
                                       objectWithURL:[NSURL URLWithString:odinWebObj.webpageUrl]
                                       title:odinWebObj.title
                                       description:odinWebObj.descr
                                       previewImageURL:preImgUrl?[NSURL URLWithString:preImgUrl]:nil];
           req = [SendMessageToQQReq reqWithContent:newsObj];
           
       }else if([shareObject isKindOfClass:[OdinShareImageObject class]]){
           OdinShareImageObject *odinImgObj=(OdinShareImageObject *)shareObject;
           NSMutableArray *tempArr=[NSMutableArray array];
           if ([odinImgObj.shareImageArray.firstObject isKindOfClass:[UIImage class]]) {
               for (UIImage *img in odinImgObj.shareImageArray) {
                   [tempArr addObject:UIImageJPEGRepresentation(img, .9)];
               }
           }else{
               tempArr=[NSMutableArray arrayWithArray:odinImgObj.shareImageArray];
           }
           
           QQApiImageArrayForQZoneObject *zoneObj=[[QQApiImageArrayForQZoneObject alloc]initWithImageArrayData:tempArr title:odinImgObj.title extMap:nil];
           req=[SendMessageToQQReq reqWithContent:zoneObj];
           
       }else if(!shareObject){
           QQApiImageArrayForQZoneObject *zoneObj=[[QQApiImageArrayForQZoneObject alloc]initWithImageArrayData:nil title:object.text extMap:nil];
           req=[SendMessageToQQReq reqWithContent:zoneObj];
           
       }else if ([shareObject isKindOfClass:[OdinShareVideoObject class]]){
           
            OdinShareVideoObject *odinVideoObj=(OdinShareVideoObject *)shareObject;
            QQApiVideoForQZoneObject *videoObj = [QQApiVideoForQZoneObject objectWithAssetURL:odinVideoObj.videoUrl title:odinVideoObj.title extMap:nil];
           req=[SendMessageToQQReq reqWithContent:videoObj];
           
       }
        //将内容分享到qzone
        QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
       [self handleSendResult:sent];
    }
}

- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    
    NSString *message;
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:{
            message=@"App未注册";
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:{
            message=@"发送参数错误";
            break;
        }
        case EQQAPIQQNOTINSTALLED:{
            message=@"未安装手Q";
            break;
        }
        case EQQAPITIMNOTINSTALLED:{
            message=@"未安装TIM";
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:{
            message=@"API接口不支持";
            break;
        }
        case EQQAPISENDFAILD:{
            message=@"发送失败";
            break;
        }
        case EQQAPIQZONENOTSUPPORTTEXT:{
            message=@"空间分享不支持QQApiTextObject，请使用QQApiImageArrayForQZoneObject分享";
            break;
        }
        case EQQAPIQZONENOTSUPPORTIMAGE:{
            message=@"空间分享不支持QQApiImageObject，请使用QQApiImageArrayForQZoneObject分享";
            break;
        }
        case EQQAPIVERSIONNEEDUPDATE:{
            message=@"当前QQ版本太低，需要更新";
            break;
        }
        case ETIMAPIVERSIONNEEDUPDATE:{
            message=@"当前TIM版本太低，需要更新";
            break;
        }
        default:{
            break;
        }
    }
    
    OdinSocialShareResponse *response=[OdinSocialShareResponse shareResponseWithMessage:message];
    NSError *error;
    if (message) {
        error=[NSError errorWithDomain:message code:0 userInfo:@{@"info":message}];
    }
    if (error) {
        if (self.shareCompletionBlock) {
            self.shareCompletionBlock(response, error);
        }
    }
    
}

# pragma mark -- QQApiInterfaceDelegate

- (void)isOnlineResponse:(NSDictionary *)response {
    
}

- (void)onReq:(QQBaseReq *)req {
    
}

- (void)onResp:(QQBaseResp *)resp {
    NSError *error;
    if (resp.errorDescription) {
        NSInteger errorCode=[resp.result integerValue];
        if (errorCode==-4) {
            //取消操作 OdinSocialPlatformErrorType_Cancel
            errorCode=OdinSocialPlatformErrorType_Cancel;
        }else{
            errorCode=OdinSocialPlatformErrorType_ShareFailed;
        }
        error=[NSError errorWithDomain:resp.errorDescription code:errorCode userInfo:@{@"info":resp.errorDescription}];
    }
    
    OdinSocialShareResponse *response=[OdinSocialShareResponse shareResponseWithMessage:resp.errorDescription];
    response.originalResponse=resp;
    if (self.shareCompletionBlock) {
        self.shareCompletionBlock(response, error);
    }
}

#pragma mark --OpenURL
- (BOOL)odinSocial_handleOpenURL:(NSURL *)url{
    [QQApiInterface handleOpenURL:url delegate:self];
    return  [TencentOAuth HandleOpenURL:url];
}

- (BOOL)odinSocial_handleOpenURL:(NSURL *)url options:(NSDictionary *)options{
    [QQApiInterface handleOpenURL:url delegate:self];
    return  [TencentOAuth HandleOpenURL:url];
}

- (BOOL)odinSocial_handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    [QQApiInterface handleOpenURL:url delegate:self];
    return  [TencentOAuth HandleOpenURL:url];
}


//////////////////// 授权登录  开始//////////////////////

#pragma mark -- Login
-(void)odinSocial_RequestForUserProfileWithCompletionHandler:(OdinSocialGetUserInfoCompletionHandler)completionHandler{
//    _tencentOAuth=[[TencentOAuth alloc]initWithAppId:self.appID andDelegate:self];
    
    //设置权限数据 ， 具体的权限名，在sdkdef.h 文件中查看。
    _permissionArray = [[NSMutableArray alloc] initWithObjects:
                        kOPEN_PERMISSION_GET_USER_INFO,
                        kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                        kOPEN_PERMISSION_ADD_ALBUM,
                        kOPEN_PERMISSION_ADD_ONE_BLOG,
                        kOPEN_PERMISSION_ADD_SHARE,
                        kOPEN_PERMISSION_ADD_TOPIC,
                        kOPEN_PERMISSION_CHECK_PAGE_FANS,
                        kOPEN_PERMISSION_GET_INFO,
                        kOPEN_PERMISSION_GET_OTHER_INFO,
                        kOPEN_PERMISSION_LIST_ALBUM,
                        kOPEN_PERMISSION_UPLOAD_PIC,
                        kOPEN_PERMISSION_GET_VIP_INFO,
                        kOPEN_PERMISSION_GET_VIP_RICH_INFO, nil];
    
    //登录操作
    [_tencentOAuth authorize:_permissionArray inSafari:NO];
    self.userinfoCompletionBlock = completionHandler;
}


#pragma mark --取消授权
-(void)odinSocial_cancelAuthWithCompletionHandler:(OdinSocialRequestCompletionHandler)completionHandler{
    //TOOD..
}

#pragma mark --LoginDelegate

- (void)tencentDidLogin {
    /** Access Token凭证，用于后续访问各开放接口 */
    if (_tencentOAuth.accessToken) {
        //获取用户信息。 调用这个方法后，qq的sdk会自动调用
        [_tencentOAuth getUserInfo];
    }else{
        NSString *message=@"accessToken获取失败";
        NSError *error=[NSError errorWithDomain:message code:OdinSocialPlatformErrorType_AuthorizeFailed userInfo:@{@"info":message}];
        if (self.authCompletionBlock) {
            self.authCompletionBlock(nil, error);
        }
    }
}

- (void)tencentDidNotLogin:(BOOL)cancelled {
    NSString *message;
    if (cancelled) {
        message=@"取消登录";
    }else{
        message=@"未知原因,登录失败";
    }
    NSInteger code=0;
    if (cancelled) {
        code=OdinSocialPlatformErrorType_Cancel;
    }
    NSError *error=[NSError errorWithDomain:message code:OdinSocialPlatformErrorType_Unknow userInfo:@{@"info":message}];
    if (self.userinfoCompletionBlock) {
        self.userinfoCompletionBlock(nil, error);
    }
}

- (void)tencentDidNotNetWork {
    NSString *message=@"无网络,登录失败";
    NSError *error=[NSError errorWithDomain:message code:OdinSocialPlatformErrorType_NotNetWork userInfo:@{@"info":message}];
    if (self.userinfoCompletionBlock) {
        self.userinfoCompletionBlock(nil, error);
    }
}

#pragma mark 登录成功后，回调 - 返回对应QQ的相关信息
/**
 * 获取用户个人信息回调
 * \param response API返回结果，具体定义参见sdkdef.h文件中\ref APIResponse
 * \remarks 正确返回示例: \snippet example/getUserInfoResponse.exp success
 *          错误返回示例: \snippet example/getUserInfoResponse.exp fail
 */
- (void)getUserInfoResponse:(APIResponse*) response{
    
    
//    {
//        "ret": 0,
//        "msg": "",
//        "is_lost":0,
//        "nickname": "晴天",
//        "gender": "男",
//        "province": "湖北",
//        "city": "武汉",
//        "year": "1896",
//        "constellation": "",
//        "figureurl": "http:\/\/qzapp.qlogo.cn\/qzapp\/100371282\/FDA342BD4C61BD816A605826897E64B4\/30",
//        "figureurl_1": "http:\/\/qzapp.qlogo.cn\/qzapp\/100371282\/FDA342BD4C61BD816A605826897E64B4\/50",
//        "figureurl_2": "http:\/\/qzapp.qlogo.cn\/qzapp\/100371282\/FDA342BD4C61BD816A605826897E64B4\/100",
//        "figureurl_qq_1": "http://thirdqq.qlogo.cn/g?b=oidb&k=ic3p4ZzfaQ5EowLC5h7YaAg&s=40",
//        "figureurl_qq_2": "http://thirdqq.qlogo.cn/g?b=oidb&k=ic3p4ZzfaQ5EowLC5h7YaAg&s=100",
//        "figureurl_qq": "http://thirdqq.qlogo.cn/g?b=oidb&k=ic3p4ZzfaQ5EowLC5h7YaAg&s=140",
//        "figureurl_type": "1",
//        "is_yellow_vip": "0",
//        "vip": "0",
//        "yellow_vip_level": "0",
//        "level": "0",
//        "is_yellow_year_vip": "0"
//    }

    
    NSDictionary *responseDic = response.jsonResponse;
    OdinSocialUserInfoResponse *userInfoResponse=[[OdinSocialUserInfoResponse alloc]init];
    userInfoResponse.originalResponse=response;
    userInfoResponse.name=responseDic[@"nickname"];
    userInfoResponse.iconurl=responseDic[@"figureurl_qq"];
    userInfoResponse.unionGender=responseDic[@"gender"];
    userInfoResponse.gender=responseDic[@"gender"];
    userInfoResponse.uid=_tencentOAuth.openId;//用户id
    userInfoResponse.expiration=_tencentOAuth.expirationDate;
    userInfoResponse.accessToken=_tencentOAuth.accessToken;
    userInfoResponse.unionId=_tencentOAuth.unionid;
    userInfoResponse.openid=_tencentOAuth.openId;
    
    //存缓存数据
    OdinUser *userInfo=[OdinUser new];
    userInfo.sharingPlatfrom=[NSString stringWithFormat:@"%lu",(unsigned long)OdinSocialPlatformTypeQQ];
    [userInfo setValue:_tencentOAuth.openId forKey:@"uid"];
    userInfo.avatar=responseDic[@"figureurl_qq"];
    userInfo.nickname=responseDic[@"nickname"];
    userInfo.province=responseDic[@"province"];
    userInfo.city=responseDic[@"city"];
    NSString *sexString=([responseDic[@"gender"] isEqualToString:@"男"])?@"1":@"2";
    userInfo.sex=sexString.integerValue;
    userInfo.sign=_tencentOAuth.accessToken;
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy"];

    NSString *thisYearString=[dateformatter stringFromDate:[NSDate date]];
    userInfo.age=thisYearString.integerValue-[(responseDic[@"year"]) integerValue];
    [userInfo.originUserData setValuesForKeysWithDictionary:responseDic];
    
    NSString *domain = [NSString stringWithFormat:@"OdinShareSDK-Platform-%lu-%@",(unsigned long)OdinSocialPlatformTypeQQ,self.appID];
    [[OdinDataService new] setCacheData:userInfo forKey:@"currentUser" domain:domain];
    
    NSError *error;
    if (response.errorMsg) {
        error=[NSError errorWithDomain:response.errorMsg code:response.retCode userInfo:@{@"info":response.errorMsg}];
    }
    if (self.userinfoCompletionBlock) {
        self.userinfoCompletionBlock(userInfoResponse, error);
    }
}

//////////////////// 授权登录 结束//////////////////////
@end
