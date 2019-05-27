//
//  OdinSocialMessageObject.m
//  OdinShareSDK
//
//  Created by nathan on 2019/3/23.
//  Copyright © 2019 Odin. All rights reserved.
//

#import "OdinSocialMessageObject.h"

@implementation OdinSocialMessageObject
+ (OdinSocialMessageObject *)messageObject{
     return [[self alloc]init];
}

+ (OdinSocialMessageObject *)messageObjectWithMediaObject:(id)mediaObject{
    OdinSocialMessageObject *messObj=[[self alloc]init];
    messObj.shareObject=mediaObject;
    return messObj;
}
@end


@implementation OdinShareObject
+ (id)shareObjectWithTitle:(NSString *)title
                     descr:(NSString *)descr
                 thumImage:(id)thumImage{
    return self;
}


+ (void)odin_imageDataWithImage:(id)image withCompletion:(void (^)(NSData *imageData,NSError* error))completion{
    
}
@end


@implementation OdinShareImageObject
+ (OdinShareImageObject *)shareObjectWithTitle:(NSString *)title
                                         descr:(NSString *)descr
                                     thumImage:(id)thumImage{
    OdinShareImageObject *imgObj=[[self alloc]init];
    imgObj.title=title;
    imgObj.descr=descr;
    imgObj.thumbImage=thumImage;
    return imgObj;
}
@end

@implementation OdinShareMusicObject
+ (OdinShareMusicObject *)shareObjectWithTitle:(NSString *)title
                                         descr:(NSString *)descr
                                     thumImage:(id)thumImage{
    OdinShareMusicObject *musicObj=[[self alloc]init];
    musicObj.title=title;
    musicObj.descr=descr;
    musicObj.thumbImage=thumImage;
    
    return musicObj;
}
@end

@implementation OdinShareVideoObject

+ (OdinShareVideoObject *)shareObjectWithTitle:(NSString *)title
                                         descr:(NSString *)descr
                                     thumImage:(id)thumImage{
    
    OdinShareVideoObject *videoObj=[[self alloc]init];
    videoObj.title=title;
    videoObj.descr=descr;
    videoObj.thumbImage=thumImage;
    
     return videoObj;
}

@end

@implementation OdinShareWebpageObject

+ (OdinShareWebpageObject *)shareObjectWithTitle:(NSString *)title
                                           descr:(NSString *)descr
                                       thumImage:(id)thumImage{
    OdinShareWebpageObject *webObj=[[self alloc]init];
    webObj.title=title;
    webObj.descr=descr;
    webObj.thumbImage=thumImage;
    
    return webObj;
}

@end

@implementation OdinShareEmotionObject

+ (OdinShareEmotionObject *)shareObjectWithTitle:(NSString *)title
                                           descr:(NSString *)descr
                                       thumImage:(id)thumImage{
    OdinShareEmotionObject *videoObj=[[self alloc]init];
    videoObj.title=title;
    videoObj.descr=descr;
    videoObj.thumbImage=thumImage;
    
    return videoObj;
}

@end


@implementation OdinShareMiniProgramObject
+ (OdinShareMiniProgramObject *)shareObjectWithTitle:(NSString *)title
                                               descr:(NSString *)descr
                                           thumImage:(id)thumImage{
    OdinShareMiniProgramObject *miniObj=[[self alloc]init];
    miniObj.title=title;
    miniObj.descr=descr;
    miniObj.thumbImage=thumImage;
    
    return miniObj;
}
@end

@implementation OdinShareFileObject
+ (OdinShareFileObject *)shareObjectWithTitle:(NSString *)title
                                        descr:(NSString *)descr
                                    thumImage:(id)thumImage{
    OdinShareFileObject *fileObj=[[self alloc]init];
    fileObj.title=title;
    fileObj.descr=descr;
    fileObj.thumbImage=thumImage;
    
    return fileObj;
}

@end
