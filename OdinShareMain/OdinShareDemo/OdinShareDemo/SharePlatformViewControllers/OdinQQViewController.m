//
//  OdinQQViewController.m
//  OdinShareDemo
//
//  Created by nathan on 2019/4/1.
//  Copyright © 2019 Odin. All rights reserved.
//

#import "OdinQQViewController.h"

@interface OdinQQViewController ()<UIAlertViewDelegate>

@end

@implementation OdinQQViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    platformType = OdinSocialPlatformSubTypeQQFriend;
    self.title = @"QQ好友";
    shareIconArray = @[@"textIcon",@"imageIcon",@"webURLIcon",@"audioURLIcon",@"videoIcon"];
    shareTypeArray = @[@"文字",@"图片",@"链接",@"音乐链接",@"视频链接"];
    selectorNameArray = @[@"shareText",@"shareImage",@"shareLink",@"shareAudio",@"shareVideo"];
}

/**
 分享文字
 */
- (void)shareText
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

- (void)shareLink
{
    OdinSocialMessageObject *obj=[[OdinSocialMessageObject alloc]init];
    OdinShareWebpageObject *webObj=[[OdinShareWebpageObject alloc]init];
    webObj.descr=self.inputVc.desrcTextView.text.length>0?self.inputVc.desrcTextView.text:@"";
    webObj.webpageUrl=self.inputVc.webPageTxtFiled.text;
    webObj.title=self.inputVc.titleTextField.text.length>0?self.inputVc.titleTextField.text:@"";
    
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
    videoObj.title=self.inputVc.titleTextField.text;
    videoObj.descr=self.inputVc.desrcTextView.text;
    videoObj.videoUrl=self.inputVc.videoUrlTextField.text;

    obj.shareObject=videoObj;
    [self shareWithObj:obj];
}

@end
