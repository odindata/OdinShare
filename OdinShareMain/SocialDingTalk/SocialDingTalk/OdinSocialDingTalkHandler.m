//
//  SocialDingTalk.m
//  SocialDingTalk
//
//  Created by nathan on 2019/8/5.
//  Copyright © 2019 odin. All rights reserved.
//

#import "OdinSocialDingTalkHandler.h"
#import <DTShareKit/DTOpenKit.h>

static OdinSocialDingTalkHandler *singleton = nil;

@interface OdinSocialHandler ()<DTOpenAPIDelegate>

@end

@implementation OdinSocialDingTalkHandler

#pragma mark --life cycle

+ (instancetype)defaultManager{
    if (singleton==nil) {
        singleton=[[OdinSocialDingTalkHandler alloc]init];
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
    return  [DTOpenAPI isDingTalkInstalled];
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
    [DTOpenAPI registerApp:appKey];
    
}

/**
 分享
 
 @param object 分享的消息对象
 @param completionHandler 分享完成的回调
 */
- (void)odinSocial_ShareWithObject:(OdinSocialMessageObject *)object withCompletionHandler:(OdinSocialShareCompletionHandler)completionHandler{
    self.shareCompletionBlock = completionHandler;
    @try {
        [self shareToDingTalk:object];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
   
}

- (void)shareToDingTalk:(OdinSocialMessageObject *)object{
    
    if(![DTOpenAPI isDingTalkInstalled]) {
        if (self.shareCompletionBlock) {
            NSError *error=[NSError errorWithDomain:@"应用未安装" code:0 userInfo:@{@"info":@"应用未安装"}];
            self.shareCompletionBlock(nil, error);
        }
        return;
    }
    
    DTSendMessageToDingTalkReq *sendMessageReq = [[DTSendMessageToDingTalkReq alloc] init];
    DTMediaMessage *mediaMessage = [[DTMediaMessage alloc] init];
    
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
    
    //文本
    if (!shareObject) {
        //设置分享的标题
        DTMediaTextObject *textObject = [[DTMediaTextObject alloc] init];
        textObject.text = object.text;
        
        mediaMessage.mediaObject = textObject;
        sendMessageReq.message = mediaMessage;
        
    }else if([shareObject isKindOfClass:[OdinShareImageObject class]]){
        //图片
        DTMediaImageObject *imageObject = [[DTMediaImageObject alloc] init];
        OdinShareImageObject *odinImgObj=(OdinShareImageObject *)shareObject;
        
        if ([odinImgObj.shareImage isKindOfClass:[NSData class]]) {
            imageObject.imageData = odinImgObj.shareImage;
        }else if([odinImgObj.shareImage isKindOfClass:[UIImage class]]){
            imageObject.imageData =UIImageJPEGRepresentation(odinImgObj.shareImage, .9);
        }else{
            imageObject.imageURL = odinImgObj.shareImage;
        }
        mediaMessage.mediaObject = imageObject;
        sendMessageReq.message = mediaMessage;
    }else if ([shareObject isKindOfClass:[OdinShareWebpageObject class]]){
        //链接
        DTMediaWebObject *webObject = [[DTMediaWebObject alloc] init];
        webObject.pageURL = @"http://www.dingtalk.com/";
        
        mediaMessage.title = @"钉钉";
        
        mediaMessage.thumbURL = @"https://static.dingtalk.com/media/lALOGp__Tnh4_120_120.png";
        
        // Or Set a image data which less than 32K.
        // mediaMessage.thumbData = UIImagePNGRepresentation([UIImage imageNamed:@"open_icon"]);
        
        mediaMessage.messageDescription = @"钉钉，是一个工作方式。为企业量身打造统一办公通讯平台";
        mediaMessage.mediaObject = webObject;
        sendMessageReq.message = mediaMessage;
        
        OdinShareWebpageObject *odinWebObj=(OdinShareWebpageObject *)shareObject;
        mediaMessage.title = odinWebObj.title;
        mediaMessage.messageDescription = odinWebObj.descr;
        if ([odinWebObj.thumbImage isKindOfClass:[NSData class]]) {
            mediaMessage.thumbData = odinWebObj.thumbImage;
        }else{
            mediaMessage.thumbURL = odinWebObj.thumbImage;
        }
        
        //  创建网页类型的消息对象
        mediaMessage.mediaObject = webObject;
        sendMessageReq.message=mediaMessage;
    }
    BOOL result = [DTOpenAPI sendReq:sendMessageReq];
    if (result){
//        NSLog(@"Link 发送成功.");
    }else{
        if (self.shareCompletionBlock) {
            NSError *error=[NSError errorWithDomain:@"发送失败" code:OdinSocialPlatformErrorType_ShareFailed userInfo:@{@"info":@"发送失败"}];
            self.shareCompletionBlock(nil, error);
        }
    }
    
}


#pragma mark -- Openurl
- (BOOL)odinSocial_handleOpenURL:(NSURL *)url{
    return  [DTOpenAPI handleOpenURL:url delegate:self];
}

- (BOOL)odinSocial_handleOpenURL:(NSURL *)url options:(NSDictionary *)options{
    return  [DTOpenAPI handleOpenURL:url delegate:self];
}

- (BOOL)odinSocial_handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return  [DTOpenAPI handleOpenURL:url delegate:self];
}

#pragma mark -- DTOpenAPIDelegate
- (void)onReq:(DTBaseReq *)req{
    
}

- (void)onResp:(DTBaseResp *)resp{
    
    OdinSocialPlatformErrorType errorType=OdinSocialPlatformErrorType_Unknow;
    
    switch (resp.errorCode) {
            case DTOpenAPISuccess:
            
            break;
            
            case DTOpenAPIErrorCodeCommon:
            errorType=OdinSocialPlatformErrorType_Unknow;
            break;
            
            case DTOpenAPIErrorCodeUserCancel:
            errorType=OdinSocialPlatformErrorType_Cancel;
            break;
            
            case DTOpenAPIErrorCodeSendFail:
            errorType=OdinSocialPlatformErrorType_ShareFailed;
            break;
            
            case DTOpenAPIErrorCodeAuthDeny:
              errorType=OdinSocialPlatformErrorType_AuthorizeFailed;
            break;
            
            case DTOpenAPIErrorCodeUnsupport:
            errorType=OdinSocialPlatformErrorType_ShareDataTypeIllegal;
            break;
            
        default:
            break;
    }
    OdinSocialShareResponse *response=[OdinSocialShareResponse shareResponseWithMessage:resp.errorMessage];
    response.originalResponse=resp;
    if (resp.errorCode!=DTOpenAPISuccess) {
        if (self.shareCompletionBlock) {
            self.shareCompletionBlock(response, nil);
        }
    }else{
         NSError *error=[NSError errorWithDomain:resp.errorMessage code:errorType userInfo:@{@"info":resp.errorMessage}];
        if (self.shareCompletionBlock) {
            self.shareCompletionBlock(response, error);
        }
    }
}
@end
