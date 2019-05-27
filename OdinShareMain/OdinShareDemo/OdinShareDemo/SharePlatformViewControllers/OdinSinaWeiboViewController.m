//
//  OdinSinaWeiboViewController.m
//  OdinShareDemo
//
//  Created by nathan on 2019/4/2.
//  Copyright © 2019 Odin. All rights reserved.
//

#import "OdinSinaWeiboViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <MBProgressHUD.h>
@interface OdinSinaWeiboViewController ()

@end

@implementation OdinSinaWeiboViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    platformType = OdinSocialPlatformTypeSinaWeibo;
    self.title = @"新浪微博";
    shareIconArray = @[@"textIcon",@"textAndImageIcon",@"webURLIcon",@"videoIcon"];
    shareTypeArray = @[@"文字 SDK",@"文字+图片 SDK",@"链接 SDK",@"视频 SDK"];
    selectorNameArray = @[@"shareText",@"shareImages",@"shareLink",@"shareVideos"];
}


- (void)shareText
{
    OdinSocialMessageObject *obj=[[OdinSocialMessageObject alloc]init];
    obj.text=self.inputVc.textField.text;
    [self shareWithObj:obj];
}

- (void)shareImages

{

    OdinSocialMessageObject *obj=[[OdinSocialMessageObject alloc]init];
    obj.text=self.inputVc.textField.text;
    OdinShareImageObject *imgObj=[[OdinShareImageObject alloc]init];
    imgObj.shareImageArray=self.inputVc.photoImgArr;
    if (imgObj.shareImageArray.count==0) {
        NSArray *imgArr=@[[UIImage imageWithContentsOfFile:self.inputVc.photoImgLbl.text]];
        imgObj.shareImageArray=imgArr;
    }
    obj.shareObject=imgObj;
//    [self shareWithObj:obj];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[OdinSocialManager defaultManager] shareToPlatform:platformType messageObject:obj currentViewController:self completion:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self alertWithError:error];
        });
        
    }];
}
//
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
//
//
- (void)shareVideos
{
    
    if ([self.inputVc.photoVideoUrl absoluteString].length>0) {
        OdinSocialMessageObject *obj=[[OdinSocialMessageObject alloc]init];
        OdinShareVideoObject *videoObj=[[OdinShareVideoObject alloc]init];
        videoObj.title=self.inputVc.titleTextField.text;
        videoObj.descr=self.inputVc.desrcTextView.text;
        videoObj.videoUrl=[self.inputVc.medilVideoUrl absoluteString];
        
        obj.shareObject=videoObj;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[OdinSocialManager defaultManager] shareToPlatform:platformType messageObject:obj currentViewController:self completion:^(id result, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self alertWithError:error];
            });
        }];
    }else{
        
        NSString *path1 = [[NSBundle mainBundle] pathForResource:@"COD13" ofType:@"jpg"];
//        NSURL *url = [NSURL URLWithString:self.inputVc.photoVideoLbl.text];
//        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
//        __weak __typeof__ (self) weakSelf = self;
//        [assetsLibrary writeVideoAtPathToSavedPhotosAlbum:url completionBlock:^(NSURL *assetURL, NSError *error) {
//            //iPad版本QQ 暂时未支持此功能
//            OdinSocialMessageObject *obj=[[OdinSocialMessageObject alloc]init];
//            OdinShareVideoObject *videoObj=[[OdinShareVideoObject alloc]init];
//            videoObj.thumbImage=[UIImage imageWithContentsOfFile:path1];
//            videoObj.title=@"title";
//            videoObj.descr=@"视频分享";
//            videoObj.videoUrl=[assetURL absoluteString];
//            obj.shareObject=videoObj;
//            [weakSelf shareWithObj:obj];
//
//
//        }];
        NSString *videoPath=[[NSBundle mainBundle] pathForResource:@"cat" ofType:@"mp4"];
        OdinSocialMessageObject *obj=[[OdinSocialMessageObject alloc]init];
        OdinShareVideoObject *videoObj=[[OdinShareVideoObject alloc]init];
        videoObj.thumbImage=[UIImage imageWithContentsOfFile:path1];
        videoObj.title=self.inputVc.titleTextField.text;
        videoObj.descr=self.inputVc.desrcTextView.text;
        videoObj.videoUrl=videoPath;
        obj.shareObject=videoObj;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[OdinSocialManager defaultManager] shareToPlatform:platformType messageObject:obj currentViewController:self completion:^(id result, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self alertWithError:error];
            });
        }];
        
        //iPad版本QQ 暂时未支持此功能
//        OdinSocialMessageObject *obj=[[OdinSocialMessageObject alloc]init];
//        OdinShareVideoObject *videoObj=[[OdinShareVideoObject alloc]init];
//        videoObj.thumbImage=[UIImage imageWithContentsOfFile:path1];
//        videoObj.title=@"title";
//        videoObj.descr=@"视频分享";
//        videoObj.videoUrl=path1;
//        obj.shareObject=videoObj;
//        [self shareWithObj:obj];
    }
}
@end
