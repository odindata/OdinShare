//
//  UIDevice+Odin.m
//  OdinShareSDK
//
//  Created by nathan on 2019/5/9.
//  Copyright © 2019 Odin. All rights reserved.
//

#import "UIDevice+Odin.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

#import <sys/utsname.h>
#import <CoreTelephony/CTCarrier.h>

@implementation UIDevice (Odin)

    
+ (NSInteger )odin_getCarrierInfomation {
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    if (carrier == nil) {
        return 0;
    }
    if (!carrier.isoCountryCode) {
        //        AoD_Debug(@"没有SIM卡");
        return 0;;
    }else{
        NSString *carrierCode=[NSString stringWithFormat:@"%@%@",carrier.mobileCountryCode,carrier.mobileNetworkCode];
        if ([carrierCode isEqualToString:@"46005"]||[carrierCode isEqualToString:@"46003"]) {
            //电信 0
        }else if([carrierCode isEqualToString:@"46001"]||[carrierCode isEqualToString:@"46006"]){
            //联通 1
            return 3;
        }else if([carrierCode isEqualToString:@"46000"]||[carrierCode isEqualToString:@"46002"]||[carrierCode isEqualToString:@"46007"]){
            //移动 2
            return 2;
        }else{
            //其他 3
            return 3;
        }
    }
    return 0; return 0;
}
    
+ (CGSize)odin_deviceSize{
    return [UIScreen mainScreen].bounds.size;
}
    
