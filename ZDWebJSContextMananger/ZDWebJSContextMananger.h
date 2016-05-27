//
//  ZDWebJSContextMananger.h
//  testjs
//
//  Created by william on 16/5/27.
//  Copyright © 2016年 william. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZDWebJSContextMananger : NSObject
//傻瓜模式
/*!
 *  初始化方法,或者使用非初始化方法
 *
 *  @param webView 需要加载的webview
 *  @param url     需要加载的url
 *  @param imgName web默认的本地图片
 *
 *  @return 返回实例
 */
- (instancetype)initWithWebView:(UIWebView*)webView url:(NSString*)url defaultImg:(NSString*)imgName;
- (void)loadWebViewWithWebView:(UIWebView*)webView url:(NSString*)url defaultImg:(NSString*)imgName;

/*!
 *  根据是否为手机网络加载图片,如为手机网络,点击下载成功图片后才会加载
 *
 *  @param isPhone 是否为手机网络
 */
- (void)loadImgsWithIsPhoneNet:(BOOL)isPhone;

//自定义模式

/*!
 初始化方法,或者使用非初始化方法
 *
 *  @param webView 需要加载的webview
 *  @param url     需要加载的url
 *  @param imgName web默认的本地图片
 *  @param finish  回调函数,返回参数为img标签地址集合与替换之后的html字符串
 *
 *  @return 返回实例
 */
- (instancetype)initWithWebView:(UIWebView*)webView url:(NSString*)url defaultImg:(NSString*)imgName finish:(void(^)( NSString* html, NSArray*imgUrls))finish;

- (void)loadWebViewWithWebView:(UIWebView*)webView url:(NSString*)url defaultImg:(NSString*)imgName finish:(void(^)( NSString* html, NSArray*imgUrls))finish;

/*!
 *  根据是否为手机网络加载图片,如为手机网络,点击下载成功图片后才会加载
 *  @param imgUrls img地址数组
 *  @param webView 需要加载的webview
 *  @param isPhone 是否为手机网络
 */

- (void)loadimgsWtihImgUrls:(NSArray*)imgUrls webView:(UIWebView*)webView isPhoneNet:(BOOL)isPhone;
@end
