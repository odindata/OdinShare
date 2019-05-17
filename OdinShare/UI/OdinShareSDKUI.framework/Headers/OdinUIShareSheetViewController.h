//
//  OdinUIShareSheetViewController.h
//  OdinShareSDKUI
//
//  Created by nathan on 2019/4/22.
//  Copyright © 2019 Odin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OdinUIShareSheetConfiguration.h"
#import <OdinShareSDK/OdinSocialMessageObject.h>

@class OdinUIShareSheetViewController;
NS_ASSUME_NONNULL_BEGIN

@protocol OdinUIShareSheetViewControllerDelegate <NSObject>
- (void)shareSheet:(OdinUIShareSheetViewController *)shareSheet didSelectPlatform:(id)platform result:(id)result error:(NSError *)error;
- (void)shareSheet:(OdinUIShareSheetViewController *)shareSheet didCancelShareWithParams:(NSMutableDictionary *)params;
@end


@interface OdinUIShareSheetViewController : UIViewController

@property (weak, nonatomic) UICollectionView *platformsCollectionView;
@property (weak, nonatomic) id<OdinUIShareSheetViewControllerDelegate> delegate;
@property (strong, nonatomic) OdinUIShareSheetConfiguration *configuration;
@property (strong, nonatomic) OdinSocialMessageObject *shareObject;
@property (strong, nonatomic) NSArray *platforms;
@property (strong, nonatomic) NSMutableDictionary *params;
@property(nonatomic,strong)UIViewController *currentVC;
@property (weak, nonatomic) UIWindow *window;
@property (assign, nonatomic) UIStatusBarStyle originalStyle;

// 菜单高度 暴露给ipad显示用
- (CGFloat)menuHeight;

//总行数 暴露给ipad显示用
- (NSInteger)totalRows;

// 隐藏菜单
//- (void)hideSheetWithAnimationCompletion:(void (^)(void))completion;

@end

NS_ASSUME_NONNULL_END
