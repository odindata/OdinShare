//
//  OdinShareViewController.m
//  OdinShareDemo
//
//  Created by nathan on 2019/3/27.
//  Copyright © 2019 Odin. All rights reserved.
//

#import "OdinShareViewController.h"
#import <OdinShareSDK/OdinSocialPlatformConfig.h>
#import "AppDelegate.h"
#import "OdinUserInfoShowViewController.h"

//#import "OdinShareSheetViewController.h"
//#import "OdinUIHleper.h"
//#import "OdinShareSheetConfiguration.h"
//#import "OdinUIPlatformItem.h"
//#import "OdinUIShareSheetViewController.h"
//#import "OdinUIPlatformItem.h"
//#import "OdinUIShareSheetConfiguration.h"


#import <OdinShareSDKUI/OdinShareSDKUI.h>
#import <OdinShareSDKUI/OdinUIShareSheetConfiguration.h>
#import <OdinShareSDKUI/OdinUIShareSheetViewController.h>
#import <OdinShareSDKUI/OdinUIPlatformItem.h>

#import <OdinShareSDKUI/OdinSocialUIManager.h>
#import <MBProgressHUD.h>
static const NSInteger otherInfo = 1;

@interface OdinShareViewController (){
    IBOutlet UITableView *myTableView;
    IBOutlet UITableViewCell *topCell;
    NSArray *_platforemArray;
    NSArray *_overseasPlatforemArray;
    NSArray *_systemPlatforemArray;
    NSBundle *_uiBundle;
    NSBundle *_enBundle;
    NSArray *_titleArray;
    BOOL onShakeShare;
    BOOL isAnimate;
    //视频分享菜单
    //    MOBLoadingViewController *loadingViewController;
    //    OdinDKHttpServiceModel *httpServiceModel;
}
@property(nonatomic,strong) UIWindow *carriarWindow ;
@end
static UIWindow *myWindow = nil;
@implementation OdinShareViewController


- (instancetype)init
{
    self = [self initWithNibName:@"OdinShareViewController" bundle:nil];
    if (self) {
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    

    _platforemArray = @[
                        @(SSDKPlatformSubTypeQQFriend),
                        @(SSDKPlatformSubTypeQZone),
                        @(SSDKPlatformSubTypeWechatSession),
                        @(SSDKPlatformSubTypeWechatTimeline),
                        @(SSDKPlatformSubTypeWechatFav),
                        @(SSDKPlatformTypeSinaWeibo),
                        @(SSDKPlatformTypeAliSocial),
                        @(SSDKPlatformTypeAliSocialTimeline),
                        @(SSDKPlatformTypeDingTalk),
//                        @(OdinDKPlatformTypeTencentWeibo),
//                        @(OdinDKPlatformTypeDouBan),
//                        @(OdinDKPlatformTypeMeiPai),
//                        @(OdinDKPlatformTypeYinXiang),
//                        @(OdinDKPlatformTypeYouDaoNote),
//                        @(OdinDKPlatformTypeMingDao),
//                        @(OdinDKPlatformTypeKaixin),
//                        @(OdinDKPlatformTypeRenren),
//                        @(OdinDKPlatformSubTypeYiXinSession),
//                        @(OdinDKPlatformSubTypeYiXinTimeline),
//                        @(OdinDKPlatformSubTypeYiXinFav),
                        ];
    _overseasPlatforemArray = @[
                                @(SSDKPlatformTypeFacebook),
//                                @(OdinDKPlatformTypeFacebookMessenger),
                                @(SSDKPlatformTypeTwitter),
//                                @(OdinDKPlatformTypeWhatsApp),
//                                @(OdinDKPlatformTypeLine),
//                                @(OdinDKPlatformTypeGooglePlus),
//                                @(OdinDKPlatformSubTypeKakaoTalk),
//                                @(OdinDKPlatformSubTypeKakaoStory),
//                                @(OdinDKPlatformTypeYouTube),
                                @(SSDKPlatformTypeInstagram),
//                                @(OdinDKPlatformTypeFlickr),
//                                @(OdinDKPlatformTypeDropbox),
//                                @(OdinDKPlatformTypeEvernote),
//                                @(OdinDKPlatformTypePinterest),
//                                @(OdinDKPlatformTypePocket),
//                                @(OdinDKPlatformTypeLinkedIn),
//                                @(OdinDKPlatformTypeVKontakte),
//                                @(OdinDKPlatformTypeInstapaper),
//                                @(OdinDKPlatformTypeTumblr),
//                                @(OdinDKPlatformTypeTelegram),
//                                @(OdinDKPlatformTypeReddit),
                                ];
    _systemPlatforemArray = @[
//                              @(OdinDKPlatformTypeSMS),
//                              @(OdinDKPlatformTypeMail),
//                              @(OdinDKPlatformTypeCopy),
//                              @(OdinDKPlatformTypePrint)
                              ];
    _titleArray = @[@"  分享演示",@"  国内平台",@"  海外平台",@"  系统平台"];
    
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"ShareSDKUI" ofType:@"bundle"];
    _uiBundle = [NSBundle bundleWithPath:bundlePath];
    
    NSString *path = [_uiBundle pathForResource:@"en" ofType:@"lproj"];
    _enBundle = [NSBundle bundleWithPath:path];
    onShakeShare = NO;
    
}

- (IBAction)btnAction:(UIButton *)sender {
    if(sender.tag == 0)//分享菜单
    {
        [self shareMenu];
    }
}

