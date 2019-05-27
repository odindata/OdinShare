//
//  OdinQZoneViewController.m
//  OdinShareDemo
//
//  Created by nathan on 2019/4/1.
//  Copyright © 2019 Odin. All rights reserved.
//

#import "OdinQZoneViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
@interface OdinQZoneViewController ()

@end

@implementation OdinQZoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    platformType = OdinSocialPlatformTypeQQ;
    self.title = @"QZone";
    shareIconArray = @[@"textIcon",@"imageIcon",@"webURLIcon",@"videoIcon"];
    shareTypeArray = @[@"文字",@"图片",@"链接",@"相册视频"];
    selectorNameArray = @[@"shareText",@"shareImage",@"shareLink",@"shareAssetVideo"];
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
    obj.text=@"分享图片";
    OdinShareImageObject *imgObj=[[OdinShareImageObject alloc]init];

    imgObj.shareImageArray=self.inputVc.photoImgArr;
    if (imgObj.shareImageArray.count==0) {
         imgObj.shareImageArray=@[[UIImage imageWithContentsOfFile:self.inputVc.photoImgLbl.text]];
    }
    obj.shareObject=imgObj;
    [self shareWithObj:obj];
}

- (void)shareLink
{
   
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://n1.itc.cn/img8/wb/common/2016/08/13/qianfan.png"]];
    OdinSocialMessageObject *obj=[[OdinSocialMessageObject alloc]init];
    OdinShareWebpageObject *webObj=[[OdinShareWebpageObject alloc]init];
    webObj.thumbImage=[UIImage imageWithData:data];

    webObj.descr=self.inputVc.desrcTextView.text;
    webObj.webpageUrl=self.inputVc.webPageTxtFiled.text;
    webObj.title=self.inputVc.titleTextField.text;
    
    obj.shareObject=webObj;
    [self shareWithObj:obj];
}

- (void)shareAssetVideo
{
    if ([self.inputVc.photoVideoUrl absoluteString].length>0) {
        OdinSocialMessageObject *obj=[[OdinSocialMessageObject alloc]init];
        OdinShareVideoObject *videoObj=[[OdinShareVideoObject alloc]init];
        
        videoObj.title=self.inputVc.titleTextField.text;
        videoObj.descr=self.inputVc.desrcTextView.text;
        videoObj.videoUrl=[self.inputVc.photoVideoUrl absoluteString];;
        
        obj.shareObject=videoObj;
        [self shareWithObj:obj];
    }else{
        NSURL *url = [NSURL URLWithString:self.inputVc.photoVideoLbl.text];
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
        __weak __typeof__ (self) weakSelf = self;
        [assetsLibrary writeVideoAtPathToSavedPhotosAlbum:url completionBlock:^(NSURL *assetURL, NSError *error) {
            //iPad版本QQ 暂时未支持此功能
            OdinSocialMessageObject *obj=[[OdinSocialMessageObject alloc]init];
            OdinShareVideoObject *videoObj=[[OdinShareVideoObject alloc]init];
            
            videoObj.title=self.inputVc.titleTextField.text;
            videoObj.descr=self.inputVc.desrcTextView.text;
            videoObj.videoUrl=[assetURL absoluteString];;
            
            obj.shareObject=videoObj;
            [self shareWithObj:obj];
        }];
    }
}

@end
