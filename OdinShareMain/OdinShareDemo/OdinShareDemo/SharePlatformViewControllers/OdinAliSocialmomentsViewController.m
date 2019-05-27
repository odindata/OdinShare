//
//  OdinAliSocialmomentsViewController.m
//  OdinShareDemo
//
//  Created by nathan on 2019/4/8.
//  Copyright © 2019 Odin. All rights reserved.
//

#import "OdinAliSocialmomentsViewController.h"

@implementation OdinAliSocialmomentsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    platformType = OdinSocialPlatformTypeAliSocialTimeline;
    self.title = @"支付宝朋友圈";
    shareIconArray = @[@"imageIcon",@"webURLIcon"];
    shareTypeArray = @[@"图片",@"链接"];
    selectorNameArray = @[@"shareImage",@"shareWebPage"];
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

    obj.text=self.inputVc.textField.text;
    OdinShareImageObject *imgObj=[[OdinShareImageObject alloc]init];
  
    id shareImg;
    if (self.inputVc.photoImg) {
        shareImg=self.inputVc.photoImg;
    }else if (self.inputVc.imgUrlTxtFiled.text.length>0){
        shareImg=self.inputVc.imgUrlTxtFiled.text;
    }else{
        shareImg=[UIImage imageWithContentsOfFile:self.inputVc.photoImgLbl.text];
    }
    imgObj.shareImage=shareImg;
    
    obj.shareObject=imgObj;
    [[OdinSocialManager defaultManager] shareToPlatform:platformType messageObject:obj currentViewController:self completion:^(id result, NSError *error) {
        [self alertWithError:error];
    }];
}

/**
 分享网址
 */
- (void)shareWebPage
{
    OdinSocialMessageObject *obj=[[OdinSocialMessageObject alloc]init];
    OdinShareWebpageObject *webObj=[[OdinShareWebpageObject alloc]init];
    webObj.thumbImage=UIImageJPEGRepresentation([UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"COD13" ofType:@"jpg"]], .5);

    
    webObj.descr=self.inputVc.desrcTextView.text;
    webObj.webpageUrl=self.inputVc.webPageTxtFiled.text;
    webObj.title=self.inputVc.titleTextField.text;
    
    
    obj.shareObject=webObj;
    [[OdinSocialManager defaultManager] shareToPlatform:platformType messageObject:obj currentViewController:self completion:^(id result, NSError *error) {
        [self alertWithError:error];
    }];
}
@end
