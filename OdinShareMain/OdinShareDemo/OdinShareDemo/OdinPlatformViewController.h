//
//  OdinPlatformViewController.h
//  OdinShareDemo
//
//  Created by nathan on 2019/3/27.
//  Copyright © 2019 Odin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OdinInputViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface OdinPlatformViewController : UIViewController
{
    IBOutlet UITableView *mobTableView;
    NSArray *shareTypeArray;
    NSArray *shareIconArray;
    NSArray *selectorNameArray;
    NSArray *authTypeArray;
    NSArray *authSelectorNameArray;
    NSArray *otherTypeArray;
    NSArray *otherSelectorNameArray;
    OdinSocialPlatformType platformType;
}
@property(nonatomic,strong) OdinInputViewController * _Nonnull inputVc;
- (void)alertWithError:(NSError *)error;
- (void)shareWithObj:(OdinSocialMessageObject *)obj;
- (void)showInput:(void (^)(OdinInputViewController * inputVc))compeleteBlock;

@end

NS_ASSUME_NONNULL_END
