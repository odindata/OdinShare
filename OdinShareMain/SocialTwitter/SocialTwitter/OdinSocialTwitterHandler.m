//
//  SocialTwitter.m
//  SocialTwitter
//
//  Created by nathan on 2019/4/17.
//  Copyright © 2019 Odin. All rights reserved.
//

#import "OdinSocialTwitterHandler.h"

#import <TwitterKit/TWTRKit.h>

#define odin_twitterUser @"https://api.twitter.com/1.1/users/show.json"

@interface OdinSocialTwitterHandler ()<TWTRComposerViewControllerDelegate>

@end

@implementation OdinSocialTwitterHandler

static OdinSocialTwitterHandler *singleton = nil;
#pragma mark --life cycle
+ (instancetype)defaultManager
{
    if (singleton==nil) {
        singleton=[[OdinSocialTwitterHandler alloc]init];
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
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter://"]];
}

/**
 设置平台key、secret、redirectUrl
 
 @param appKey key
 @param appSecret secre
 @param redirectURL url
 */
- (void)odinSocial_setAppKey:(NSString *)appKey withAppSecret:(NSString *)appSecret withRedirectURL:(NSString *)redirectURL{
    [[Twitter sharedInstance] startWithConsumerKey:appKey consumerSecret:appSecret];
    self.appID=appKey;
    self.appSecret=appSecret;
}

/**
 分享
 
 @param object 分享的消息对象
 @param completionHandler 分享完成的回调
 */
- (void)odinSocial_ShareWithObject:(OdinSocialMessageObject *)object withCompletionHandler:(OdinSocialShareCompletionHandler)completionHandler{
    self.shareCompletionBlock = completionHandler;
    [self shareToTwiiter:object];
}


#pragma mark -- share PrivateMethod
- (void)shareToTwiiter:(OdinSocialMessageObject *)object{
    if(![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter://"]]) {
        if (self.shareCompletionBlock) {
            NSError *error=[NSError errorWithDomain:@"应用未安装" code:0 userInfo:@{@"info":@"应用未安装"}];
            self.shareCompletionBlock(nil, error);
        }
        return;
    }
    
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
    
    //调用方法
    TWTRComposer *composer = [[TWTRComposer alloc] init];
    
    //文字
    if (!shareObject) {
        //设置分享的标题
        [composer setText:object.text];
        [composer showFromViewController:fromVc completion:^(TWTRComposerResult result) {
            [self shareResult:result];
        }];
        
    }else if([shareObject isKindOfClass:[OdinShareImageObject class]]){
        OdinShareImageObject *odinImgObj=(OdinShareImageObject *)shareObject;
        //设置分享的标题
        [composer setText:object.text];
        [composer setImage:odinImgObj.shareImage];
        
        [composer showFromViewController:fromVc completion:^(TWTRComposerResult result) {
            [self shareResult:result];
        }];
        
    }else if ([shareObject isKindOfClass:[OdinShareWebpageObject class]]){
        OdinShareWebpageObject *odinWebObj=(OdinShareWebpageObject *)shareObject;
        //设置分享的标题
        [composer setText:object.text];
        //设置分享的URL
        [composer setURL:[NSURL URLWithString:odinWebObj.webpageUrl]];
        
        [composer showFromViewController:fromVc completion:^(TWTRComposerResult result) {
            [self shareResult:result];
        }];
        
    }else if([shareObject isKindOfClass:[OdinShareVideoObject class]]){
        OdinShareVideoObject *odinVideoObj=(OdinShareVideoObject *)shareObject;
        
        //封面(必须传) --data
        //本地文件
        //无封面- URL 无需封面
        //才用 UIImagePickerControllerMediaURL时 初始化用 URL的方式 不要用assets-library
        //检查是否当前会话具有登录的用户
        
        
        //本地视频时 才用Data的方式传递 必需封面
        //相册视频才用URL的方 无需封面
        if ([[Twitter sharedInstance].sessionStore hasLoggedInUsers]) {
            if (odinVideoObj.thumbImage) {
                TWTRComposerViewController *videoComposer = [TWTRComposerViewController emptyComposer];
                videoComposer= [videoComposer initWithInitialText:object.text image:odinVideoObj.thumbImage videoData:[NSData dataWithContentsOfFile:odinVideoObj.videoUrl]];
                [fromVc presentViewController:videoComposer animated:YES completion:nil];
                videoComposer.delegate=self;
            }else{
                TWTRComposerViewController *videoComposer = [TWTRComposerViewController emptyComposer];
                videoComposer= [videoComposer initWithInitialText:object.text image:nil videoURL:[NSURL URLWithString:odinVideoObj.videoUrl]];
                [fromVc presentViewController:videoComposer animated:YES completion:nil];
                videoComposer.delegate=self;
            }
        } else {
            [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
                if (session) {
                    if (odinVideoObj.thumbImage) {
                        TWTRComposerViewController *videoComposer = [TWTRComposerViewController emptyComposer];
                        videoComposer= [videoComposer initWithInitialText:object.text image:odinVideoObj.thumbImage videoData:[NSData dataWithContentsOfFile:odinVideoObj.videoUrl]];
                        [fromVc presentViewController:videoComposer animated:YES completion:nil];
                        videoComposer.delegate=self;
                    }else{
                        TWTRComposerViewController *videoComposer = [TWTRComposerViewController emptyComposer];
                        videoComposer= [videoComposer initWithInitialText:object.text image:nil videoURL:[NSURL URLWithString:odinVideoObj.videoUrl]];
                        [fromVc presentViewController:videoComposer animated:YES completion:nil];
                        videoComposer.delegate=self;
                    }
                    
                } else {
                    //分享失败 账号登录失败
                    OdinSocialShareResponse *response=[OdinSocialShareResponse shareResponseWithMessage:@"分享失败"];
                    NSError *errorT=[NSError errorWithDomain:@"分享失败" code:error.code userInfo:@{@"info":error.userInfo}];
                    if (self.shareCompletionBlock) {
                        self.shareCompletionBlock(response,errorT);
                    }
                }
            }];
        }
    }
}

- (void)shareResult:(TWTRComposerResult )result{
    if (result == TWTRComposerResultCancelled) {
        NSLog(@"Tweet composition cancelled");
        OdinSocialShareResponse *response=[OdinSocialShareResponse shareResponseWithMessage:@"取消分享"];
        NSError *error=[NSError errorWithDomain:@"取消分享" code:OdinSocialPlatformErrorType_Cancel userInfo:@{@"info":@"取消分享"}];
        if (self.shareCompletionBlock) {
            self.shareCompletionBlock(response,error);
        }
    }else {
        OdinSocialShareResponse *response=[OdinSocialShareResponse shareResponseWithMessage:@"分享成功"];
        if (self.shareCompletionBlock) {
            self.shareCompletionBlock(response,nil);
        }
    }
}

#pragma mark --TWTRComposerViewControllerDelegate
- (void)composerDidSucceed:(TWTRComposerViewController *)controller withTweet:(TWTRTweet *)tweet{
    OdinSocialShareResponse *response=[OdinSocialShareResponse shareResponseWithMessage:@"分享成功"];
    response.originalResponse=tweet;
    if (self.shareCompletionBlock) {
        self.shareCompletionBlock(response,nil);
    }
}

- (void)composerDidCancel:(TWTRComposerViewController *)controller{
    OdinSocialShareResponse *response=[OdinSocialShareResponse shareResponseWithMessage:@"取消分享"];
    NSError *error=[NSError errorWithDomain:@"取消分享" code:OdinSocialPlatformErrorType_Cancel userInfo:@{@"info":@"取消分享"}];
    if (self.shareCompletionBlock) {
        self.shareCompletionBlock(response,error);
    }
}

- (void)composerDidFail:(TWTRComposerViewController *)controller withError:(NSError *)error{
    OdinSocialShareResponse *response=[OdinSocialShareResponse shareResponseWithMessage:@"分享失败"];
    NSError *errorT=[NSError errorWithDomain:@"分享失败" code:OdinSocialPlatformErrorType_ShareFailed userInfo:@{@"info":error.userInfo}];
    if (self.shareCompletionBlock) {
        self.shareCompletionBlock(response,errorT);
    }
}

#pragma mark -- OpenURL
- (BOOL)odinSocial_handleOpenURL:(NSURL *)url options:(NSDictionary *)options{
   return   [[Twitter sharedInstance] application:[UIApplication sharedApplication] openURL:url options:options];
}


//////////////////////////////授权登录 开始//////////////////////////////
-(void)odinSocial_RequestForUserProfileWithCompletionHandler:(OdinSocialGetUserInfoCompletionHandler)completionHandler{
    self.userinfoCompletionBlock = completionHandler;
    if(![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter://"]]) {
        if (self.userinfoCompletionBlock) {
            NSError *error=[NSError errorWithDomain:@"应用未安装" code:OdinSocialPlatformErrorType_NotInstall userInfo:@{@"info":@"应用未安装"}];
            self.userinfoCompletionBlock(nil, error);
        }
        return;
    }
    
    __block BOOL login;
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
        if (session&&login==NO) {
            login=YES;
            OdinSocialUserInfoResponse *userInfoResponse=[[OdinSocialUserInfoResponse alloc]init];
        
            TWTRAPIClient *client=[TWTRAPIClient clientWithCurrentUser];
            [client loadUserWithID:[session userID] completion:^(TWTRUser * _Nullable user, NSError * _Nullable error) {
                //登录成功后 获取用户信息
                NSURLRequest *request=[client URLRequestWithMethod:@"GET" URLString:odin_twitterUser parameters:@{@"user_id":session.userID,@"screen_name":user.screenName} error:nil];
                
                [client sendTwitterRequest:request completion:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
                    if (connectionError==nil) {
                        NSDictionary *userDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                        
                        userInfoResponse.originalResponse=session;
                        userInfoResponse.name=[session userName];
                        userInfoResponse.uid=[session userID];//用户id
                        userInfoResponse.accessToken=[session authToken];
                        userInfoResponse.iconurl=userDic[@"profile_image_url"];
                        
                        //存缓存数据
                        OdinUser *userInfo=[OdinUser new];
                        userInfo.sharingPlatfrom=[NSString stringWithFormat:@"%lu",(unsigned long)OdinSocialPlatformTypeTwitter];
                        [userInfo setValue:[session userID] forKey:@"uid"];
                        userInfo.nickname=[session userName];
                        userInfo.sign=session.authToken;
                        userInfo.avatar=userDic[@"profile_image_url"];
                        userInfo.originUserData=userDic;
                        NSString *domain = [NSString stringWithFormat:@"OdinShareSDK-Platform-%lu-%@",(unsigned long)self.socialPlatformType,self.appID];
                        [[OdinDataService new] setCacheData:userInfo forKey:@"currentUser" domain:domain];
                        
                        if (self.userinfoCompletionBlock) {
                            self.userinfoCompletionBlock(userInfoResponse, nil);
                        }
                    }else{
                        NSError *errorR=[NSError errorWithDomain:[connectionError localizedDescription] code:OdinSocialPlatformErrorType_RequestForUserProfileFailed userInfo:@{@"info":[error localizedDescription]}];
                        if (self.userinfoCompletionBlock) {
                            self.userinfoCompletionBlock(nil, errorR);
                        }
                    }
                }];
            }];
        } else {
            if (login==NO) {
                login=YES;
                NSError *errorR=[NSError errorWithDomain:[error localizedDescription] code:OdinSocialPlatformErrorType_AuthorizeFailed userInfo:@{@"info":[error localizedDescription]}];
                if (error.code==1) {
                    //取消登录
                    errorR=[NSError errorWithDomain:[error localizedDescription] code:OdinSocialPlatformErrorType_Cancel userInfo:@{@"info":[error localizedDescription]}];
                }
                if (self.userinfoCompletionBlock) {
                    self.userinfoCompletionBlock(nil, errorR);
                }
            }
        }
    }];
}

- (void)odinSocial_cancelAuthWithCompletionHandler:(OdinSocialRequestCompletionHandler)completionHandler{
    //TODO..
}
//////////////////////////////授权登录 结束//////////////////////////////
@end
