//
//  OdinUserInfoShowViewController.m
//  OdinShareDemo
//
//  Created by nathan on 2019/4/11.
//  Copyright © 2019 Odin. All rights reserved.
//

#import "OdinUserInfoShowViewController.h"
#import "UIImage+KaImage.h"
#import "OdinFColor.h"
#import <MJExtension/MJExtension.h>
@interface OdinUserInfoShowViewController (){
    IBOutlet UITextView *myTextView;
    IBOutlet UIView *mainView;
    UIVisualEffectView * effectView;
    IBOutlet UIButton *copyButton;
    IBOutlet UIButton *clearButon;
    SSDKPlatformType platformType;
    IBOutlet NSLayoutConstraint *mainViewAspect;
}

@end

@implementation OdinUserInfoShowViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [mainView.layer setMasksToBounds:YES];
    [mainView.layer setCornerRadius:10];
    UIBlurEffect * blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    effectView.frame = [UIScreen mainScreen].bounds;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAct)];
    [effectView addGestureRecognizer:tapGestureRecognizer];
    [self.view insertSubview:effectView atIndex:0];
    copyButton.layer.masksToBounds = YES;
    copyButton.layer.cornerRadius = 15;
    [copyButton setBackgroundImage:[UIImage getImageWithColor:[OdinFColor colorWithRGB:0x00b2ff]] forState:UIControlStateNormal];
    clearButon.layer.masksToBounds = YES;
    clearButon.layer.cornerRadius = 15;
    [clearButon setBackgroundImage:[UIImage getImageWithColor:[UIColor lightGrayColor]] forState:UIControlStateNormal];
//    if([MOBFDevice isPad])
//    {
//        [mainView removeConstraint:mainViewAspect];
//        [mainView addConstraint:[NSLayoutConstraint constraintWithItem:mainView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:mainView attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
//    }
}

- (IBAction)copyAct:(id)sender
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = myTextView.text;
    [self tapAct];
}

- (IBAction)clearAct:(id)sender
{
//    [ShareSDK cancelAuthorize:platformType result:^(NSError *error) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"AuthInfoUPData" object:nil userInfo:nil];
//        [self tapAct];
//    }];
}

- (void)tapAct
{
    [UIView animateWithDuration:0.15 animations:^{
        self.view.alpha = 0;
    }completion:^(BOOL finished) {
//        myTextView.text = @"";
        [self.view removeFromSuperview];
    }];
    
    if (self.colseBlock) {
        self.colseBlock();
    }
}

- (void)setUserResp:(id)userResp
{
    
    dispatch_async( dispatch_get_main_queue(),^{
        myTextView.contentOffset = CGPointZero;
        myTextView.text =[userResp mj_keyValues].description;
        [UIView animateWithDuration:0.15 animations:^{
            self.view.alpha = 1;
        }];
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
