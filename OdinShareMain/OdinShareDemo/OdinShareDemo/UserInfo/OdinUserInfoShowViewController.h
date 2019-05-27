//
//  OdinUserInfoShowViewController.h
//  OdinShareDemo
//
//  Created by nathan on 2019/4/11.
//  Copyright © 2019 Odin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OdinSocialUserInfoResponse;
NS_ASSUME_NONNULL_BEGIN

@interface OdinUserInfoShowViewController : UIViewController

- (void)setUserResp:(id )userResp;
@property(nonatomic,strong) void (^colseBlock)(void);
@end

NS_ASSUME_NONNULL_END
