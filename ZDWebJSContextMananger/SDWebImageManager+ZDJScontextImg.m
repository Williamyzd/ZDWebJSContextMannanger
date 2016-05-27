//
//  SDWebImageManager+ZDJScontextImg.m
//  testjs
//
//  Created by william on 16/5/26.
//  Copyright © 2016年 william. All rights reserved.
//

#import "SDWebImageManager+ZDJScontextImg.h"

@implementation SDWebImageManager (ZDJScontextImg)
//根据img地址数组下载图片
- (void)loadImageWithImgArray:(NSArray*)imgArr  isPhoneNetwork:(BOOL)isPhoneNet inContext:(JSContext*)context{
    if (!imgArr.count) {
        NSLog(@"图片地址数组无数据!!!!");
        return;
    }
    for (NSString*url in imgArr) {
        [self loadImageWithUrlString:url isPhoneNetwork:isPhoneNet inContext:context];
    }
}
//根据网络类型判断是否加载
- (void)loadImageWithUrlString:(NSString*)url isPhoneNetwork:(BOOL)isPhoneNet inContext:(JSContext*)context{
    NSURL *imageUrl = [NSURL URLWithString:url];
    //如果图片已经存在,直接加载
    NSString *cacheKey = [self cacheKeyForURL:imageUrl];
    NSString *imagePaths = [self.imageCache defaultCachePathForKey:cacheKey];
     NSLog(@"imagePaths === %@",imagePaths);
      NSURL *localurl = [NSURL fileURLWithPath:imagePaths];
    
    //对jsvalue进行托管,防止内存泄漏
    JSManagedValue *imgValue = [[JSManagedValue alloc]initWithValue: [context globalObject]];
    if ([self diskImageExistsForURL:imageUrl]) {
       
        [imgValue.value invokeMethod:@"changeImage" withArguments:@[url,localurl.absoluteString]];
        /*!
         *  如果图片不存爱,进行下载
         */
    }else {
        //为手机网络
        if (isPhoneNet) {
            context[@"addClickBlock"] = ^(NSString*imgId,NSString*url){
                NSLog(@"手机网络需要下载!");
                 [self loadImageWithUrlString:imgId inContext:[JSContext currentContext]];
            };
            [context evaluateScript:@"var blockTest = addClickBlock"];
            JSValue *avue = context[@"blockTest"];
           
            
                [imgValue.value invokeMethod:@"addClick" withArguments:[NSArray arrayWithObjects:url,localurl.absoluteString,[avue toObject], nil]];

        }else{
            [self loadImageWithUrlString:url inContext:context];
            
        }
    }
    
    
}

//下载图片,并更新图片
- (void)loadImageWithUrlString:(NSString*)url inContext:(JSContext*)context{
    if (url) {
        
        NSURL *imageUrl = [NSURL URLWithString:url];
        [self downloadImageWithURL:imageUrl options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            
            
            if (image && finished) {//如果下载成功
                NSString *cacheKey = [self cacheKeyForURL:imageUrl];
                NSString *imagePaths = [self.imageCache defaultCachePathForKey:cacheKey];
                //NSLog(@"imagePaths === %@",imagePaths);
                 NSURL *localurl = [NSURL fileURLWithPath:imagePaths];
              
                //对jsvalue进行托管,防止内存泄漏
                JSManagedValue *imgValue = [[JSManagedValue alloc]initWithValue: [context globalObject]];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [imgValue.value invokeMethod:@"changeImage" withArguments:@[url,localurl.absoluteString]];
                });
            }else {
                NSLog(@"远程图片下载失败!");
            }
        }];
    }else{
        NSLog(@"图片链接为空");
    }
    
    
}

@end
