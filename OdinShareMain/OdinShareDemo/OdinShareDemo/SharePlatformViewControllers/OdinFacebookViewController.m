//
//  OdinFacebookViewController.m
//  OdinShareDemo
//
//  Created by nathan on 2019/4/16.
//  Copyright © 2019 Odin. All rights reserved.
//

#import "OdinFacebookViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
@interface OdinFacebookViewController ()<UIAlertViewDelegate>

@end

@implementation OdinFacebookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    platformType = OdinSocialPlatformTypeFacebook;
    self.title = @"Facebook";
    shareIconArray = @[@"textAndImageIcon",@"mutImageIcon",@"webURLIcon",@"videoURLIcon",@"webURLIcon"];
//    shareTypeArray = @[@"单图",@"多图",@"链接 APP",@"相册视频",@"应用邀请"];
    shareTypeArray = @[@"单图",@"多图",@"链接 APP",@"相册视频"];
    selectorNameArray = @[@"shareImage",@"shareImages",@"shareLink",@"shareAssetVideo",@"shareApp"];
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
    }else if (self.inputVc.imgUrlTxtFiled.text.length>0){
         shareImg=self.inputVc.imgUrlTxtFiled.text;
    }
    imgObj.shareImage=shareImg;
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
    webObj.title=self.inputVc.textField.text;
    
    obj.shareObject=webObj;
    [self shareWithObj:obj];
}

- (void)shareImages
{
    OdinSocialMessageObject *obj=[[OdinSocialMessageObject alloc]init];
    obj.text=@"分享图片";
    OdinShareImageObject *imgObj=[[OdinShareImageObject alloc]init];
    if (self.inputVc.photoImgArr.count>0) {
          imgObj.shareImageArray=self.inputVc.photoImgArr;
    }else if(self.inputVc.imgUrlTxtFiled.text.length>0){
        imgObj.shareImageArray=@[self.inputVc.imgUrlTxtFiled.text];
    }else{
        imgObj.shareImageArray=@[[UIImage imageWithContentsOfFile:self.inputVc.photoImgLbl.text]];
    }
 

    obj.shareObject=imgObj;
    [self shareWithObj:obj];
}

- (void)shareAssetVideo
{

    
    if ([self.inputVc.photoVideoUrl absoluteString].length>0) {
        OdinSocialMessageObject *obj=[[OdinSocialMessageObject alloc]init];
        OdinShareVideoObject *videoObj=[[OdinShareVideoObject alloc]init];
        videoObj.title=self.inputVc.titleTextField.text;
        videoObj.descr=self.inputVc.desrcTextView.text;
        videoObj.videoUrl=[self.inputVc.photoVideoUrl absoluteString];
        
        obj.shareObject=videoObj;
        [self shareWithObj:obj];
    }else{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"cat" ofType:@"mp4"];
        NSString *path1 = [[NSBundle mainBundle] pathForResource:@"COD13" ofType:@"jpg"];
        NSURL *url = [NSURL URLWithString:path];
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
        __weak __typeof__ (self) weakSelf = self;
        [assetsLibrary writeVideoAtPathToSavedPhotosAlbum:url completionBlock:^(NSURL *assetURL, NSError *error) {
            //iPad版本QQ 暂时未支持此功能
            OdinSocialMessageObject *obj=[[OdinSocialMessageObject alloc]init];
            OdinShareVideoObject *videoObj=[[OdinShareVideoObject alloc]init];
            videoObj.thumbImage=[UIImage imageWithContentsOfFile:path1];
            videoObj.title=@"title";
            videoObj.descr=@"视频分享";
            videoObj.videoUrl=[assetURL absoluteString];
            obj.shareObject=videoObj;
            [weakSelf shareWithObj:obj];
        }];
    }
  
}

- (void)shareApp
{
 
}

@end
