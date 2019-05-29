//
//  OdinSocialManager.m
//  OdinShareSDK
//
//  Created by nathan on 2019/3/22.
//  Copyright © 2019 Odin. All rights reserved.
//

#import "OdinSocialManager.h"
#import "OdinSocialResponse/OdinSocialResponse.h"
#import "OidnSocialPlatformProvider.h"
#import "OdinSocialPlatformPvovider/OdinSocialHandler.h"
#import "UIApplication+Hook.h"
#import "OdinDataService.h"
#import "UIDevice+Odin.h"
#import "OdinUser.h"

#if __has_include(<SocialWeChat/OdinSocialWeChatHandler.h>)
#import <SocialWeChat/OdinSocialWeChatHandler.h>
#endif
#if __has_include(<OdinSocialWeChatHandler.h>)
#import <OdinSocialWeChatHandler.h>
#endif

#if __has_include(<SocialQQ/OdinSocialQQHandler.h>)
#import <SocialQQ/OdinSocialQQHandler.h>
#endif

#if __has_include(<SocialSina/OdinSocialSinaHandler.h>)
#import <SocialSina/OdinSocialSinaHandler.h>
#endif

#if __has_include(<SocialAliPay/OdinSocialAliPayHandler.h>)
#import <SocialAliPay/OdinSocialAliPayHandler.h>
#endif

#if __has_include(<SoicalInstagram/OdinSoicalInstagramHandler.h>)
#import <SoicalInstagram/OdinSoicalInstagramHandler.h>
#endif

#if __has_include(<SoicalInstagram/OdinSoicalInstagramHandler.h>)
#import <SoicalInstagram/OdinSoicalInstagramHandler.h>
#endif

#if __has_include(<SocialFacebook/OdinSoicalFacebookHandler.h>)
#import <SocialFacebook/OdinSoicalFacebookHandler.h>
#endif

#import "OdinShareHttp.h"
#import "OdinShhareNetworkReachabilityManager.h"


#define Odin_cancelAuthStaticsUrl @"http://47.107.93.116:80/api/developer/odin/share-sdk-data-save/save-share-detail-data-cancel-authorization"

#define Odin_ShareStaticsUrl @"http://47.107.93.116:80/api/developer/odin/share-sdk-data-save/save-share-detail-data"
#define Odin_ShareKey [[self class] loadOdinKkeyAndSecret]

@interface OdinSocialManager ()<OdinSocialPlatformProvider>
@property(nonatomic,copy)NSString  *networkingWay;
@end

@implementation OdinSocialManager
#pragma mark --life cycle
static OdinSocialManager *singleton = nil;

+ (void)load
{
    [UIApplication startTracker];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_didFinishLaunch:) name:UIApplicationDidFinishLaunchingNotification object:nil];
    
    
}

+ (instancetype)defaultManager
{
    if (singleton==nil) {
        singleton=[[OdinSocialManager alloc]init];
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

#pragma mark -- publicMethod

- (BOOL)setPlaform:(OdinSocialPlatformType)platformType
            appKey:(NSString *)appKey
         appSecret:(nullable NSString *)appSecret
       redirectURL:(nullable NSString *)redirectURL{
    NSString *platFormClassName=[self getPlatformClassName:platformType];
    [[NSClassFromString(platFormClassName) defaultManager] odinSocial_setAppKey:appKey withAppSecret:appSecret withRedirectURL:redirectURL];
    return YES;
}

#pragma mark --触发分享
- (void)shareToPlatform:(OdinSocialPlatformType)platformType
          messageObject:(OdinSocialMessageObject *)messageObject
  currentViewController:(id)currentViewController
             completion:(OdinSocialRequestCompletionHandler)completion{
    NSString *platFormClassName=[self getPlatformClassName:platformType];
    OdinSocialHandler *handle =(OdinSocialHandler*)[NSClassFromString(platFormClassName) defaultManager];
    handle.socialPlatformType=platformType;
    handle.currentViewController=currentViewController;
    [handle odinSocial_ShareWithObject:messageObject withCompletionHandler:^(id shareResponse, NSError *error) {
        if (error==nil) {
            //分享成功
            [self upLoadShareData:messageObject platformType:platformType shareStatus:0];
        }else{
            if (error.code==OdinSocialPlatformErrorType_Cancel) {
                //调用意向分享
                  [self upLoadShareData:messageObject platformType:platformType shareStatus:1];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(shareResponse,error);
            }
        });
    }];
    
}

#pragma mark --授权登录并获取用户信息
- (void)getUserInfoWithPlatform:(OdinSocialPlatformType)platformType
          currentViewController:(id)currentViewController
                     completion:(OdinSocialRequestCompletionHandler)completion{
    
    
    NSString *platFormClassName=[self getPlatformClassName:platformType];
    [NSClassFromString(platFormClassName) defaultManager].socialLoginPlatformType=platformType;
    [NSClassFromString(platFormClassName) defaultManager].socialPlatformType=platformType;
    //获取用户信息
    [[NSClassFromString(platFormClassName) defaultManager] odinSocial_RequestForUserProfileWithCompletionHandler:^(id userInfoResponse,NSError *error) {
        if (completion) {
            if (error==nil) {
                [self upLoadShareData:nil platformType:platformType shareStatus:2];
            }
            //取消授权
            if (error.code==OdinSocialPlatformErrorType_Cancel) {
                [self cancelAtuhData:platformType];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(userInfoResponse,error);
            });
        }
    }];
}

