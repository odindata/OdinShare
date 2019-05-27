//
//  OdinSocialAliPayHandler.m
//  SocialAliPay
//
//  Created by nathan on 2019/4/8.
//  Copyright © 2019 Odin. All rights reserved.
//

#import "OdinSocialAliPayHandler.h"
#import "APOpenAPI.h"
#import <AFAuthSDK/AFAuthSDK.h>

static OdinSocialAliPayHandler *singleton = nil;

@interface OdinSocialAliPayHandler ()<APOpenAPIDelegate>

@end

@implementation OdinSocialAliPayHandler

#pragma mark --life cycle
+ (instancetype)defaultManager
{
    static OdinSocialAliPayHandler *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[OdinSocialAliPayHandler alloc] init];
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
    return [APOpenAPI isAPAppInstalled];
}

/**
 设置平台key、secret、redirectUrl
 
 @param appKey key
 @param appSecret secre
 @param redirectURL url
 */
- (void)odinSocial_setAppKey:(NSString *)appKey withAppSecret:(NSString *)appSecret withRedirectURL:(NSString *)redirectURL{
    BOOL success= [APOpenAPI registerApp:appKey];
    if (!success) {
//        NSLog(@"注册失败");
    }
}

/**
 分享
 
 @param object 分享的消息对象
 @param completionHandler 分享完成的回调
 */
- (void)odinSocial_ShareWithObject:(OdinSocialMessageObject *)object withCompletionHandler:(OdinSocialRequestCompletionHandler)completionHandler{
    self.shareCompletionBlock = completionHandler;
    @try {
        int scene = 0;
        if (self.socialPlatformType==OdinSocialPlatformTypeAliSocial) {
            scene=APSceneSession;
        }else if ((self.socialPlatformType==OdinSocialPlatformTypeAliSocialTimeline)){
            scene=APSceneTimeLine;
        }
        [self shareToAliPay:object scene:scene];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}

#pragma mark -- share privateMethod
- (void)shareToAliPay:(OdinSocialMessageObject *)messageObj scene:(APScene)scene{
    if (![APOpenAPI isAPAppInstalled]) {
        if (self.shareCompletionBlock) {
            NSError *error=[NSError errorWithDomain:@"应用未安装" code:0 userInfo:@{@"userInfo":@"应用未安装"}];
            self.shareCompletionBlock(nil, error);
        }
        return ;
    }
    
    id shareObject=messageObj.shareObject;
    //  创建消息载体 APMediaMessage 对象
    APMediaMessage *message = [[APMediaMessage alloc] init];
    if (!shareObject) {
        //  创建文本类型的消息对象
        APShareTextObject *textObj = [[APShareTextObject alloc] init];
        textObj.text = messageObj.text;
        //  回填 APMediaMessage 的消息对象
        message.mediaObject = textObj;
 
    }else if ([shareObject isKindOfClass:[OdinShareImageObject class]]){
        OdinShareImageObject *odinImgObj=shareObject;
        
        //  创建图片类型的消息对象
        APShareImageObject *imgObj = [[APShareImageObject alloc] init];
        if ([odinImgObj.shareImage isKindOfClass:[NSData class]]) {
             imgObj.imageData = odinImgObj.shareImage;
        }else if([odinImgObj.shareImage isKindOfClass:[UIImage class]]){
            imgObj.imageData =UIImageJPEGRepresentation(odinImgObj.shareImage, .9);
        }else{
              imgObj.imageUrl = odinImgObj.shareImage;
        }
        //  回填 APMediaMessage 的消息对象
        message.mediaObject = imgObj;
        
    }else if ([shareObject isKindOfClass:[OdinShareWebpageObject class]]){
        OdinShareWebpageObject *odinWebObj=shareObject;
 
        message.title = odinWebObj.title;
        message.desc = odinWebObj.description;
        if ([odinWebObj.thumbImage isKindOfClass:[NSData class]]) {
            message.thumbData = odinWebObj.thumbImage;
        }else{
           message.thumbUrl = odinWebObj.thumbImage;
        }
 
        //  创建网页类型的消息对象
        APShareWebObject *webObj = [[APShareWebObject alloc] init];
        webObj.wepageUrl = odinWebObj.webpageUrl;
        //  回填 APMediaMessage 的消息对象
        message.mediaObject = webObj;

    }
    
    //  创建发送请求对象
    APSendMessageToAPReq *request = [[APSendMessageToAPReq alloc] init];
    //  填充消息载体对象
    request.message = message;
    //  分享场景，0为分享到好友，1为分享到生活圈；支付宝9.9.5版本至现在版本，分享入口已合并，这个scene并没有被使用，用户会在跳转进支付宝后选择分享场景（好友、动态、圈子等），但为保证老版本上无问题、建议还是照常传入
    request.scene = scene;
    //  发送请求
    BOOL result = [APOpenAPI sendReq:request];
    if (!result) {
        //失败处理
        NSLog(@"发送失败");
    }
}


#pragma mark --handleUrl
- (BOOL)odinSocial_handleOpenURL:(NSURL *)url{
    return  [APOpenAPI handleOpenURL:url delegate:self];
}

- (BOOL)odinSocial_handleOpenURL:(NSURL *)url options:(NSDictionary *)options{
    return  [APOpenAPI handleOpenURL:url delegate:self];
}

- (BOOL)odinSocial_handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return  [APOpenAPI handleOpenURL:url delegate:self];
}


#pragma mark --APOpenAPIDelegate

- (void)onResp:(APBaseResp *)resp{
    switch (resp.errCode) {
        case APSuccess:
            
            break;
           
        case APErrCodeUserCancel:
            
            break;
        case APErrCodeAuthDeny:
            
            break;
        case APErrCodeSentFail:
            
            break;
        case APErrCodeUnsupport:
            
            break;
        case APErrCodeCommon:
            
            break;
        default:
            break;
    }
    
    OdinSocialShareResponse *response=[OdinSocialShareResponse shareResponseWithMessage:resp.errStr];
    response.originalResponse=resp;
    NSError *error;
    if (resp.errCode!=APSuccess) {
        if (resp.errCode==-2) {
             error=[NSError errorWithDomain:resp.errStr code:OdinSocialPlatformErrorType_Cancel userInfo:@{@"info":resp.errStr}];
        }else{
            error=[NSError errorWithDomain:resp.errStr code:OdinSocialPlatformErrorType_ShareFailed userInfo:@{@"info":resp.errStr}];
        };
    }
    if (self.shareCompletionBlock) {
        self.shareCompletionBlock(response, error);
    }
}

-(void) onReq:(APBaseReq*)req{
  
}

@end
