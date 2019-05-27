//
//  OdinUICollectionViewLayout.h
//  OdinShareSDKUI
//
//  Created by nathan on 2019/4/22.
//  Copyright © 2019 Odin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OdinUIShareSheetConfiguration.h"
NS_ASSUME_NONNULL_BEGIN

@interface OdinUICollectionViewLayout : UICollectionViewLayout

@property (assign, nonatomic) OdinUIItemAlignment alignment;
@property (assign, nonatomic) NSInteger rowCount;
@property (assign, nonatomic) NSInteger columnCount;
@property (assign, nonatomic) CGFloat horizontalSpacing;
@property (assign, nonatomic) CGFloat verticalSpacing;
@property (assign, nonatomic) CGFloat itemWidth;
@property (assign, nonatomic) CGFloat itemHeight;

@end

NS_ASSUME_NONNULL_END
