//
//  OdinUICollectionViewCell.h
//  OdinShareSDKUI
//
//  Created by nathan on 2019/4/22.
//  Copyright © 2019 Odin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OdinUIPlatformItem.h"
NS_ASSUME_NONNULL_BEGIN

@interface OdinUICollectionViewCell : UICollectionViewCell


- (void)setupWithPlatFormItem:(OdinUIPlatformItem *)platformItem titleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont;

@end

NS_ASSUME_NONNULL_END
