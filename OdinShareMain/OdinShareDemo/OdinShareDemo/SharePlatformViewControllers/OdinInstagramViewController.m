//
//  OdinInstagramViewController.m
//  OdinShareDemo
//
//  Created by nathan on 2019/4/16.
//  Copyright © 2019 Odin. All rights reserved.
//

#import "OdinInstagramViewController.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
@interface OdinInstagramViewController ()

@end

@implementation OdinInstagramViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    platformType = OdinSocialPlatformTypeInstagram;
    self.title = @"Instagram";
    shareIconArray = @[@"imageIcon",@"videoIcon"];
    shareTypeArray = @[@"图片",@"视频"];
    selectorNameArray = @[@"shareImage",@"shareVideo"];
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
    }else if (self.inputVc.imgUrlTxtFiled.text.length>0){
        shareImg=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.inputVc.imgUrlTxtFiled.text]]];
    }else{
        shareImg=[UIImage imageWithContentsOfFile:self.inputVc.photoImgLbl.text];
    }
    imgObj.shareImage=shareImg;

    obj.shareObject=imgObj;
    [[OdinSocialManager defaultManager] shareToPlatform:OdinSocialPlatformTypeInstagram messageObject:obj currentViewController:self completion:^(id result, NSError *error) {
        [self alertWithError:error];
    }];
}

- (void)shareVideo{
    //支持本地视频
    if ([self.inputVc.photoVideoUrl absoluteString].length>0) {
        OdinSocialMessageObject *obj=[[OdinSocialMessageObject alloc]init];
        OdinShareVideoObject *videoObj=[[OdinShareVideoObject alloc]init];
        
        videoObj.title=self.inputVc.titleTextField.text;
        videoObj.descr=self.inputVc.desrcTextView.text;
        videoObj.videoUrl=[self.inputVc.photoVideoUrl absoluteString];
        
        obj.shareObject=videoObj;
        [self shareWithObj:obj];
    }else{
        
        NSString *path1 = [[NSBundle mainBundle] pathForResource:@"COD13" ofType:@"jpg"];
        NSURL *url = [NSURL URLWithString:self.inputVc.photoVideoLbl.text];
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
@end
