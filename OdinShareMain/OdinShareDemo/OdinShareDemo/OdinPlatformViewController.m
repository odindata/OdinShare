//
//  OdinPlatformViewController.m
//  OdinShareDemo
//
//  Created by nathan on 2019/3/27.
//  Copyright © 2019 Odin. All rights reserved.
//

#import "OdinPlatformViewController.h"
#import "AppDelegate.h"
#import "OdinInputViewController.h"

@interface OdinPlatformViewController (){
    NSIndexPath *selectIndexPath;
    BOOL _isShare;
}

@property(nonatomic,strong) UIWindow *carriarWindow;
@end

@implementation OdinPlatformViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (instancetype)init
{
    self = [self initWithNibName:@"OdinPlatformViewController" bundle:nil];
    if (self) {
        authTypeArray = @[];
        shareTypeArray = @[];
        selectorNameArray = @[];
        authSelectorNameArray = @[];
        otherTypeArray = @[];
        otherSelectorNameArray = @[];
    }
    return self;
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


- (void)showInput:(void (^)(OdinInputViewController * inputVc))compeleteBlock{
    OdinInputViewController * inputVc = [[OdinInputViewController alloc]init];
    inputVc.view.frame = [UIScreen mainScreen].bounds;
    self.carriarWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.carriarWindow.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    self.carriarWindow.windowLevel = [UIApplication sharedApplication].keyWindow.windowLevel + 1;
    self.carriarWindow.layer.masksToBounds = YES;
    self.carriarWindow.hidden=NO;
    self.carriarWindow.rootViewController = inputVc;
    __weak typeof(self) weakSelf=self;
    inputVc.confrimBlock = ^{
        weakSelf.carriarWindow=nil;
        if (compeleteBlock) {
            compeleteBlock(inputVc);
        }
    };
    inputVc.cancelBlock = ^{
        self.carriarWindow=nil;
    };
}

- (void)shareWithObj:(OdinSocialMessageObject *)obj{
    [[OdinSocialManager defaultManager] shareToPlatform:platformType messageObject:obj currentViewController:self completion:^(id result, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self alertWithError:error];
        });
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            return authTypeArray.count;
        }
        case 1:
        {
            return shareTypeArray.count;
        }
        case 2:
        {
            return otherTypeArray.count;
        }
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"reuseCell"];
    }
    switch (indexPath.section)
    {
        case 0:
        {
//            if([ShareSDK hasAuthorized:platformType])
//            {
//                cell.detailTextLabel.text = @"已授权";
//                cell.detailTextLabel.textColor = [UIColor blueColor];
//            }
//            else
//            {
//                cell.detailTextLabel.text = @"未授权";
//                cell.detailTextLabel.textColor = [UIColor grayColor];
//            }
            cell.textLabel.text = authTypeArray[indexPath.row];
            break;
        }
        case 1:
        {
            cell.textLabel.text = shareTypeArray[indexPath.row];
            cell.detailTextLabel.text = @"";
            NSString *imageName = shareIconArray[indexPath.row];
            cell.imageView.image = [UIImage imageNamed:imageName];
            if(!isTest)
            {
                cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shareIcon"]];
            }
            break;
        }
        case 2:
            cell.textLabel.text = otherTypeArray[indexPath.row];
            cell.detailTextLabel.text = @"";
            break;
        default:
            cell.textLabel.text = @"";
            cell.detailTextLabel.text = @"";
            break;
    }
    return cell;
}

- (void)shareWithParameters:(NSMutableDictionary *)parameters
{
    //    if(_isShare)
    //    {
    //        return;
    //    }
    //    _isShare = YES;
    if(parameters.count == 0){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"请先设置分享参数"
                                                           delegate:nil
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
//    [ShareSDK share:platformType
//         parameters:parameters
//     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
//         if(state == SSDKResponseStateUpload){
//             return ;
//         }
//         NSString *titel = @"";
//         NSString *typeStr = @"";
//         UIColor *typeColor = [UIColor grayColor];
//         switch (state) {
//             case SSDKResponseStateSuccess:
//             {
//                 NSLog(@"分享成功");
//                 _isShare = NO;
//                 titel = @"分享成功";
//                 typeStr = @"成功";
//                 typeColor = [UIColor blueColor];
//                 break;
//             }
//             case SSDKResponseStateFail:
//             {
//                 _isShare = NO;
//                 NSLog(@"---------------->share error :%@",error);
//                 titel = @"分享失败";
//                 typeStr = [NSString stringWithFormat:@"%@",error];
//                 typeColor = [UIColor redColor];
//                 break;
//             }
//             case SSDKResponseStateCancel:
//             {
//                 _isShare = NO;
//                 titel = @"分享已取消";
//                 typeStr = @"取消";
//                 break;
//             }
//             default:
//                 break;
//         }
//         if(isTest)
//         {
//             [mobTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
//             if(selectIndexPath != nil)
//             {
//                 UITableViewCell *cell = [mobTableView cellForRowAtIndexPath:selectIndexPath];
//                 cell.detailTextLabel.text = titel;
//                 cell.detailTextLabel.textColor = typeColor;
//                 selectIndexPath = nil;
//             }
//         }
//         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:titel
//                                                             message:typeStr
//                                                            delegate:nil
//                                                   cancelButtonTitle:@"确定"
//                                                   otherButtonTitles:nil];
//         [alertView show];
//     }];
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section)
    {
        case 0:
        {
            if(indexPath.row < authSelectorNameArray.count)
            {
//                if([ShareSDK hasAuthorized:platformType])
//                {
//                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否取消授权"
//                                                                        message:nil
//                                                                       delegate:self
//                                                              cancelButtonTitle:@"暂不"
//                                                              otherButtonTitles:@"确认",nil];
//                    alertView.tag = 1000;
//                    [alertView show];
//                }
//                else
//                {
//                    NSString *selectorName = authSelectorNameArray[indexPath.row];
//                    [self funcWithSelectorName:selectorName];
//                }
            }
            break;
        }
        case 1:
        {
            if(indexPath.row < selectorNameArray.count)
            {
                selectIndexPath = indexPath;
                NSString *selectorName = selectorNameArray[indexPath.row];
                [self funcWithSelectorName:selectorName];
            }
            break;
        }
        case 2:
        {
            if(indexPath.row < otherSelectorNameArray.count)
            {
                NSString *selectorName = otherSelectorNameArray[indexPath.row];
                [self funcWithSelectorName:selectorName];
            }
            break;
        }
        default:
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1000 && buttonIndex == 1)
    {
       /* [ShareSDK cancelAuthorize:platformType result:nil];*/
        if(isTest)
        {
            [mobTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
        {
            if(authTypeArray.count > 0)
            {
                return @" ";
            }
            return nil;
        }
        case 1:
        {
            if(shareTypeArray.count > 0)
            {
                return @" ";
            }
            return nil;
        }
        case 2:
        {
            if(otherTypeArray.count > 0)
            {
                return @" ";
            }
            return nil;
        }
        default:
            return nil;
    }
}

- (void)funcWithSelectorName:(NSString *)selectorName
{
    __weak typeof(self) weakSelf=self;
    [self showInput:^(OdinInputViewController * _Nonnull inputVc) {
        weakSelf.inputVc=inputVc;
        SEL sel = NSSelectorFromString(selectorName);
        if([self respondsToSelector:sel])
        {
            IMP imp = [self methodForSelector:sel];
            void (*func)(id, SEL) = (void *)imp;
            func(self, sel);
        }
    }];
}


@end
