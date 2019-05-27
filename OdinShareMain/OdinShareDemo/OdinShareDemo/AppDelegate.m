//
//  AppDelegate.m
//  OdinShareDemo
//
//  Created by nathan on 2019/3/23.
//  Copyright © 2019 Odin. All rights reserved.
//

#import "AppDelegate.h"
#import <MBProgressHUD.h>
#import <OdinShareSDK/OdinShareSDK.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <TwitterKit/TWTRKit.h>

//AppKey
#define OdinSinaWeiboAppKey @"568898243"
//AppSecret
#define OdinSinaWeiboAppSecret @"38a4f8204cc784f81f9f0daaf31e02e3"
//RedirectUri
#define OdinSinaWeiboRedirectUri @"http://www.sharesdk.cn"

//ConsumerKey
#define MOBSSDKTwitterConsumerKey @"viOnkeLpHBKs6KXV7MPpeGyzE"
//ConsumerSecret
#define MOBSSDKTwitterConsumerSecret @"NJEglQUy2rqZ9Io9FcAU9p17omFqbORknUpRrCDOK46aAbIiey"
//RedirectUri
#define MOBSSDKTwitterRedirectUri @"http://mob.com"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[OdinSocialManager  defaultManager] setPlaform:OdinSocialPlatformSubTypeWechatSession appKey:@"wx617c77c82218ea2c" appSecret:@"c7253e5289986cf4c4c74d1ccc185fb1" redirectURL:nil];

    
    [[OdinSocialManager  defaultManager] setPlaform:OdinSocialPlatformSubTypeQQFriend appKey:@"100371282" appSecret:@"aed9b0303e3ed1e27bae87c33761161d" redirectURL:nil];

    [[OdinSocialManager  defaultManager] setPlaform:OdinSocialPlatformTypeSinaWeibo appKey:OdinSinaWeiboAppKey appSecret:OdinSinaWeiboAppSecret redirectURL:OdinSinaWeiboRedirectUri];
    
    [[OdinSocialManager  defaultManager] setPlaform:OdinSocialPlatformTypeAliSocial appKey:@"2017062107540437" appSecret:nil redirectURL:nil];
    
     [[OdinSocialManager defaultManager] setPlaform:OdinSocialPlatformTypeFacebook appKey:@"1412473428822331"  appSecret:nil redirectURL:nil];
    
    
     [[OdinSocialManager defaultManager] setPlaform:OdinSocialPlatformTypeTwitter appKey:MOBSSDKTwitterConsumerKey  appSecret:MOBSSDKTwitterConsumerSecret redirectURL:MOBSSDKTwitterRedirectUri];
    
   
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [[OdinSocialManager  defaultManager] handleOpenURL:url];
}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    [[FBSDKApplicationDelegate sharedInstance] application:app
                                                   openURL:url
                                         sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    
    
    [[Twitter sharedInstance] application:app openURL:url options:options];
    return [[OdinSocialManager  defaultManager] handleOpenURL:url options:options];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return  [[OdinSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        [FBSDKAppEvents activateApp];

}

@end
