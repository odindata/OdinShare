//
//  UIApplication+Hook.m
//  OdinShareSDK
//
//  Created by nathan on 2019/4/23.
//  Copyright © 2019 Odin. All rights reserved.
//

#import "UIApplication+Hook.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "OdinHook.h"
#if __has_include(<FBSDKCoreKit/FBSDKCoreKit.h>)
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#endif

#if __has_include(<FBSDKShareKit/FBSDKShareKit.h>)
#import <FBSDKShareKit/FBSDKShareKit.h>
#endif

#if __has_include(<TwitterKit/TWTRKit.h>)
#import <TwitterKit/TWTRKit.h>
#endif



@implementation UIApplication (Hook)

+ (void)startTracker {
    SEL fromSelector = @selector(setDelegate:);
    SEL toSelector = @selector(hook_setDelegate:);
    [OdinHook hook_class:self fromSelector:fromSelector toSelector:toSelector];
}

- (void)hook_setDelegate:(id <UIApplicationDelegate>)delegate {//只监听UITableView
    if (![self isKindOfClass:[UIApplication class]]) {
        return;
    }
    [self hook_setDelegate:delegate];
    if (delegate) {
        
        Class class = [delegate class];
        //launch
        SEL originSelector = @selector(application:didFinishLaunchingWithOptions:);
        SEL swizzlSelector = NSSelectorFromString(@"hook_didFinishLaunchingWithOptions");
        BOOL didAddMethod = class_addMethod(class, swizzlSelector, (IMP)hook_didFinishLaunchingWithOptions, "v@:@@");
        if (didAddMethod) {
            Method originMethod = class_getInstanceMethod(class, swizzlSelector);
            Method swizzlMethod = class_getInstanceMethod(class, originSelector);
            method_exchangeImplementations(originMethod, swizzlMethod);
        }
        
        //openUrl
        SEL originOpenurlSelector = @selector(application:openURL:options:);
        SEL swizzlOpenurlSelector = NSSelectorFromString(@"hook_openURL");
        BOOL didAddOpenurlMethod = class_addMethod(class, swizzlOpenurlSelector, (IMP)hook_openURL, "v@:@@@");
        if (didAddOpenurlMethod) {
            Method originMethod = class_getInstanceMethod(class, swizzlOpenurlSelector);
            Method swizzlMethod = class_getInstanceMethod(class, originOpenurlSelector);
            method_exchangeImplementations(originMethod, swizzlMethod);
        }
    }
}

//App启动
void hook_didFinishLaunchingWithOptions(id self, SEL _cmd, id application,  NSDictionary *launchOptions){
    SEL selector = NSSelectorFromString(@"hook_didFinishLaunchingWithOptions");
    //Facebook的处理
#if __has_include(<FBSDKCoreKit/FBSDKCoreKit.h>)
    NSLog(@"facebook_启动完成");
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
#endif
    ((void(*)(id, SEL,id, NSDictionary *))objc_msgSend)(self, selector, application, launchOptions);

}

//openUrl
void hook_openURL(id self, SEL _cmd, id application,  NSURL *url, NSDictionary *options){
    SEL selector = NSSelectorFromString(@"hook_openURL");
    
#if __has_include(<FBSDKCoreKit/FBSDKCoreKit.h>)
     NSLog(@"fb_openurl");
    [[FBSDKApplicationDelegate sharedInstance] application:application
                                                   openURL:url
                                         sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
#endif
    
    
#if __has_include(<TwitterKit/TWTRKit.h>)
   [[Twitter sharedInstance] application:application openURL:url options:options];
    NSLog(@"twitter_openurl");
#endif
    
    ((void(*)(id, SEL,id, NSURL *, NSDictionary *))objc_msgSend)(self, selector, application, url, options);
    
}

@end