- (void)alertWithError:(NSError *)error
{
    NSString *result = nil;
    if (!error) {
        result = [NSString stringWithFormat:@"Share complete"];
    }
    else{
        NSMutableString *str = [NSMutableString string];
        if (error.userInfo) {
            for (NSString *key in error.userInfo) {
                [str appendFormat:@"%@ = %@\n", key, error.userInfo[key]];
            }
        }
        if (error) {
            result = [NSString stringWithFormat:@"Share fail with error code: %d\n%@",(int)error.code, str];
        }
        else{
            result = [NSString stringWithFormat:@"Share fail"];
        }
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"share"
                                                    message:result
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"sure", @"确定")
                                          otherButtonTitles:nil];
    [alert show];
}


#pragma mark - 菜单分享
- (void)shareMenu
{
    
    NSArray *platforms =@[@(OdinSocialPlatformSubTypeQQFriend),@(OdinSocialPlatformSubTypeQZone),@(OdinSocialPlatformSubTypeWechatSession),@(OdinSocialPlatformSubTypeWechatTimeline),@(OdinSocialPlatformSubTypeWechatFav),@(OdinSocialPlatformTypeSinaWeibo),@(OdinSocialPlatformTypeAliSocial),@(OdinSocialPlatformTypeAliSocialTimeline),@(OdinSocialPlatformTypeFacebook),@(OdinSocialPlatformTypeTwitter),@(OdinSocialPlatformTypeInstagram)];

    OdinSocialMessageObject *obj=[[OdinSocialMessageObject alloc]init];
    OdinShareImageObject *imgObj=[[OdinShareImageObject alloc]init];
    
    imgObj.shareImageArray=@[[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"COD13" ofType:@"jpg"]]];
    imgObj.shareImage=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"COD13" ofType:@"jpg"]];
    obj.shareObject=imgObj;
//    obj.text=@"分享文字";
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    OdinUIShareSheetConfiguration *config=[OdinUIShareSheetConfiguration new];
//    config.style=OdinUIActionSheetStyleSimple;
    [[OdinSocialUIManager shareInstance] showShareActionSheet:platforms shareObject:obj sheetConfiguration:config currentViewController:self CompletionHandler:^(id shareResponse, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self alertWithError:error];
        });
    }];
}



#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
        case 1:
            return _platforemArray.count;
        case 2:
            return _overseasPlatforemArray.count;
        case 3:
            return _systemPlatforemArray.count;
        case 4:
            return otherInfo;
        default:
            return  0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return topCell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseCell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseCell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if(indexPath.section == 4)
    {
        cell.textLabel.text = @"其他";
        cell.imageView.image = nil;
        return cell;
    }
    id obj = nil;
    switch (indexPath.section) {
        case 1:
            obj = _platforemArray[indexPath.row];
            break;
        case 2:
            obj = _overseasPlatforemArray[indexPath.row];
            break;
        case 3:
            obj = _systemPlatforemArray[indexPath.row];
            break;
    }
    if([obj isKindOfClass:[NSString class]])
    {
        NSString *titel = obj;
        cell.textLabel.text = titel;
        cell.imageView.image = nil;
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
    }
    else if([obj isKindOfClass:[NSNumber class]])
    {
        //title
        NSInteger platformType = [obj integerValue];
        NSString *platformTypeName = [NSString stringWithFormat:@"ShareType_%zi",platformType];
        cell.textLabel.text = NSLocalizedStringWithDefaultValue(platformTypeName, @"ShareSDKUI_Localizable", _uiBundle, platformTypeName, nil);
        //icon
        NSString *iconImageName = [NSString stringWithFormat:@"Icon_simple/sns_icon_%ld.png",(long)platformType];
        UIImage *icon = [UIImage imageWithContentsOfFile:[_uiBundle pathForResource:(iconImageName) ofType:nil]];
        cell.imageView.image = icon;
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
    }
    return cell;
}


- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section < _titleArray.count)
    {
        return _titleArray[section];
    }
    return nil;
}



#pragma mark - Table view delegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return 100;
    }
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0)
    {
        return;
    }
    if(indexPath.section == 4)
    {
        Class viewControllerClass = NSClassFromString(@"MOBMoreShareViewController");
        if (viewControllerClass)
        {
            UIViewController *viewController = [[viewControllerClass alloc] init];
            AppDelegate *application = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            UINavigationController *navigationController = (UINavigationController *)application.window.rootViewController;
            [navigationController pushViewController:viewController animated:YES];
        }
        return;
    }
    id obj = nil;
    switch (indexPath.section) {
        case 1:
            obj = _platforemArray[indexPath.row];
            break;
        case 2:
            obj = _overseasPlatforemArray[indexPath.row];
            break;
        case 3:
            obj = _systemPlatforemArray[indexPath.row];
            break;
    }
    NSInteger platformType = [obj integerValue];
    NSString *platformTypeName = [NSString stringWithFormat:@"ShareType_%zi",platformType];
    NSString *platformName = NSLocalizedStringWithDefaultValue(platformTypeName, @"ShareSDKUI_Localizable", _enBundle, platformTypeName, nil);
    platformName = [platformName stringByReplacingOccurrencesOfString:@" " withString:@""];
    platformName = [platformName stringByReplacingOccurrencesOfString:@"+" withString:@""];
    NSString *viewControllerName = [NSString stringWithFormat:@"Odin%@ViewController",platformName];
    NSLog(@"move to %@",viewControllerName);
    Class viewControllerClass = NSClassFromString(viewControllerName);
    if (viewControllerClass)
    {
        UIViewController *viewController = [[viewControllerClass alloc] init];
        AppDelegate *application = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        UINavigationController *navigationController = (UINavigationController *)application.window.rootViewController;
        [navigationController pushViewController:viewController animated:YES];
    }
}

@end
