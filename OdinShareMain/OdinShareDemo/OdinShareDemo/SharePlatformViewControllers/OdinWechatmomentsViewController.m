//
//  OdinWechatmomentsViewController.m
//  OdinShareDemo
//
//  Created by nathan on 2019/4/2.
//  Copyright © 2019 Odin. All rights reserved.
//

#import "OdinWechatmomentsViewController.h"

@interface OdinWechatmomentsViewController ()

@end

@implementation OdinWechatmomentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    platformType = OdinSocialPlatformSubTypeWechatTimeline;
    self.title = @"微信朋友圈";
    shareIconArray = @[@"textIcon",@"imageIcon",@"imageIcon",@"webURLIcon",@"audioURLIcon",@"videoURLIcon"];
    shareTypeArray = @[@"文字",@"图片",@"网络图片",@"链接",@"音乐链接",@"视频链接"];
    selectorNameArray = @[@"shareText",@"shareImage",@"shareHttpImg",@"shareLink",@"shareAudio",@"shareVideo"];
}

/**
 分享文字
 */
-(void)shareText
{
    
    OdinSocialMessageObject *obj=[[OdinSocialMessageObject alloc]init];
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

@end
