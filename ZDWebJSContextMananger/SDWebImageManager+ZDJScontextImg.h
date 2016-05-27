//
//  SDWebImageManager+ZDJScontextImg.h
//  testjs
//
//  Created by william on 16/5/26.
//  Copyright © 2016年 william. All rights reserved.
//

#import "SDWebImageManager.h"
#import <JavaScriptCore/JavaScriptCore.h>
@interface SDWebImageManager (ZDJScontextImg)
//jsContex加载
/*!
 *  根据图片地址数组加载图片
 *
 *  @param imgArr     图片地址数组加载图片
 *  @param isPhoneNet 是否是手机网络
 *  @param context    JS环境
 */
- (void)loadImageWithImgArray:(NSArray*)imgArr  isPhoneNetwork:(BOOL)isPhoneNet inContext:(JSContext*)context;
/*!
 *  根据单张图片地址加载图片
 *
 *  @param url     图片地址
 *  @param context js环境
 */
- (void)loadImageWithUrlString:(NSString*)url inContext:(JSContext*)context;
@end
