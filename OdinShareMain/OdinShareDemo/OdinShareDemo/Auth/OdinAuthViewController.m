//
//  OdinAuthViewController.m
//  OdinShareDemo
//
//  Created by nathan on 2019/4/11.
//  Copyright © 2019 Odin. All rights reserved.
//

#import "OdinAuthViewController.h"
#import "OdinFColor.h"
#import "UIImage+KaImage.h"
#import "OdinUserInfoShowViewController.h"
#import "AppDelegate.h"
#import <MBProgressHUD.h>

@interface OdinAuthViewController (){
    IBOutlet UITableView *myTableView;
    NSArray *_platforemArray;
    NSArray *_overseasPlatforemArray;
    NSBundle *_uiBundle;
    NSArray *_titleArray;
    NSIndexPath *_selectIndexPath;
    NSMutableDictionary *_platforemUserInfos;
    BOOL _isAuth;
}

@property(nonatomic,strong) UIWindow *carriarWindow;
@end

@implementation OdinAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _platforemArray = @[
                        @(OdinSocialPlatformSubTypeQQFriend),
                        @(OdinSocialPlatformSubTypeWechatSession),
                        @(SSDKPlatformTypeSinaWeibo),
                        ];
    _overseasPlatforemArray = @[
                                @(OdinSocialPlatformTypeFacebook),
                                @(OdinSocialPlatformTypeTwitter)
//                                @(SSDKPlatformTypeInstagram),
                                ];
    _titleArray = @[@"  国内平台",@"  海外平台"];
//    _titleArray = @[@"  国内平台"];
    _platforemUserInfos = [[NSMutableDictionary alloc] init];
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"ShareSDKUI" ofType:@"bundle"];
    _uiBundle = [NSBundle bundleWithPath:bundlePath];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(infoUPload) name:@"AuthInfoUPData" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)reload
{
    [self->mobTableView reloadData];
}

- (void)applicationDidBecomeActive:(NSNotification *)note{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)infoUPload
{
    [myTableView reloadData];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return _platforemArray.count;
    }
    else if(section == 1)
    {
        return _overseasPlatforemArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseCell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseCell"];
    }
    
    id obj = nil;
    switch (indexPath.section) {
        case 0:
            obj = _platforemArray[indexPath.row];
            break;
        case 1:
            obj = _overseasPlatforemArray[indexPath.row];
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
        if(platformType == SSDKPlatformSubTypeWechatSession)
        {
            cell.textLabel.text = NSLocalizedStringWithDefaultValue(@"ShareType_997", @"ShareSDKUI_Localizable", _uiBundle, @"ShareType_997", nil);
        }
        else if(platformType == SSDKPlatformSubTypeYiXinSession)
        {
            cell.textLabel.text = NSLocalizedStringWithDefaultValue(@"ShareType_994", @"ShareSDKUI_Localizable", _uiBundle, @"ShareType_994", nil);
        }
        else if(platformType == SSDKPlatformSubTypeKakaoTalk)
        {
            cell.textLabel.text = @"Kakao";
        }
        else
        {
            NSString *platformTypeName = [NSString stringWithFormat:@"ShareType_%zi",platformType];
            cell.textLabel.text = NSLocalizedStringWithDefaultValue(platformTypeName, @"ShareSDKUI_Localizable", _uiBundle, platformTypeName, nil);
        }
        //icon
        NSString *iconImageName = [NSString stringWithFormat:@"Icon_simple/sns_icon_%ld.png",(long)platformType];
        UIImage *icon = [UIImage imageWithContentsOfFile:[_uiBundle pathForResource:(iconImageName) ofType:nil]];
        cell.imageView.image = icon;
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        //检测平台是否已授权
        BOOL hasAuthed = [[OdinSocialManager defaultManager] isAuth:platformType];// NO;//[ShareSDK hasAuthorized:platformType];
        if(hasAuthed)
        {
//            cell.accessoryView = [self getInfoView:platformType];
            NSInteger tag = indexPath.section * 1000 + indexPath.row;
            UIButton *btn=[self getAuthButton:tag];
            [btn setTitle:@"取消授权" forState:0];
            cell.accessoryView = btn;
        }
        else
        {
            NSInteger tag = indexPath.section * 1000 + indexPath.row;
            cell.accessoryView = [self getAuthButton:tag];
        }
    }
    return cell;
}

