//
//  OdinUIPlatformItem.m
//  OdinShareSDKUI
//
//  Created by nathan on 2019/4/22.
//  Copyright © 2019 Odin. All rights reserved.
//

#import "OdinUIPlatformItem.h"
#import "OdinImage.h"
#import <NSBundle+OdinShareSDKUI.h>
@interface OdinUIPlatformItem ()

@property (weak, nonatomic) id target;
@property (assign, nonatomic) SEL selector;

@end


@implementation OdinUIPlatformItem


+ (instancetype)itemWithPlatformType:(OdinSocialPlatformType)platformType
{
    OdinUIPlatformItem *info = [[self alloc] init];
    
//    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"ShareSDKUI"
//                                                           ofType:@"bundle"];
//    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    
    NSString *bundlePath = [[NSBundle odins_uiBundle] pathForResource:@"ShareSDKUI"
                                                               ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    
    if (bundle==nil) {
        bundlePath=[[NSBundle mainBundle] pathForResource:@"ShareSDKUI" ofType:@"bundle"];
        bundle = [NSBundle bundleWithPath:bundlePath];
    }
    
    info.iconNormal = [OdinImage imageName:[NSString stringWithFormat:@"Icon/sns_icon_%lu.png",(unsigned long)platformType] bundle:bundle];
    info.iconSimple = [OdinImage imageName:[NSString stringWithFormat:@"Icon_simple/sns_icon_%lu.png",(unsigned long)platformType] bundle:bundle];
    
    NSString *temName = [NSString stringWithFormat:@"ShareType_%lu",(unsigned long)platformType];
    info.platformName = NSLocalizedStringWithDefaultValue(temName, @"ShareSDKUI_Localizable", bundle, temName, nil);
    info.platformType=platformType;
    return info;
}

- (void)addTarget:(id)target action:(SEL)selector
{
    _target = target;
    _selector = selector;
}

- (void)triggerClick
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [_target performSelector:_selector withObject:self];
#pragma clang diagnostic pop
}


@end
