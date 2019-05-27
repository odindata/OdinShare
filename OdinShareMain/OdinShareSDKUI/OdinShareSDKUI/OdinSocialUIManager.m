//
//  OdinSocialUIManager.m
//  OdinShareSDKUI
//
//  Created by nathan on 2019/4/22.
//  Copyright © 2019 Odin. All rights reserved.
//

#import "OdinSocialUIManager.h"
#import "OdinUIShareSheetConfiguration.h"
#import "OdinUIShareSheetViewController.h"
#import "OdinUIPlatformItem.h"
#import <OdinShareSDK/OdinSocialPlatformConfig.h>

@interface OdinSocialUIManager()<OdinUIShareSheetViewControllerDelegate>
@property(nonatomic,strong) UIWindow *carriarWindow ;
@property(nonatomic,copy) OdinSocialShareCompletionHandler completionHandler;
@end


static OdinSocialUIManager *instance;

@implementation OdinSocialUIManager

+ (id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

+ (instancetype)shareInstance
{
    if (instance == nil) {
        instance = [[OdinSocialUIManager alloc] init];
    }
    return instance;
}

- (id)showShareActionSheet:(NSArray *)items
               shareObject:(OdinSocialMessageObject *)shareObj
        sheetConfiguration:(OdinUIShareSheetConfiguration *)configuration
                 currentViewController:(id)currentViewController CompletionHandler:(OdinSocialShareCompletionHandler)completionHandler{
    
    self.completionHandler=completionHandler;
    NSMutableArray *plateformItem=[NSMutableArray array];
    for (NSInteger i=0; i<items.count; i++  ) {
        NSNumber *typeNum=items[i];
        [plateformItem addObject:[OdinUIPlatformItem itemWithPlatformType:typeNum.integerValue]];
    }

    
    OdinUIShareSheetViewController *vc=[[OdinUIShareSheetViewController alloc]init];
    vc.currentVC=currentViewController;
    vc.delegate=self;
    vc.shareObject=shareObj;
    vc.platforms=plateformItem;
    vc.configuration=configuration;
    vc.view.frame = [UIScreen mainScreen].bounds;

    self.carriarWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.carriarWindow.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    self.carriarWindow.windowLevel = [UIApplication sharedApplication].keyWindow.windowLevel + 1;
    self.carriarWindow.layer.masksToBounds = YES;
    self.carriarWindow.hidden=NO;
    self.carriarWindow.rootViewController = vc;
    vc.window=self.carriarWindow;
    return nil;
}

- (void)shareSheet:(OdinUIShareSheetViewController *)shareSheet didCancelShareWithParams:(NSMutableDictionary *)params{
    
}

- (void)shareSheet:(OdinUIShareSheetViewController *)shareSheet didSelectPlatform:(id)platform result:(id)result error:(NSError *)error{
    if (self.completionHandler) {
        self.completionHandler(result, error);
    }
}

@end