- (UIButton *)getAuthButton:(NSInteger)tag
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitle:@"授权" forState:UIControlStateNormal];
    [button setTitleColor:[OdinFColor colorWithRGB:0xff7800] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage getImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [button.layer setMasksToBounds:YES];
    [button.layer setCornerRadius:15]; //设置矩形四个圆角半径
    [button.layer setBorderWidth:1.0];
    button.layer.borderColor = [OdinFColor colorWithRGB:0xff7800].CGColor;
    button.tag = tag;
    [button addTarget:self action:@selector(authAct:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

//获取平台授权的当前用户信息
- (UIView *)getInfoView:(SSDKPlatformType)platformType
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [view addSubview:imageView];
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, 55, 40)];
    textLabel.textColor = [OdinFColor colorWithRGB:0xa7abb2];
    textLabel.font = [UIFont systemFontOfSize:14];
    [view addSubview:textLabel];
    NSString *key = [NSString stringWithFormat:@"%@",@(platformType)];
    if([_platforemUserInfos valueForKey:key])
    {
//        SSDKUser *user = [_platforemUserInfos valueForKey:key];
//        NSLog(@"%@",user.dictionaryValue);
//        textLabel.text = user.nickname;
//        [[MOBFImageGetter sharedInstance] getImageWithURL:[NSURL URLWithString:user.icon]
//                                                   result:^(UIImage *image, NSError *error) {
//                                                       NSLog(@"result");
//                                                       if(error == nil)
//                                                       {
//                                                           imageView.image = image;
//                                                       }
//                                                   }];
    }
    else
    {
#pragma mark - 获取平台授权用户信息
        //获取平台授权用户信息
//        [ShareSDK getUserInfo:platformType
//               onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
//
//                   if(state == SSDKResponseStateSuccess)
//                   {
//                       [_platforemUserInfos setObject:user forKey:key];
//
//                       textLabel.text = user.nickname;
//                       [[MOBFImageGetter sharedInstance] getImageWithURL:[NSURL URLWithString:user.icon]
//                                                                  result:^(UIImage *image, NSError *error) {
//                                                                      NSLog(@"result");
//                                                                      if(error == nil)
//                                                                      {
//                                                                          imageView.image = image;
//                                                                      }
//                                                                  }];
//                   }
//               }];
    }
    return view;
}

- (void)authAct:(UIButton *)button
{
    NSIndexPath *indexPath = nil;
    OdinSocialPlatformType platformType = 0;
    if(button.tag >= 1000)//国外
    {
        platformType = [_overseasPlatforemArray[button.tag-1000] integerValue];
        indexPath = [NSIndexPath indexPathForRow:button.tag-1000 inSection:1];
    }
    else//国内
    {
        platformType = [_platforemArray[button.tag] integerValue];
        indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
    }
#pragma mark - 调用授权
    NSDictionary *setting = nil;
    
    // QQ 新增了二维码授权,SSDKAuthSettingQQAuthTypeNormal(默认授权)、SSDKAuthSettingQQAuthTypeQR(二维码授权)未安装QQ客户端时才有效果
    if (platformType == SSDKPlatformTypeQQ || platformType == SSDKPlatformSubTypeQQFriend || platformType == SSDKPlatformSubTypeQZone) {
        //setting = @{SSDKAuthSettingKeyQQAuthType:@(SSDKAuthSettingQQAuthTypeQR)};
    }
    
    
    if ([button.titleLabel.text isEqualToString:@"授权"]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[OdinSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:self completion:^(id result, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                 [self->mobTableView reloadData];
                if (error==nil) {
                    
                }else{
                    //showError
                    [self alertWithError:error];
                }
                self->_isAuth=NO;
            });
        }];
    }else{
        //取消授权
        [[OdinSocialManager defaultManager] cancelAuthWithPlatform:platformType completion:^(id result, NSError *error) {
            [self->mobTableView reloadData];
        }];
    }
}

