//
//  OdinWechatcontactsViewController.m
//  OdinShareDemo
//
//  Created by nathan on 2019/3/27.
//  Copyright © 2019 Odin. All rights reserved.
//

#import "OdinWechatcontactsViewController.h"
#import "OdinInputViewController.h"
@interface OdinWechatcontactsViewController ()

@end

@implementation OdinWechatcontactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    platformType = OdinSocialPlatformSubTypeWechatSession;
    self.title = @"微信好友";
    shareIconArray = @[@"textIcon",@"imageIcon",@"webURLIcon",@"audioURLIcon",@"videoURLIcon",@"appInfoIcon",@"emoIcon",@"videoIcon",@"miniIcon"];
    shareTypeArray = @[@"文字",@"图片",@"网络图片",@"链接",@"音乐链接",@"视频链接",
//                       @"应用消息",
                       @"表情",@"文件（本地视频）",@"小程序"];
    selectorNameArray = @[@"shareText",@"shareImage",@"shareHttpImg",@"shareLink",@"shareAudio",@"shareVideo",
//                          @"shareApp",
                          @"shareEmoticon",@"shareFile",@"shareMiniProgram"];
}


/**
 分享文字
 */
-(void)shareText
{

    OdinSocialMessageObject *obj=[[OdinSocialMessageObject alloc]init];
    obj.text=self.inputVc.textField.text;
    [self shareWithObj:obj];
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
    obj.shareObject=imgObj;
    [self shareWithObj:obj];
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
    webObj.descr=self.inputVc.desrcTextView.text;
    webObj.webpageUrl=self.inputVc.webPageTxtFiled.text;
    webObj.title=self.inputVc.titleTextField.text;
    obj.shareObject=webObj;
    [self shareWithObj:obj];
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
    [self shareWithObj:obj];
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
    [self shareWithObj:obj];
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
    emotionObj.thumbImage=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"COD13" ofType:@"jpg"]];
    emotionObj.emotionData=self.inputVc.emotionData;
    
    obj.shareObject=emotionObj;
     [self shareWithObj:obj];
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
    [self shareWithObj:obj];
}

- (void)shareMiniProgram
{
    OdinSocialMessageObject *obj=[[OdinSocialMessageObject alloc]init];
    OdinShareMiniProgramObject *miniObj=[[OdinShareMiniProgramObject alloc]init];
    miniObj.thumbImage=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"COD13" ofType:@"jpg"]];
    miniObj.hdImageData;//todo..
    miniObj.userName=@"gh_afb25ac019c9";
    miniObj.miniProgramType=0;
    miniObj.path=@"pages/index/index";
    miniObj.webpageUrl=@"http://www.mob.com";
    miniObj.withShareTicket=YES;
    obj.shareObject=miniObj;
    [self shareWithObj:obj];
}
@end
