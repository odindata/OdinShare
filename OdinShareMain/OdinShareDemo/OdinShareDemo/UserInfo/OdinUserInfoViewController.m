//
//  OdinUserInfoViewController.m
//  OdinShareDemo
//
//  Created by nathan on 2019/4/11.
//  Copyright © 2019 Odin. All rights reserved.
//

#import "OdinUserInfoViewController.h"
#import "OdinFColor.h"
#import "UIImage+KaImage.h"
#import "OdinUserInfoShowViewController.h"
@interface OdinUserInfoViewController ()
{
    IBOutlet UITableView *myTableView;
    NSArray *_platforemArray;
    NSArray *_overseasPlatforemArray;
    NSBundle *_uiBundle;
    NSArray *_titleArray;
    OdinUserInfoViewController *userInfoShowViewController;
    BOOL _isGetUserInfo;
}
@property(nonatomic,strong) UIWindow *carriarWindow;
@end

@implementation OdinUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _platforemArray = @[
                        @(OdinSocialPlatformSubTypeQQFriend),
                        @(OdinSocialPlatformSubTypeWechatSession),
                        @(SSDKPlatformTypeSinaWeibo),
                        ];
    _overseasPlatforemArray = @[
                                @(SSDKPlatformTypeFacebook),
                                @(SSDKPlatformTypeTwitter)
//                                @(SSDKPlatformTypeInstagram)
                                ];
    _titleArray = @[@"  国内平台",@"  海外平台"];
//     _titleArray = @[@"  国内平台"];
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"ShareSDKUI" ofType:@"bundle"];
    _uiBundle = [NSBundle bundleWithPath:bundlePath];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(infoUPload) name:@"AuthInfoUPData" object:nil];
}

- (void)reload{
    [self infoUPload];
}


- (void)infoUPload
{
    [myTableView reloadData];
}

- (IBAction)buttonAct:(UIButton *)sender
{
    
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
            cell.textLabel.text = NSLocalizedStringWithDefaultValue(@"ShareType_997", @"ShareSDKUI_Localizable", _uiBundle, @"ShareType_997", nil);;
        }
        else if(platformType == SSDKPlatformSubTypeYiXinSession)
        {
            cell.textLabel.text = NSLocalizedStringWithDefaultValue(@"ShareType_994", @"ShareSDKUI_Localizable", _uiBundle, @"ShareType_994", nil);;
        }
        else if(platformType == SSDKPlatformSubTypeKakaoTalk)
        {
            cell.textLabel.text = @"Kakao";
        }
        else
        {
            NSString *platformTypeName = [NSString stringWithFormat:@"ShareType_%zi",(unsigned long)platformType];
            cell.textLabel.text = NSLocalizedStringWithDefaultValue(platformTypeName, @"ShareSDKUI_Localizable", _uiBundle, platformTypeName, nil);
        }
        //icon
        NSString *iconImageName = [NSString stringWithFormat:@"Icon_simple/sns_icon_%ld.png",(long)platformType];
        UIImage *icon = [UIImage imageWithContentsOfFile:[_uiBundle pathForResource:(iconImageName) ofType:nil]];
        cell.imageView.image = icon;
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        NSInteger tag = indexPath.section * 1000 + indexPath.row;
        if(![[OdinSocialManager defaultManager] isAuth:platformType])
        {
            cell.accessoryView = [self getUserInfoButton:tag];
        }
        else
        {
            cell.accessoryView = [self getShowInfoButton:tag];
        }
//       cell.accessoryView = [self getUserInfoButton:tag];
    }
    return cell;
}


- (UIButton *)getUserInfoButton:(NSInteger)tag
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitle:@"获取信息" forState:UIControlStateNormal];
    [button setTitleColor:[OdinFColor colorWithRGB:0xff7800] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage getImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [button.layer setMasksToBounds:YES];
    [button.layer setCornerRadius:15]; //设置矩形四个圆角半径
    [button.layer setBorderWidth:1.0];
    button.layer.borderColor = [OdinFColor colorWithRGB:0xff7800].CGColor;
    button.tag = tag;
    [button addTarget:self action:@selector(getUserInfoAct:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (UIButton *)getShowInfoButton:(NSInteger)tag
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage getImageWithColor:[OdinFColor colorWithRGB:0x00b2ff]] forState:UIControlStateNormal];
    [button.layer setMasksToBounds:YES];
    [button.layer setCornerRadius:15]; //设置矩形四个圆角半径
    [button setTitle:@"查看" forState:UIControlStateNormal];
    button.tag = tag;
    [button addTarget:self action:@selector(getUserInfoAct:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}


- (void)getUserInfoAct:(UIButton *)button
{
    NSIndexPath *indexPath = nil;
    OdinSocialPlatformType platformType = 0;
    if(button.tag >= 1000)//国外
    {
        platformType = [_overseasPlatforemArray[button.tag - 1000] integerValue];
        indexPath = [NSIndexPath indexPathForRow:button.tag-1000 inSection:1];
    }
    else//国内
    {
        platformType = [_platforemArray[button.tag] integerValue];
        indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
    }
#pragma mark - 调用获取用户授权信息
    
    if([[OdinSocialManager defaultManager] isAuth:platformType]){
        [self showUserInfo: [[OdinSocialManager defaultManager] getUserInfo:platformType]];
    }else{
        [[OdinSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:self completion:^(id result, NSError *error) {
            if (error==nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showUserInfo: result];
                    [self infoUPload];
                });
                
            }
        }];
    }
}


- (void)showUserInfo:(id)userResp
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