#pragma mark --授权
- (void)authWithPlatform:(OdinSocialPlatformType)platformType
   currentViewController:(UIViewController *)currentViewController
              completion:(OdinSocialAuthCompletionHandler)completion{
    //授权
    NSString *platFormClassName=[self getPlatformClassName:platformType];
    [NSClassFromString(platFormClassName) defaultManager].socialLoginPlatformType=platformType;
    
    //获取用户信息
    [[NSClassFromString(platFormClassName) defaultManager] odinSocial_AuthorizeWithUserInfo:nil withViewController:nil withCompletionHandler:^(id authResponse, NSError *error) {
        
    }];
}

//取消授权
- (void)cancelAuthWithPlatform:(OdinSocialPlatformType)platformType
                    completion:(OdinSocialRequestCompletionHandler)completion{
    NSString *platFormClassName=[self getPlatformClassName:platformType];
    [[NSClassFromString(platFormClassName) defaultManager] odinSocial_cancelAuthWithCompletionHandler:nil];
    NSString *appId= [[NSClassFromString(platFormClassName) defaultManager] valueForKey:@"appID"];
    NSString *domain = [NSString stringWithFormat:@"OdinShareSDK-Platform-%lu-%@",(unsigned long)[self loginType:platformType],appId];
    [[OdinDataService new]  clearDataForKey:@"currentUser" domain:domain];
    
    NSMutableDictionary *odinShareDetailDic=[NSMutableDictionary dictionary];
    odinShareDetailDic[@"odinKey"]=Odin_ShareKey;
    
    if (platformType==OdinSocialPlatformSubTypeWechatFav||platformType==OdinSocialPlatformSubTypeWechatSession||platformType==OdinSocialPlatformSubTypeWechatTimeline) {
        platformType=OdinSocialPlatformTypeWechat;
    }
    
    if (platformType==OdinSocialPlatformSubTypeQQFriend||platformType==OdinSocialPlatformSubTypeQZone) {
        platformType=OdinSocialPlatformTypeQQ;
    }
    
    if (platformType==OdinSocialPlatformTypeAliSocial||platformType==OdinSocialPlatformTypeAliSocialTimeline) {
        platformType=OdinSocialPlatformTypeAliPay;
    }
    
    odinShareDetailDic[@"sharingPlatfrom"]=[NSString stringWithFormat:@"%lu",(unsigned long)platformType];
    odinShareDetailDic[@"shareStatus"]=[NSNumber numberWithInteger:3];
    odinShareDetailDic[@"sysPlatfrom"]=@"2";//1 安卓 2 ios
    
    
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    param[@"odinShareDetail"]=odinShareDetailDic;
    
    [OdinShareHttp post:Odin_cancelAuthStaticsUrl parameters:@{@"param":param} success:^(id  _Nullable responseObject) {
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (completion) {
            completion(nil,nil);
        }
    });
}

- (BOOL)isAuth:(OdinSocialPlatformType)type{
    NSString *platFormClassName=[self getPlatformClassName:type];
    NSString *appId= [[NSClassFromString(platFormClassName) defaultManager] valueForKey:@"appID"];
    NSString *domain = [NSString stringWithFormat:@"OdinShareSDK-Platform-%lu-%@",(unsigned long)[self loginType:type],appId];
    NSDictionary *currentUserDic= [[OdinDataService new] cacheDataForKey:@"currentUser"  domain:domain];
    return  currentUserDic.allKeys.count>0;
}

-(BOOL) isInstall:(OdinSocialPlatformType )platformType{
    NSString *platFormClassName=[self getPlatformClassName:platformType];
    return  [[NSClassFromString(platFormClassName) defaultManager] odin_isInstall:platformType];
}

