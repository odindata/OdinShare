//
//  OdinHook.m
//  OdinShareSDK
//
//  Created by nathan on 2019/4/23.
//  Copyright © 2019 Odin. All rights reserved.
//

#import "OdinHook.h"
#import <objc/runtime.h>

@implementation OdinHook

+ (void)hook_class:(Class)classObject fromSelector:(SEL)fromSelector toSelector:(SEL)toSelector {
    Class class = classObject;
    Method formMethod = class_getInstanceMethod(class, fromSelector);
    Method toMethod = class_getInstanceMethod(class, toSelector);
    if(class_addMethod(class, fromSelector, method_getImplementation(toMethod), method_getTypeEncoding(toMethod))) {
        class_replaceMethod(class, toSelector, method_getImplementation(formMethod), method_getTypeEncoding(formMethod));
    } else {
        method_exchangeImplementations(formMethod, toMethod);
    }
}


@end
