# OdinShare
奥丁分享SDK
### CocoaPods
[CocoaPods](http://cocoapods.org) 是向项目添加OdinShare的推荐方法。

1. 将OdinShare的pod条目添加到您的Podfile文件中
###### 集成所有平台
	 pod 'OdinShare'
###### 集成微信平台
	 pod 'OdinShare/Social/SocialWeChat'
###### 集成QQ平台
	 pod 'OdinShare/Social/SocialQQ'
###### 集成新浪微博平台
	 pod 'OdinShare/Social/SocialSina'
###### 集成微信支付宝
	 pod 'OdinShare/Social/SocialAliPay'
###### 集成Facebook平台
	 pod 'OdinShare/Social/SocialFacebook'
###### 集成Twitter平台
	 pod 'OdinShare/Social/SocialTwitter'
###### 集成Instagram平台
	 pod 'OdinShare/Social/SoicalInstagram'
	
2. 通过运行“pod Install”安装

3. 把OdinShare放在你需要的地方`#import "OdinShareSDK/OdinShareSDK.h"`.

# 使用
1.在项目的info.plist中添加OdinKey和OdinSecret,如下图
![avatar](https://github.com/odindata/OdinShare/blob/master/demo.png)
2. 在didFinishLaunchingWithOptions中设置各平台的key和secret以及回调地址
```objective-c

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	 [[OdinSocialManager  defaultManager] setPlaform:OdinSocialPlatformSubTypeWechatSession appKey:@"微信平台的key" appSecret:@"微信平台的secret" redirectURL:@“分享的回调地址”];
}
```

3. 设置系统回调
```objective-c
// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
   
    BOOL result = [[OdinSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
         // 其他如支付等SDK的回调
    }
    return result;
}
```
3.开始分享
```objective-c

/**
 分享文字
 */
-(void)shareText
{

    OdinSocialMessageObject *obj=[[OdinSocialMessageObject alloc]init];
    obj.text=@“分享文字”;
     [[OdinSocialManager defaultManager] shareToPlatform:platformType messageObject:obj currentViewController:self completion:^(id result, NSError *error) {
        
    }];
}


/**
 分享图片
 */
- (void)shareImage
{
    OdinSocialMessageObject *obj=[[OdinSocialMessageObject alloc]init];
    OdinShareImageObject *imgObj=[[OdinShareImageObject alloc]init]; 
    imgObj.shareImage=[UIImage imageNamed:@"分享图片"];;
    obj.shareObject=imgObj;
    [[OdinSocialManager defaultManager] shareToPlatform:platformType messageObject:obj currentViewController:self completion:^(id result, NSError *error) {
        
    }];
}

//分享链接
- (void)shareLink
{
    OdinSocialMessageObject *obj=[[OdinSocialMessageObject alloc]init];
    OdinShareWebpageObject *webObj=[[OdinShareWebpageObject alloc]init];
    webObj.title=@"分享标题";
    webObj.descr=@"分享描述";
    webObj.webpageUrl=@"链接地址";
    obj.shareObject=webObj;
    [[OdinSocialManager defaultManager] shareToPlatform:platformType messageObject:obj currentViewController:self completion:^(id result, NSError *error) {
        
    }];
}

//分享音乐
- (void)shareAudio
{
    OdinSocialMessageObject *obj=[[OdinSocialMessageObject alloc]init];
    
    OdinShareMusicObject *musicObj=[[OdinShareMusicObject alloc]init];
    musicObj.thumbImage=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"缩略图" ofType:@"jpg"]];
    musicObj.title=title=@"分享标题";
    musicObj.descr=@"分享描述";
    musicObj.musicUrl=@"链接地址";
    obj.shareObject=musicObj;
    [[OdinSocialManager defaultManager] shareToPlatform:platformType messageObject:obj currentViewController:self completion:^(id result, NSError *error) {
        
    }];
}

//分享视频
- (void)shareVideo
{
    
    OdinSocialMessageObject *obj=[[OdinSocialMessageObject alloc]init];
    OdinShareVideoObject *videoObj=[[OdinShareVideoObject alloc]init];
    videoObj.thumbImage=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"缩略图" ofType:@"jpg"]];

    videoObj.title=@"分享标题";
    videoObj.descr=@"分享描述";
    videoObj.videoUrl=@"链接地址";
    
    obj.shareObject=videoObj;
    [[OdinSocialManager defaultManager] shareToPlatform:platformType messageObject:obj currentViewController:self completion:^(id result, NSError *error) {
        
    }];
}