+ (NSString*)odin_deviceModelName
    {
        struct utsname systemInfo;
        uname(&systemInfo);
        NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
        if ([deviceModel isEqualToString:@"iPhone1,1"])    return @"iPhone1";
        if ([deviceModel isEqualToString:@"iPhone1,2"])    return @"iPhone3G";
        if ([deviceModel isEqualToString:@"iPhone2,1"])    return @"iPhone3GS";
        if ([deviceModel isEqualToString:@"iPhone3,1"])    return @"iPhone4";
        if ([deviceModel isEqualToString:@"iPhone3,2"])    return @"iPhone4";
        if ([deviceModel isEqualToString:@"iPhone3,3"])    return @"iPhone4";
        if ([deviceModel isEqualToString:@"iPhone4,1"])    return @"iPhone4S";
        if ([deviceModel isEqualToString:@"iPhone5,1"])    return @"iPhone5";
        if ([deviceModel isEqualToString:@"iPhone5,2"])    return @"iPhone5";
        if ([deviceModel isEqualToString:@"iPhone5,3"])    return @"iPhone5c";
        if ([deviceModel isEqualToString:@"iPhone5,4"])    return @"iPhone5c";
        if ([deviceModel isEqualToString:@"iPhone6,1"])    return @"iPhone5s";
        if ([deviceModel isEqualToString:@"iPhone6,2"])    return @"iPhone5s";
        if ([deviceModel isEqualToString:@"iPhone7,1"])    return @"iPhone6 Plus";
        if ([deviceModel isEqualToString:@"iPhone7,2"])    return @"iPhone6";
        if ([deviceModel isEqualToString:@"iPhone8,1"])    return @"iPhone6s";
        if ([deviceModel isEqualToString:@"iPhone8,2"])    return @"iPhone6s Plus";
        if ([deviceModel isEqualToString:@"iPhone8,4"])    return @"iPhoneSE";
        if ([deviceModel isEqualToString:@"iPhone9,1"])    return @"iPhone7";
        if ([deviceModel isEqualToString:@"iPhone9,2"])    return @"iPhone7 Plus";
        if ([deviceModel isEqualToString:@"iPhone9,3"])    return @"iPhone7";
        if ([deviceModel isEqualToString:@"iPhone9,4"])    return @"iPhone7 Plus";
        if ([deviceModel isEqualToString:@"iPhone10,1"])   return @"iPhone8";
        if ([deviceModel isEqualToString:@"iPhone10,4"])   return @"iPhone8";
        if ([deviceModel isEqualToString:@"iPhone10,2"])   return @"iPhone8 Plus";
        if ([deviceModel isEqualToString:@"iPhone10,5"])   return @"iPhone8 Plus";
        if ([deviceModel isEqualToString:@"iPhone10,3"])   return @"iPhoneX";
        if ([deviceModel isEqualToString:@"iPhone10,6"])   return @"iPhoneX";
        if ([deviceModel isEqualToString:@"iPhone11,8"])   return @"iPhoneXR";
        if ([deviceModel isEqualToString:@"iPhone11,2"])   return @"iPhoneXS";
        if ([deviceModel isEqualToString:@"iPhone11,4"])   return @"iPhoneXS Max";
        if ([deviceModel isEqualToString:@"iPhone11,6"])   return @"iPhoneXS Max";
        if ([deviceModel isEqualToString:@"iPod1,1"])      return @"iPod Touch";
        if ([deviceModel isEqualToString:@"iPod2,1"])      return @"iPod Touch";
        if ([deviceModel isEqualToString:@"iPod3,1"])      return @"iPod Touch";
        if ([deviceModel isEqualToString:@"iPod4,1"])      return @"iPod Touch";
        if ([deviceModel isEqualToString:@"iPod5,1"])      return @"iPod Touch";
        if ([deviceModel isEqualToString:@"iPod7,1"])      return @"iPod Touch";
        if ([deviceModel isEqualToString:@"iPad1,1"])      return @"iPad";
        if ([deviceModel isEqualToString:@"iPad2,1"])      return @"iPad2";
        if ([deviceModel isEqualToString:@"iPad2,2"])      return @"iPad2";
        if ([deviceModel isEqualToString:@"iPad2,3"])      return @"iPad2";
        if ([deviceModel isEqualToString:@"iPad2,4"])      return @"iPad2";
        if ([deviceModel isEqualToString:@"iPad2,5"])      return @"iPad Mini";
        if ([deviceModel isEqualToString:@"iPad2,6"])      return @"iPad Mini";
        if ([deviceModel isEqualToString:@"iPad2,7"])      return @"iPad Mini";
        if ([deviceModel isEqualToString:@"iPad3,1"])      return @"iPad3";
        if ([deviceModel isEqualToString:@"iPad3,2"])      return @"iPad3";
        if ([deviceModel isEqualToString:@"iPad3,3"])      return @"iPad3";
        if ([deviceModel isEqualToString:@"iPad3,4"])      return @"iPad4";
        if ([deviceModel isEqualToString:@"iPad3,5"])      return @"iPad4";
        if ([deviceModel isEqualToString:@"iPad3,6"])      return @"iPad4";
        if ([deviceModel isEqualToString:@"iPad4,1"])      return @"iPad Air";
        if ([deviceModel isEqualToString:@"iPad4,2"])      return @"iPad Air";
        if ([deviceModel isEqualToString:@"iPad4,3"])      return @"iPad Air";
        if ([deviceModel isEqualToString:@"iPad4,4"])      return @"iPad Mini2";
        if ([deviceModel isEqualToString:@"iPad4,5"])      return @"iPad Mini2";
        if ([deviceModel isEqualToString:@"iPad4,6"])      return @"iPad Mini2";
        if ([deviceModel isEqualToString:@"iPad4,7"])      return @"iPad Mini3";
        if ([deviceModel isEqualToString:@"iPad4,8"])      return @"iPad Mini3";
        if ([deviceModel isEqualToString:@"iPad4,9"])      return @"iPad Mini3";
        if ([deviceModel isEqualToString:@"iPad5,1"])      return @"iPad Mini4";
        if ([deviceModel isEqualToString:@"iPad5,2"])      return @"iPad Mini4";
        if ([deviceModel isEqualToString:@"iPad5,3"])      return @"iPad Air2";
        if ([deviceModel isEqualToString:@"iPad5,4"])      return @"iPad Air2";
        if ([deviceModel isEqualToString:@"iPad6,3"])      return @"iPad Pro9.7";
        if ([deviceModel isEqualToString:@"iPad6,4"])      return @"iPad Pro9.7";
        if ([deviceModel isEqualToString:@"iPad6,7"])      return @"iPad Pro12.9";
        if ([deviceModel isEqualToString:@"iPad6,8"])      return @"iPad Pro12.9";
        if ([deviceModel isEqualToString:@"iPad6,11"])     return @"iPad5";
        if ([deviceModel isEqualToString:@"iPad6,12"])     return @"iPad5";
        if ([deviceModel isEqualToString:@"iPad7,1"])      return @"iPad Pro12.9 (2nd generation)";
        if ([deviceModel isEqualToString:@"iPad7,2"])      return @"iPad Pro12.9 (2nd generation)";
        if ([deviceModel isEqualToString:@"iPad7,3"])      return @"iPad Pro10.5";
        if ([deviceModel isEqualToString:@"iPad7,4"])      return @"iPad Pro10.5";
        if ([deviceModel isEqualToString:@"iPad7,5"])      return @"iPad6";
        if ([deviceModel isEqualToString:@"iPad7,6"])      return @"iPad6";
        if ([deviceModel isEqualToString:@"iPad8,1"])      return @"iPad Pro11";
        if ([deviceModel isEqualToString:@"iPad8,2"])      return @"iPad Pro11";
        if ([deviceModel isEqualToString:@"iPad8,3"])      return @"iPad Pro11";
        if ([deviceModel isEqualToString:@"iPad8,4"])      return @"iPad Pro11";
        if ([deviceModel isEqualToString:@"iPad8,5"])      return @"iPad Pro12.9 (3nd generation)";
        if ([deviceModel isEqualToString:@"iPad8,6"])      return @"iPad Pro12.9 (3nd generation)";
        if ([deviceModel isEqualToString:@"iPad8,7"])      return @"iPad Pro12.9 (3nd generation)";
        if ([deviceModel isEqualToString:@"iPad8,8"])      return @"iPad Pro12.9 (3nd generation)";
        if ([deviceModel isEqualToString:@"i386"])         return @"Simulator";
        if ([deviceModel isEqualToString:@"x86_64"])       return @"Simulator";
        return deviceModel;
    }
    
@end