- (void)showUserInfo:(OdinSocialUserInfoResponse *)userResp
{
    
    OdinUserInfoShowViewController * userInfoShowViewController = [[OdinUserInfoShowViewController alloc]init];
    userInfoShowViewController.view.frame = [UIScreen mainScreen].bounds;
    self.carriarWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.carriarWindow.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    self.carriarWindow.windowLevel = [UIApplication sharedApplication].keyWindow.windowLevel + 1;
    self.carriarWindow.layer.masksToBounds = YES;
    self.carriarWindow.hidden=NO;
    self.carriarWindow.rootViewController = userInfoShowViewController;
    [userInfoShowViewController setUserResp:userResp];
    __weak typeof(self) weakSelf=self;
    userInfoShowViewController.colseBlock = ^{
        weakSelf.carriarWindow=nil;
    };
}

#pragma mark - Table view delegate


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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SSDKPlatformType platformType = 0;
    _selectIndexPath = indexPath;
    if(indexPath.section == 1)//国外
    {
        platformType = [_overseasPlatforemArray[indexPath.row] integerValue];
    }
    else//国内
    {
        platformType = [_platforemArray[indexPath.row] integerValue];
    }
    //检测平台是否已授权
//    if([ShareSDK hasAuthorized:platformType])
//    {
//        NSString *name;
//        if(platformType == SSDKPlatformSubTypeWechatSession)
//        {
//            name = NSLocalizedStringWithDefaultValue(@"ShareType_997", @"ShareSDKUI_Localizable", _uiBundle, @"ShareType_997", nil);
//        }
//        else if(platformType == SSDKPlatformSubTypeYiXinSession)
//        {
//            name = NSLocalizedStringWithDefaultValue(@"ShareType_994", @"ShareSDKUI_Localizable", _uiBundle, @"ShareType_994", nil);
//        }
//        else if(platformType == SSDKPlatformSubTypeKakaoTalk)
//        {
//            name = @"Kakao";
//        }
//        else
//        {
//            NSString *platformTypeName = [NSString stringWithFormat:@"ShareType_%zi",platformType];
//            name = NSLocalizedStringWithDefaultValue(platformTypeName, @"ShareSDKUI_Localizable", _uiBundle, platformTypeName, nil);
//        }
//        NSString *info = [NSString stringWithFormat:@"是否取消 '%@' 的授权",name];
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:info
//                                                            message:nil
//                                                           delegate:self
//                                                  cancelButtonTitle:@"暂不"
//                                                  otherButtonTitles:@"确认取消",nil];
//        alertView.tag = 10002;
//        [alertView show];
//    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 10002)
    {
        if(buttonIndex == 1)
        {
            if(_selectIndexPath != nil)
            {
                SSDKPlatformType platformType = 0;
                if(_selectIndexPath.section == 1)//国外
                {
                    platformType = [_overseasPlatforemArray[_selectIndexPath.row] integerValue];
                }
                else//国内
                {
                    platformType = [_platforemArray[_selectIndexPath.row] integerValue];
                }
                //取消平台授权
//                [ShareSDK cancelAuthorize:platformType result:^(NSError *error) {
//
//                    NSString *key = [NSString stringWithFormat:@"%@",@(platformType)];
//                    [_platforemUserInfos removeObjectForKey:key];
//                    [myTableView reloadRowsAtIndexPaths:@[_selectIndexPath] withRowAnimation:UITableViewRowAnimationNone];
//                }];
            }
        }
    }
}

@end
