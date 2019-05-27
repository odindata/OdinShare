//
//  ShareCategoryCollectionViewCell.h
//  OdinShareDemo
//
//  Created by nathan on 2019/4/29.
//  Copyright © 2019 Odin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShareModel;
NS_ASSUME_NONNULL_BEGIN

@interface ShareCategoryCollectionViewCell : UICollectionViewCell
@property(nonatomic,strong)UIButton *btn;
@property(nonatomic,strong)ShareModel *model;
@end

NS_ASSUME_NONNULL_END
