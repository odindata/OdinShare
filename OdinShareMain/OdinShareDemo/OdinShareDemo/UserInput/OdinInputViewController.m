//
//  OdinInputViewController.m
//  OdinShareDemo
//
//  Created by nathan on 2019/4/26.
//  Copyright © 2019 Odin. All rights reserved.
//

#import "OdinInputViewController.h"
#import "OdinInputViewController.h"
#import <IQKeyboardManager.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <OdinShareSDKUI/OdinSocialUIManager.h>
#import "ShareCategoryCollectionViewCell.h"
#import "ShareModel.h"


@interface OdinInputViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;
@property(nonatomic,strong)NSArray *shareCategoryData;
@property(nonatomic,strong)NSMutableDictionary  *shareContentDic;
@property(nonatomic,strong)ShareModel *chooseModel;

@end

@implementation OdinInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    [self.myCollectionView registerClass:[ShareCategoryCollectionViewCell class] forCellWithReuseIdentifier:@"ShareCategoryCollectionViewCell"];
    

    
    NSArray *arr=@[@"文字",@"图片",@"图文",@"链接",@"音频",@"视频",@"文件",@"小程序",@"表情"];
    NSMutableArray *tArr=[NSMutableArray array];
    for (NSString *text in arr) {
        ShareModel *model=[ShareModel new];
        model.categorrText=text;
        [tArr addObject:model];
    }
    self.shareCategoryData=[NSArray arrayWithArray:tArr];
    NSArray *contentArr=[NSArray arrayWithContentsOfFile:[self plistPath]];
    NSString *imgPath=[[NSBundle mainBundle] pathForResource:@"COD13" ofType:@"jpg"];
    NSString *videoPath=[[NSBundle mainBundle] pathForResource:@"cat" ofType:@"mp4"];
    if (contentArr.count==0) {
        NSArray *contentArrD=@[@{@"title":@"标题",
                                @"desc":@"描述",
                                @"text":@"分享文字",
                                @"webpage":@"http://www.baidu.com",
                                @"imgUrl":@"http://ww4.sinaimg.cn/bmiddle/005Q8xv4gw1evlkov50xuj30go0a6mz3.jpg",
                                @"musicUrl":@"http://i.y.qq.com/v8/playsong.html?hostuin=0&songid=&songmid=002x5Jje3eUkXT&_wv=1&source=qq&appshare=iphone&media_mid=002x5Jje3eUkXT",
                                 @"videoUrl":videoPath,
                                 @"imgPath":imgPath,
                                 @"videoPath":@"",
                                 @"emotionUrl":@""
                                }];
        [contentArrD writeToFile:[self plistPath] atomically:YES];
        self.shareContentDic=[NSMutableDictionary dictionaryWithDictionary:contentArrD.firstObject];
    }else{
         self.shareContentDic=[NSMutableDictionary dictionaryWithDictionary:contentArr.firstObject];
    }
    
    self.titleTextField.text=self.shareContentDic[@"title"];
    self.desrcTextView.text=self.shareContentDic[@"desc"];
    self.textField.text=self.shareContentDic[@"text"];
    self.webPageTxtFiled.text=self.shareContentDic[@"webpage"];
    self.imgUrlTxtFiled.text=self.shareContentDic[@"imgUrl"];
    self.videoUrlTextField.text=self.shareContentDic[@"videoUrl"];
    self.muiscUrlTextField.text=self.shareContentDic[@"musicUrl"];
    self.photoImgLbl.text=imgPath;
    self.photoVideoLbl.text=videoPath;
    
    
    [self.titleTextField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    [self.textField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    
    [self.imgUrlTxtFiled addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
     [self.webPageTxtFiled addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
     [self.muiscUrlTextField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
     [self.videoUrlTextField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     [@[self.shareContentDic] writeToFile:[self plistPath] atomically:YES];
}

- (NSString *)plistPath{
    NSArray *array =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //在这里,我们指定搜索的是Cache目录,所以结果只有一个,取出Cache目录
    NSString *cachePath = array[0];
    //拼接文件路径
    NSString *filePathName = [cachePath stringByAppendingPathComponent:@"eventData.plist"];
    return filePathName;
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.automaticallyAdjustsScrollViewInsets=NO;
}

- (IBAction)pickerImgAction:(UIButton *)sender {
    UIImagePickerController *pickerVc=[[UIImagePickerController alloc]init];
    pickerVc.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    pickerVc.mediaTypes = @[(NSString*)kUTTypeImage];
    pickerVc.delegate=self;
    pickerVc.allowsEditing=YES;
    [self presentViewController:pickerVc animated:YES completion:nil];
}

- (IBAction)clearPickerImgAction:(UIButton *)sender {
    self.photoImgArr=nil;
    self.photoImg=nil;
}

- (IBAction)pickerVideoAction:(UIButton *)sender {
    UIImagePickerController *pickerVc=[[UIImagePickerController alloc]init];
    pickerVc.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    pickerVc.mediaTypes = @[(NSString*)kUTTypeMovie];
    pickerVc.delegate=self;
    pickerVc.allowsEditing=YES;
    [self presentViewController:pickerVc animated:YES completion:nil];
}

- (IBAction)clearPickerVideoAction:(UIButton *)sender {
  
}

- (IBAction)videoUrlTxtField:(UITextField *)sender {
}



- (IBAction)confirmAction:(UIButton *)sender {
    if (self.confrimBlock) {
        self.confrimBlock();
    }
}


- (IBAction)cancelAction:(UIButton *)sender {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    //通过UIImagePickerControllerMediaType判断返回的是照片还是视频
    NSString* type = [info objectForKey:UIImagePickerControllerMediaType];
    NSURL *refenceUrl=[info objectForKey:UIImagePickerControllerReferenceURL];
    NSURL *imgUrl;
    if (@available(iOS 11.0, *)){
          imgUrl=[info objectForKey:UIImagePickerControllerImageURL];
    }
  
    //如果返回的type等于kUTTypeImage，代表返回的是照片,并且需要判断当前相机使用的sourcetype是拍照还是相册
    if ([type isEqualToString:(NSString*)kUTTypeImage]) {
        //获取照片的原图
        NSLog(@"");
        UIImage* original = [info objectForKey:UIImagePickerControllerOriginalImage];
        self.photoImg=original;
        [self.photoImgArr addObject:original];
//        //获取图片裁剪的图
//        UIImage* edit = [info objectForKey:UIImagePickerControllerEditedImage];
//        //获取图片裁剪后，剩下的图
//        UIImage* crop = [info objectForKey:UIImagePickerControllerCropRect];
//        //获取图片的url
//        NSURL* url = [info objectForKey:UIImagePickerControllerMediaURL];
//        //获取图片的metadata数据信息
//        NSDictionary* metadata = [info objectForKey:UIImagePickerControllerMediaMetadata];
        if ([refenceUrl.absoluteString hasSuffix:@"GIF"]) {
            self.emotionData=[NSData dataWithContentsOfURL:imgUrl];
        }
    }else{
//        UIImagePickerControllerMediaType = "public.movie";
//        UIImagePickerControllerMediaURL = "file:///private/var/mobile/Containers/Data/Application/29661179-623E-4749-8E3D-6025218C73A9/tmp/FAF7A8B2-9462-4E9C-8370-4A75C44A0BA7.MOV";
//        UIImagePickerControllerPHAsset = "<PHAsset: 0x101baed70> 3863CAA8-7246-4579-9AF2-9322EEC23243/L0/001 mediaType=2/0, sourceType=1, (480x480), creationDate=2014-06-16 16:11:52 +0000, location=0, hidden=0, favorite=0 ";
//        UIImagePickerControllerReferenceURL = "assets-library://asset/asset.mp4?id=3863CAA8-7246-4579-9AF2-9322EEC23243&ext=mp4";
        self.photoVideoUrl=[info objectForKey:UIImagePickerControllerReferenceURL];
        NSURL *mdieUrl= [info objectForKey:UIImagePickerControllerMediaURL];
        self.medilVideoUrl=mdieUrl;
    }
    //模态方式退出uiimagepickercontroller
    [picker dismissModalViewControllerAnimated:YES];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.shareCategoryData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ShareCategoryCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"ShareCategoryCollectionViewCell" forIndexPath:indexPath];
    cell.model=self.shareCategoryData[indexPath.row];
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat kScreenW= _myCollectionView.frame.size.width ;//[UIScreen mainScreen].bounds.size.width;
    return CGSizeMake((kScreenW-4*10)/3.0, 44);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.shareCategoryData setValue:[NSNumber numberWithBool:NO] forKeyPath:@"choose"];
    ShareModel *model=self.shareCategoryData[indexPath.row];
    model.choose=!model.choose;
    self.chooseModel=model;
    [_myCollectionView reloadData];
}

- (void)chooseAction:(UIButton *)sender{
//    sender.selected=!sender.isSelected;
    [_myCollectionView reloadData];
}


- (NSMutableArray *)photoImgArr{
    if (_photoImgArr==nil) {
        _photoImgArr=[NSMutableArray array];
    }
    return _photoImgArr;
}

- (OdinShareImageObject *)shareImg{
    OdinShareImageObject *imgObj=[[OdinShareImageObject alloc]init];
    imgObj.title=self.titleTextField.text;
    imgObj.descr=self.desrcTextView.text;
    
    id shareImg;
    if (self.photoImg) {
        shareImg=self.photoImg;
    }else if(self.photoImgArr){
        imgObj.shareImageArray=self.photoImgArr;
    }else if(self.imgUrlTxtFiled.text.length>0){
        shareImg=self.imgUrlTxtFiled.text;
    }
    
    imgObj.shareImage=shareImg;
    return  imgObj;
}

- (void)textViewDidChange:(UITextView *)textView{
    self.shareContentDic[@"desc"]=textView.text;
}

- (void)changedTextField:(UITextField *)sender{
    switch (sender.tag) {
        case 1:
            self.shareContentDic[@"webpage"]=sender.text;
            break;
          
        case 2:
             self.shareContentDic[@"musicUrl"]=sender.text;
            break;
        case 3:
             self.shareContentDic[@"imgUrl"]=sender.text;
            break;
        case 4:
             self.shareContentDic[@"videoUrl"]=sender.text;
            break;
        case 11:
            self.shareContentDic[@"title"]=sender.text;
            break;
        case 12:
            self.shareContentDic[@"text"]=sender.text;
            break;
        default:
            break;
    }
}
@end
