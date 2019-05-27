//
//  ShareCategoryCollectionViewCell.m
//  OdinShareDemo
//
//  Created by nathan on 2019/4/29.
//  Copyright © 2019 Odin. All rights reserved.
//

#import "ShareCategoryCollectionViewCell.h"
#import "ShareModel.h"
@implementation ShareCategoryCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self==[super initWithFrame:frame]) {
        UIButton *btn=[[UIButton alloc]init];
        btn.userInteractionEnabled=NO;
        [self.contentView addSubview:btn];
         self.contentView.backgroundColor=[UIColor grayColor];
        _btn=btn;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _btn.frame=self.contentView.bounds;
}

- (void)setModel:(ShareModel *)model{
    if (model.choose) {
        self.contentView.backgroundColor=[UIColor redColor];
    }else{
        self.contentView.backgroundColor=[UIColor grayColor];
    }
    [self.btn setTitle:model.categorrText forState:0];
}

@end
