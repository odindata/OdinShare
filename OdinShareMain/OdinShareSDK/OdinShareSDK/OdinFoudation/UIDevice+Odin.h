//
//  UIDevice+Odin.h
//  OdinShareSDK
//
//  Created by nathan on 2019/5/9.
//  Copyright © 2019 Odin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (Odin)

    /**
     获取设备运营商
     
     @return 运营商名称
     */
+ (NSInteger)odin_getCarrierInfomation;
    
    
    /**
     手机尺寸
     
     @return 手机的尺寸
     */
+ (CGSize)odin_deviceSize;
    
    
    /**
     设备类型
     
     @return 设备名称
     */
+ (NSString *)odin_deviceModelName;

    
@end

NS_ASSUME_NONNULL_END
