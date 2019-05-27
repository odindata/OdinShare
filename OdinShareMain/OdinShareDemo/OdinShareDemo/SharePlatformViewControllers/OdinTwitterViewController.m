//
//  OdinTwitterViewController.m
//  OdinShareDemo
//
//  Created by nathan on 2019/4/16.
//  Copyright © 2019 Odin. All rights reserved.
//

#import "OdinTwitterViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface OdinTwitterViewController ()

@end

@implementation OdinTwitterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
   
    platformType = OdinSocialPlatformTypeTwitter;
    self.title = @"Twitter";
    shareIconArray = @[@"textIcon",@"textAndImageIcon",@"webURLIcon",@"videoIcon",@"videoIcon"];
//    shareTypeArray = @[@"文字",@"文字+图片",@"链接",@"文字+视频",@"文字+视频 进度"];
    shareTypeArray = @[@"文字",@"文字+图片",@"链接",@"文字+视频"];
    selectorNameArray = @[@"shareText",@"shareImage",@"shareLink",@"shareVideo",@"shareVideoProgress"];
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
    webObj.thumbImage=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"COD13" ofType:@"jpg"]];
  
    webObj.descr=self.inputVc.desrcTextView.text;
    webObj.webpageUrl=self.inputVc.webPageTxtFiled.text;
    webObj.title=self.inputVc.textField.text;
    
    obj.shareObject=webObj;
    [self shareWithObj:obj];
}

- (void)shareVideo
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"cat" ofType:@"mp4"];
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"COD13" ofType:@"jpg"];
    
    if ([self.inputVc.medilVideoUrl absoluteString].length>0) {
        //分享本地视频 支持相册取  通过UIPickerVc
        OdinSocialMessageObject *obj=[[OdinSocialMessageObject alloc]init];
        obj.text=self.inputVc.textField.text;
        OdinShareVideoObject *videoObj=[[OdinShareVideoObject alloc]init];
//        videoObj.thumbImage=[UIImage imageWithContentsOfFile:path1];
        
        videoObj.title=self.inputVc.titleTextField.text;
        videoObj.descr=self.inputVc.desrcTextView.text;
        videoObj.videoUrl=[self.inputVc.medilVideoUrl absoluteString];
        NSURL *url=[NSURL URLWithString:videoObj.videoUrl];
        obj.shareObject=videoObj;
        [self shareWithObj:obj];
    }else{
        //         通过data分享
        OdinSocialMessageObject *obj=[[OdinSocialMessageObject alloc]init];
        OdinShareVideoObject *videoObj=[[OdinShareVideoObject alloc]init];
        videoObj.thumbImage=[UIImage imageWithContentsOfFile:path1];
        videoObj.title=self.inputVc.titleTextField.text;
        videoObj.descr=self.inputVc.desrcTextView.text;
        videoObj.videoUrl=path;
        obj.shareObject=videoObj;
        
        [self shareWithObj:obj];
    }

    

    

}

- (void)shareVideoProgress
{
    
}
@end