- (OdinUser *)getUserInfo:(OdinSocialPlatformType )platformType{
    NSString *platFormClassName=[self getPlatformClassName:platformType];
    NSString *appId= [[NSClassFromString(platFormClassName) defaultManager] valueForKey:@"appID"];
    NSString *domain = [NSString stringWithFormat:@"OdinShareSDK-Platform-%lu-%@",(unsigned long)[self loginType:platformType],appId];
    NSDictionary *currentUserDic= [[OdinDataService new] cacheDataForKey:@"currentUser"  domain:domain];
    if (currentUserDic.allKeys>0) {
        return currentUserDic[@"currentUser"];
    }
    return nil;
}

#pragma mark -- HandleOpenUrl

-(BOOL)handleOpenURL:(NSURL *)url{
    
    NSString *platFormClassName= [self getPlatformClassNameFromOpenUrl:url];
    return  [[NSClassFromString(platFormClassName) defaultManager] odinSocial_handleOpenURL:url];
}

- (BOOL)handleOpenURL:(NSURL *)url options:(NSDictionary *)options{
  
    NSString *platFormClassName= [self getPlatformClassNameFromOpenUrl:url];
    return  [[NSClassFromString(platFormClassName) defaultManager] odinSocial_handleOpenURL:url options:options];
}

- (BOOL)handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    NSString *platFormClassName= [self getPlatformClassNameFromOpenUrl:url];
    return  [[NSClassFromString(platFormClassName) defaultManager] odinSocial_handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
}

#pragma  mark -- private method
- (NSString*)getPlatformClassName:(OdinSocialPlatformType)platformType{
    NSString  *platformTypeStr=@"";
    switch (platformType) {
        case OdinSocialPlatformSubTypeWechatSession:
        case OdinSocialPlatformSubTypeWechatTimeline:
        case OdinSocialPlatformSubTypeWechatFav:
        case OdinSocialPlatformTypeWechat:
            platformTypeStr= @"OdinSocialWeChatHandler";
            break;
        case OdinSocialPlatformTypeQQ:
        case OdinSocialPlatformSubTypeQQFriend:
        case OdinSocialPlatformSubTypeQZone:
            platformTypeStr= @"OdinSocialQQHandler";
            break;
        case OdinSocialPlatformTypeSinaWeibo:
            platformTypeStr= @"OdinSocialSinaHandler";
            break;
        case OdinSocialPlatformTypeAliSocial:
        case OdinSocialPlatformTypeAliSocialTimeline:
            platformTypeStr= @"OdinSocialAliPayHandler";
            break;
        case OdinSocialPlatformTypeFacebook:
            platformTypeStr= @"OdinSocialFacebookHandler";
            break;
        case OdinSocialPlatformTypeInstagram:
            platformTypeStr= @"OdinSoicalInstagramHandler";
            break;
        case OdinSocialPlatformTypeTwitter:
            platformTypeStr= @"OdinSocialTwitterHandler";
            break;
        default:
            break;
    }
    return platformTypeStr;
}

- (NSString*)getPlatformClassNameFromOpenUrl:(NSURL *)url{
    NSString *urlString=[url absoluteString].lowercaseString;
    if ([urlString hasPrefix:@"wx"]) {
          return @"OdinSocialWeChatHandler";
    }else if ([urlString hasPrefix:@"qq"]||[urlString hasPrefix:@"tencent"]){
         return @"OdinSocialQQHandler";
    }else if ([urlString hasPrefix:@"wb"]){
         return @"OdinSocialSinaHandler";
    }else if ([urlString hasPrefix:@"ap"]){
        return @"OdinSocialAliPayHandler";
    }else if ([urlString hasPrefix:@"twitterkit"]){
        return @"OdinSocialTwitterHandler";
    }else if ([urlString hasPrefix:@"fb"]){
        return @"OdinSocialFacebookHandler";
    }
    return @"";
}


#pragma mark --Note
+ (void)_applicationDidBecomeActive:(NSNotification *)notification
{
#if __has_include(<SocialFacebook/OdinSoicalFacebookHandler.h>)
    [FBSDKAppEvents activateApp];
#endif
    
}


