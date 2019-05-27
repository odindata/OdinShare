//
//  ViewController.m
//  OdinShareDemo
//
//  Created by nathan on 2019/3/23.
//  Copyright © 2019 Odin. All rights reserved.
//

#import "ViewController.h"
#import <OdinShareSDK/OdinShareSDK.h>
#import "OdinShareViewController.h"
#import "OdinAuthViewController.h"
#import "OdinUserInfoViewController.h"
#import "OdinFColor.h"
#import "OdinInputViewController.h"
//#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>{
    IBOutlet UIView *topView;
    IBOutlet UIButton *shareButton;
    IBOutlet UIButton *authButton;
    IBOutlet UIButton *userInfoButton;
    NSArray *buttonArray;
    CALayer *lineLayer;
    
    NSInteger selectedIndex;
    IBOutlet UICollectionView *myCollectionView;
    
    
    OdinInputViewController *inputViewController;
    
    OdinShareViewController *shareViewController;
    OdinAuthViewController *authViewController;
    OdinUserInfoViewController *userInfoViewController;
    NSArray *viewControllerArray;
    BOOL isFirst;
}

@end

@implementation ViewController

static NSString * const cellReuseIdentifier = @"cellReuseIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    buttonArray = @[shareButton,authButton,userInfoButton];
    [myCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellReuseIdentifier];
   
    inputViewController=[[OdinInputViewController alloc]init];
    shareViewController =[[OdinShareViewController alloc]init];
    authViewController = [[OdinAuthViewController alloc]init];
    userInfoViewController = [[OdinUserInfoViewController alloc]init];
    viewControllerArray = @[shareViewController,authViewController,userInfoViewController];
    isFirst = YES;
}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(isFirst)
    {
        isFirst = NO;
        [self showLineWithButton:shareButton];
        shareViewController.view.frame = myCollectionView.bounds;
        authViewController.view.frame = myCollectionView.bounds;
        userInfoViewController.view.frame = myCollectionView.bounds;
    }
}


- (void)showLineWithButton:(UIButton *)button
{
    selectedIndex = button.tag;
    if(lineLayer == nil)
    {
        lineLayer = [[CALayer alloc] init];
        lineLayer.backgroundColor = [OdinFColor colorWithRGB:0xff6800].CGColor;
        [topView.layer addSublayer:lineLayer];
    }
    CGFloat width = button.titleLabel.text.length * button.titleLabel.font.pointSize;
    CGFloat y = CGRectGetHeight(topView.frame)-2;
    CGFloat x = 0;
    switch (button.tag) {
        case 0:
            x = CGRectGetWidth(button.frame) - width;
            break;
        case 1:
            x = CGRectGetMinX(button.frame) + (CGRectGetWidth(button.frame) - width)/2;
            break;
        default:
            x = CGRectGetMinX(button.frame);
            break;
    }
    lineLayer.frame = CGRectMake(x, y, width, 2);
    
}

- (IBAction)buttonAct:(UIButton *)sender
{
    if(selectedIndex != sender.tag)
    {
        if(sender.tag == 1)
        {
            [authViewController reload];
        }
        else if(sender.tag == 2)
        {
            [userInfoViewController reload];
        }
        UIButton *selecetedButton = buttonArray[selectedIndex];
        [selecetedButton setSelected:NO];
        [UIView animateWithDuration:0.25 animations:^{
            [self showLineWithButton:sender];
            [self->myCollectionView setContentOffset:CGPointMake(CGRectGetWidth(self->myCollectionView.bounds) * sender.tag, 0) animated:YES];
            [sender setSelected:YES];
        }];
    }
}

#pragma mark UICollectionViewDelegate UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
   
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  
    return viewControllerArray.count;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return collectionView.frame.size;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    UIViewController *viewController = viewControllerArray[indexPath.row];
    [cell addSubview:viewController.view];
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger page=scrollView.contentOffset.x/CGRectGetWidth(scrollView.frame);
    UIButton *button = buttonArray[page];
    [authViewController reload];
    [userInfoViewController reload];
    [self buttonAct:button];
}

@end
