//
//  NSBundle+OdinShareSDKUI.m
//  Pods
//
//  Created by nathan on 2019/7/1.
//

#import "NSBundle+OdinShareSDKUI.h"
#import "OdinUIPlatformItem.h"
@implementation NSBundle (OdinShareSDKUI)
+ (instancetype)odins_uiBundle{
    static NSBundle *uiBundle = nil;
    if (uiBundle == nil) {
        uiBundle =  [NSBundle bundleWithPath:[[NSBundle bundleForClass:[OdinUIPlatformItem class]] pathForResource:@"ShareSDKUI" ofType:@"bundle"]];
    }
    return uiBundle;
}
@end