+(void)_didFinishLaunch:(NSNotification *)note{
    [[OdinShhareNetworkReachabilityManager sharedManager] startMonitoring];
    [[OdinShhareNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(OdinNetworkReachabilityStatus status) {
        if (status==OdinNetworkReachabilityStatusReachableViaWiFi) {
            [OdinSocialManager defaultManager].networkingWay=@"1";
        }else{
            [OdinSocialManager defaultManager].networkingWay=@"0";
        }
    }];
}


//////////////////////////////////分享统计相关 开始///////////////////////////////

#pragma mark -- shareStatistics publicMethod
/**
 取消授权统计
 
 @param platformType 取消平台
 */
- (void)cancelAtuhData:(OdinSocialPlatformType)platformType{
    NSMutableDictionary *odinShareDetailDic=[NSMutableDictionary dictionary];
    odinShareDetailDic[@"odinKey"]=Odin_ShareKey;
    
    if (platformType==OdinSocialPlatformSubTypeWechatFav||platformType==OdinSocialPlatformSubTypeWechatSession||platformType==OdinSocialPlatformSubTypeWechatTimeline) {
        platformType=OdinSocialPlatformTypeWechat;
    }
    
    if (platformType==OdinSocialPlatformSubTypeQQFriend||platformType==OdinSocialPlatformSubTypeQZone) {
        platformType=OdinSocialPlatformTypeQQ;
    }
    
    if (platformType==OdinSocialPlatformTypeAliSocial||platformType==OdinSocialPlatformTypeAliSocialTimeline) {
        platformType=OdinSocialPlatformTypeAliPay;
    }
    
    odinShareDetailDic[@"sharingPlatfrom"]=[NSString stringWithFormat:@"%lu",(unsigned long)platformType];
    odinShareDetailDic[@"shareStatus"]=[NSNumber numberWithInteger:3];
    odinShareDetailDic[@"sysPlatfrom"]=@"2";//1 安卓 2 ios
    
    
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    param[@"odinShareDetail"]=odinShareDetailDic;
    
    [OdinShareHttp post:Odin_cancelAuthStaticsUrl parameters:@{@"param":param} success:^(id  _Nullable responseObject) {
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark -- shareStatistics privateMethod


/**
 分享统计
 
 @param messageObject 分享的内容
 @param platformType 分享的平台
 @param shareStatus  分享状态 0.分享 1.意向分享 2.授权*
 */
- (void)upLoadShareData:(OdinSocialMessageObject *)messageObject platformType:(OdinSocialPlatformType)platformType shareStatus:(NSInteger)shareStatus{
    
    //user
    NSString *platFormClassName=[self getPlatformClassName:platformType];
    NSString *appId= [[NSClassFromString(platFormClassName) defaultManager] valueForKey:@"appID"];
    switch (platformType) {
        case OdinSocialPlatformSubTypeWechatSession:
        case OdinSocialPlatformSubTypeWechatTimeline:
        case OdinSocialPlatformSubTypeWechatFav:
            platformType=OdinSocialPlatformTypeWechat;
            break;
            
        case OdinSocialPlatformSubTypeQZone:
        case OdinSocialPlatformSubTypeQQFriend:
            platformType=OdinSocialPlatformTypeQQ;
            break;
            
        default:
            break;
    }
    NSString *domain = [NSString stringWithFormat:@"OdinShareSDK-Platform-%lu-%@",(unsigned long)platformType,appId];
    NSDictionary *currentUserDic= [[OdinDataService new] cacheDataForKey:@"currentUser"  domain:domain];
    NSMutableDictionary *odinShareUserDic=[self getShareUserData:currentUserDic];
    
    
    NSMutableDictionary *odinShareDetailDic=[NSMutableDictionary dictionary];
    odinShareDetailDic[@"odinKey"]=Odin_ShareKey;
    
    if (platformType==OdinSocialPlatformSubTypeWechatFav||platformType==OdinSocialPlatformSubTypeWechatSession||platformType==OdinSocialPlatformSubTypeWechatTimeline) {
        platformType=OdinSocialPlatformTypeWechat;
    }
    
    if (platformType==OdinSocialPlatformSubTypeQQFriend||platformType==OdinSocialPlatformSubTypeQZone) {
        platformType=OdinSocialPlatformTypeQQ;
    }
    
    if (platformType==OdinSocialPlatformTypeAliSocial||platformType==OdinSocialPlatformTypeAliSocialTimeline) {
        platformType=OdinSocialPlatformTypeAliPay;
    }
    
    odinShareDetailDic[@"sharingPlatfrom"]=[NSString stringWithFormat:@"%lu",(unsigned long)platformType];
    odinShareDetailDic[@"shareStatus"]=[NSNumber numberWithInteger:shareStatus];
    odinShareDetailDic[@"sysPlatfrom"]=@"2";//1 安卓 2 ios
    if (messageObject) {
        if (!messageObject.shareObject) {
            odinShareDetailDic[@"shareContent"]=messageObject.text;
        }else if([messageObject.shareObject isKindOfClass:[OdinShareImageObject class]]){
            odinShareDetailDic[@"shareContent"]=@"图片";
        }else if([messageObject.shareObject isKindOfClass:[OdinShareMusicObject class]]){
            odinShareDetailDic[@"shareContent"]=@"音乐";
        }else if([messageObject.shareObject isKindOfClass:[OdinShareVideoObject class]]){
            odinShareDetailDic[@"shareContent"]=@"视频";
        }else if([messageObject.shareObject isKindOfClass:[OdinShareWebpageObject class]]){
            odinShareDetailDic[@"shareContent"]=@"链接";
        }else if([messageObject.shareObject isKindOfClass:[OdinShareMiniProgramObject class]]){
            odinShareDetailDic[@"shareContent"]=@"小程序";
        }else if([messageObject.shareObject isKindOfClass:[OdinShareFileObject class]]){
            odinShareDetailDic[@"shareContent"]=@"文件";
        }
    }
    
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    param[@"odinShareDetail"]=odinShareDetailDic;
    param[@"odinShareTerminal"]=[self getDeviceInfo];
    if (odinShareUserDic.allKeys>0) {
        param[@"odinShareUser"]=odinShareUserDic;
    }
    [OdinShareHttp post:Odin_ShareStaticsUrl parameters:@{@"param":param} success:^(id  _Nullable responseObject) {
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}




/**
 统计用户信息

 @param cacheUserDic 存在本地的用户信息
 @return 用于提交到后台的用户信息
 */
- (NSMutableDictionary *)getShareUserData:(NSDictionary *)cacheUserDic{
    if (cacheUserDic.allKeys.count>0) {
        OdinUser *user=cacheUserDic[@"currentUser"];//[[OdinUser alloc]initWithDictionary:cacheUserDic];
        NSMutableDictionary *userDic=[NSMutableDictionary dictionary];
        userDic[@"userId"]=user.uid==nil?@"":user.uid;
        userDic[@"headPortrait"]=user.avatar==nil?@"":user.avatar;
        userDic[@"nickname"]=user.nickname==nil?@"":user.nickname;
        userDic[@"sex"]=[NSNumber
                         numberWithInteger:user.sex];
        userDic[@"authenticationInfo"]=user.sign;
        userDic[@"age"]=user.age==0?NULL:[NSNumber
                                          numberWithInteger:user.age];
        userDic[@"country"]=user.country==nil?@"":user.country;
        userDic[@"province"]=user.province==nil?@"":user.province;
        userDic[@"city"]=user.city==nil?@"":user.city;
        userDic[@"sharingPlatfrom"]=user.sharingPlatfrom;
        return userDic;
    }
    return nil;
}


/**
 获取分享统计 对应的设备信息

 @return 设备信息
 */
- (NSMutableDictionary *)getDeviceInfo{
    NSMutableDictionary *deviceDic=[NSMutableDictionary dictionary];
    deviceDic[@"networkingWay"]=self.networkingWay==nil?@"0":self.networkingWay; /**联网方式 0.WAN 1.WIFI*/
    deviceDic[@"terminalName"]=[UIDevice odin_deviceModelName];
    deviceDic[@"resolutionRatio"]=[NSString stringWithFormat:@"%.0f*%.0f",[UIDevice odin_deviceSize].width,[UIDevice odin_deviceSize].height];
    deviceDic[@"operatingSystem"]=@"2";//1 安卓 2 ios
    //运营商
    deviceDic[@"operator"]=[NSNumber numberWithInteger:[UIDevice odin_getCarrierInfomation]];
    deviceDic[@"versions"]=@"1.0.0";//TODO..
    
    return deviceDic;
}


/**
 三方登录时的平台类型转换

 @param platformType 社交平台
 @return 转换后的平台类型
 */
- (OdinSocialPlatformType)loginType:(OdinSocialPlatformType)platformType{
    OdinSocialPlatformType loginType=platformType;
    switch (platformType) {
        case OdinSocialPlatformSubTypeWechatSession:
        case OdinSocialPlatformSubTypeWechatTimeline:
        case OdinSocialPlatformSubTypeWechatFav:
            loginType=OdinSocialPlatformTypeWechat;
            break;
            
        case OdinSocialPlatformSubTypeQZone:
        case OdinSocialPlatformSubTypeQQFriend:
            loginType=OdinSocialPlatformTypeQQ;
            break;
            
        default:
            break;
    }
    return loginType;
}


/**
 获取odinkey

 @return odinkey
 */
+ (NSString *)loadOdinKkeyAndSecret{
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSMutableDictionary *infoDict = [NSMutableDictionary dictionaryWithContentsOfFile:bundlePath];
    return infoDict[@"OdinKey"];
}

//////////////////////////////////分享统计相关 开始///////////////////////////////
@end
