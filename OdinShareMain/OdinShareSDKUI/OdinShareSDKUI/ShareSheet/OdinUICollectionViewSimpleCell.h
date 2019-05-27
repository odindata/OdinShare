//
//  OdinUICollectionViewSimpleCell.h
//  OdinShareSDKUI
//
//  Created by nathan on 2019/5/9.
//  Copyright © 2019 Odin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OdinUIPlatformItem;
NS_ASSUME_NONNULL_BEGIN

@interface OdinUICollectionViewSimpleCell : UICollectionViewCell

- (void)setupWithPlatFormItem:(OdinUIPlatformItem *)platformItem titleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont;
    
@end

NS_ASSUME_NONNULL_END
