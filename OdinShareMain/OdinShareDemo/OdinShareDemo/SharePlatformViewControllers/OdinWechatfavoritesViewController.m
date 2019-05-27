//
//  OdinWechatfavoritesViewController.m
//  OdinShareDemo
//
//  Created by nathan on 2019/4/3.
//  Copyright © 2019 Odin. All rights reserved.
//

#import "OdinWechatfavoritesViewController.h"

@implementation OdinWechatfavoritesViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    platformType = OdinSocialPlatformSubTypeWechatFav;
    self.title = @"微信收藏";
    shareIconArray = @[@"textIcon",@"imageIcon",@"imageIcon",@"webURLIcon",@"audioURLIcon",@"videoURLIcon",@"videoIcon"];
    shareTypeArray = @[@"文字",@"图片",@"网络图片",@"链接",@"音乐链接",@"视频链接",@"文件"];
    selectorNameArray = @[@"shareText",@"shareImage",@"shareHttpImg",@"shareLink",@"shareAudio",@"shareVideo",@"shareFile"];
}

/**
 分享文字
 */
-(void)shareText
{
    
    OdinSocialMessageObject *obj=[[OdinSocialMessageObject alloc]init];
//    obj.text=@"分享SDK";
    obj.text=self.inputVc.textField.text;
    [[OdinSocialManager defaultManager] shareToPlatform:platformType messageObject:obj currentViewController:self completion:^(id result, NSError *error) {
        [self alertWithError:error];
    }];
}

/**
 分享图片
 */
- (void)shareImage
{
    OdinSocialMessageObject *obj=[[OdinSocialMessageObject alloc]init];
    OdinShareImageObject *imgObj=[[OdinShareImageObject alloc]init];
    id shareImg;
    if (self.inputVc.photoImg) {
        shareImg=self.inputVc.photoImg;
    }else{
        shareImg=[UIImage imageWithContentsOfFile:self.inputVc.photoImgLbl.text];
    }
    
    imgObj.shareImage=shareImg;
    imgObj.thumbImage=UIImageJPEGRepresentation(shareImg, .5);
    obj.shareObject=imgObj;
    [[OdinSocialManager defaultManager] shareToPlatform:platformType messageObject:obj currentViewController:self completion:^(id result, NSError *error) {
        [self alertWithError:error];
    }];
}

- (void)shareHttpImg{
    OdinSocialMessageObject *obj=[[OdinSocialMessageObject alloc]init];
    OdinShareImageObject *imgObj=[[OdinShareImageObject alloc]init];
    imgObj.shareImage=self.inputVc.imgUrlTxtFiled.text;
    obj.shareObject=imgObj;
    [self shareWithObj:obj];
}

- (void)shareLink
{
    OdinSocialMessageObject *obj=[[OdinSocialMessageObject alloc]init];
    OdinShareWebpageObject *webObj=[[OdinShareWebpageObject alloc]init];

    webObj.thumbImage=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"COD13" ofType:@"jpg"]];
    webObj.descr=self.inputVc.desrcTextView.text;
    webObj.webpageUrl=self.inputVc.webPageTxtFiled.text;
    webObj.title=self.inputVc.titleTextField.text;
    
    obj.shareObject=webObj;
    [[OdinSocialManager defaultManager] shareToPlatform:platformType messageObject:obj currentViewController:self completion:^(id result, NSError *error) {
        [self alertWithError:error];
    }];
}

- (void)shareAudio
{
    
    OdinSocialMessageObject *obj=[[OdinSocialMessageObject alloc]init];
    
    OdinShareMusicObject *musicObj=[[OdinShareMusicObject alloc]init];
    musicObj.thumbImage=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"COD13" ofType:@"jpg"]];
    musicObj.title=self.inputVc.titleTextField.text;
    musicObj.descr=self.inputVc.desrcTextView.text;
    musicObj.musicUrl=self.inputVc.muiscUrlTextField.text;
    
    obj.shareObject=musicObj;
    [[OdinSocialManager defaultManager] shareToPlatform:platformType messageObject:obj currentViewController:self completion:^(id result, NSError *error) {
        [self alertWithError:error];
    }];
}

- (void)shareVideo
{
    
    OdinSocialMessageObject *obj=[[OdinSocialMessageObject alloc]init];
    OdinShareVideoObject *videoObj=[[OdinShareVideoObject alloc]init];
    videoObj.thumbImage=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"COD13" ofType:@"jpg"]];
    videoObj.title=self.inputVc.titleTextField.text;
    videoObj.descr=self.inputVc.desrcTextView.text;
    videoObj.videoUrl=self.inputVc.videoUrlTextField.text;
    
    obj.shareObject=videoObj;
    [[OdinSocialManager defaultManager] shareToPlatform:platformType messageObject:obj currentViewController:self completion:^(id result, NSError *error) {
        [self alertWithError:error];
    }];
}
//
//- (void)shareApp
//{
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    //平台定制
//    [parameters SSDKSetupWeChatParamsByText:@"share SDK"
//                                      title:@"App消息"
//                                        url:[NSURL URLWithString:@"http://www.mob.com"]
//                                 thumbImage:[[NSBundle mainBundle] pathForResource:@"COD13" ofType:@"jpg"]
//                                      image:nil
//                               musicFileURL:nil
//                                    extInfo:nil
//                                   fileData:[@"13232" dataUsingEncoding:NSUTF8StringEncoding]
//                               emoticonData:nil
//                        sourceFileExtension:nil
//                             sourceFileData:nil
//                                       type:SSDKContentTypeApp
//                         forPlatformSubType:SSDKPlatformSubTypeWechatSession];
//    [self shareWithParameters:parameters];
//}
//
- (void)shareEmoticon
{
    OdinSocialMessageObject *obj=[[OdinSocialMessageObject alloc]init];
    OdinShareEmotionObject *emotionObj=[[OdinShareEmotionObject alloc]init];
    emotionObj.emotionData=self.inputVc.emotionData;
    obj.shareObject=emotionObj;
    [[OdinSocialManager defaultManager] shareToPlatform:platformType messageObject:obj currentViewController:self completion:^(id result, NSError *error) {
        [self alertWithError:error];
    }];
}

- (void)shareFile
{
    static NSString *kFileExtension = @"pdf";
    static NSString *kFileName = @"iphone4";
    NSString* filePath = [[NSBundle mainBundle] pathForResource:kFileName
                                                        ofType:kFileExtension];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    
    OdinSocialMessageObject *obj=[[OdinSocialMessageObject alloc]init];
    OdinShareFileObject *fileObj=[[OdinShareFileObject alloc]init];
    fileObj.thumbImage=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"COD13" ofType:@"jpg"]];
    fileObj.title=self.inputVc.titleTextField.text;
    fileObj.descr=self.inputVc.desrcTextView.text;
    fileObj.fileData=fileData;
    fileObj.fileExtension=kFileExtension;
    obj.shareObject=fileObj;
    [[OdinSocialManager defaultManager] shareToPlatform:platformType messageObject:obj currentViewController:self completion:^(id result, NSError *error) {
        [self alertWithError:error];
    }];
}
@end
