//
//  OdinUIShareSheetConfiguration.m
//  OdinShareSDKUI
//
//  Created by nathan on 2019/4/22.
//  Copyright © 2019 Odin. All rights reserved.
//

#import "OdinUIShareSheetConfiguration.h"
#import "OdinDevice.h"
#import "OdinColor.h"

@implementation OdinUIShareSheetConfiguration

- (instancetype)init
{
    if (self = [super init])
    {
        _style = OdinUIActionSheetStyleSystem;
        _shadeColor = [OdinColor colorWithARGB:0x4c000000];
        _menuBackgroundColor = [UIColor whiteColor];
        _itemTitleColor = [UIColor darkTextColor];
        
        //iOS10以上中文大小比iOS以下大,因此字体略缩小
        if ([OdinDevice versionCompare:@"10.0"] >= 0)
        {
            _itemTitleFont = [UIFont systemFontOfSize:11.5];
        }
        else
        {
            _itemTitleFont = [UIFont systemFontOfSize:12];
        }
        
        _cancelButtonHidden = NO;
        _cancelButtonTitleColor = [OdinColor colorWithRGB:0x037bff];
        _cancelButtonBackgroundColor = [UIColor whiteColor];
        _pageIndicatorTintColor = [UIColor colorWithRed:160/255.0 green:199/255.0 blue:250/255.0 alpha:1.0];;
        _currentPageIndicatorTintColor = [UIColor colorWithRed:22/255.0 green:100/255.0 blue:255/255.0 alpha:1.0];
        _interfaceOrientationMask = UIInterfaceOrientationMaskAll;
        _statusBarStyle = UIStatusBarStyleDefault;
        _itemAlignment = OdinUIItemAlignmentLeft;
    }
    
    return self;
}

// 用户传错会崩
- (void)setInterfaceOrientationMask:(UIInterfaceOrientationMask)interfaceOrientationMask
{
    switch (interfaceOrientationMask)
    {
        case UIInterfaceOrientationMaskPortrait:
        case UIInterfaceOrientationMaskLandscapeLeft:
        case UIInterfaceOrientationMaskLandscapeRight:
        case UIInterfaceOrientationMaskPortraitUpsideDown:
        case UIInterfaceOrientationMaskLandscape:
        case UIInterfaceOrientationMaskAll:
            _interfaceOrientationMask = interfaceOrientationMask;
            return;
            
        default:
            _interfaceOrientationMask = UIInterfaceOrientationMaskAllButUpsideDown;
            return;
    }
}

@end
