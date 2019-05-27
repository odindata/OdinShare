//
//  OdinInputViewController.h
//  OdinShareDemo
//
//  Created by nathan on 2019/4/26.
//  Copyright © 2019 Odin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OdinInputViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *desrcTextView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITextField *webPageTxtFiled;
@property (weak, nonatomic) IBOutlet UITextField *imgUrlTxtFiled;

@property (weak, nonatomic) IBOutlet UITextField *muiscUrlTextField;
@property (weak, nonatomic) IBOutlet UITextField *videoUrlTextField;
@property (weak, nonatomic) IBOutlet UILabel *photoImgLbl;
@property (weak, nonatomic) IBOutlet UILabel *photoVideoLbl;

@property(nonatomic,copy) UIImage *photoImg;
@property(nonatomic,strong) NSMutableArray *photoImgArr;

@property(nonatomic,strong) NSData *emotionData;
@property(nonatomic,strong) NSURL *photoVideoUrl;
@property(nonatomic,strong) NSURL *medilVideoUrl;
@property(nonatomic,strong) void (^confrimBlock)(void);
@property(nonatomic,strong) void (^cancelBlock)(void);
@end

NS_ASSUME_NONNULL_END
