//
//  ZDWebJSContextMananger.m
//  testjs
//
//  Created by william on 16/5/27.
//  Copyright © 2016年 william. All rights reserved.
//

#import "ZDWebJSContextMananger.h"
#import "ZDFixHtmlTool.h"
#import "SDWebImageManager+ZDJScontextImg.h"
@interface ZDWebJSContextMananger ()
@property (nonatomic,weak)UIWebView *webview;
@property (nonatomic,copy)NSArray *imgSrcs;
@end
@implementation ZDWebJSContextMananger

//傻瓜模式
-(instancetype)initWithWebView:(UIWebView *)webView url:(NSString *)url defaultImg:(NSString *)imgName{
    return [[ZDWebJSContextMananger alloc]initWithWebView:webView url:url defaultImg:imgName finish:nil];
}
//加载视图
- (void)loadWebViewWithWebView:(UIWebView*)webView url:(NSString*)url defaultImg:(NSString*)imgName{
    [self loadWebViewWithWebView:webView url:url defaultImg:imgName finish:nil];
}
//加载图片
- (void)loadImgsWithIsPhoneNet:(BOOL)isPhone{
    [self loadimgsWtihImgUrls:self.imgSrcs webView:self.webview isPhoneNet:isPhone];
}

//自定义模式
-(instancetype)initWithWebView:(UIWebView *)webView url:(NSString *)url defaultImg:(NSString *)imgName finish:(void (^)(NSString *, NSArray *))finish{

    self = [super init];
    if (self) {
        [self loadWebViewWithWebView:webView url:url defaultImg:imgName finish:finish];
        
    }
    return self;

    
}
//加载视图
- (void)loadWebViewWithWebView:(UIWebView*)webView url:(NSString*)url defaultImg:(NSString*)imgName finish:(void(^)( NSString* html, NSArray*imgUrls))finish{
    self.webview = webView;
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *html = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        if(!(html.length>2))
        {
            NSLog(@"详情加载失败!");
            return;
        }
        else
        {
            NSLog(@"详情加载成功!");
        }
        //替换标签
        ZDFixHtmlTool *htmlTool = [[ZDFixHtmlTool alloc]initWithHtmlUrl:url];
        [htmlTool fixHtml:html defaultImage:imgName finishBlock:^(NSString *endHtml, NSArray *imgAddresses) {
            //插入js代码
            self.imgSrcs = [NSArray arrayWithArray:imgAddresses];
            endHtml  =  [self joinTheJScodeWithFileName:@"js.txt" html:endHtml];
            dispatch_async(dispatch_get_main_queue(), ^{
                //加载页面
                [webView loadHTMLString:endHtml baseURL:nil];
            });
            if (finish) {
                 finish(endHtml,imgAddresses);
            }
           
        }];
    }] resume];
    
}

//处理图片
- (void)loadimgsWtihImgUrls:(NSArray*)imgUrls webView:(UIWebView*)webView isPhoneNet:(BOOL)isPhone{
    //实例化js环境
    JSVirtualMachine *virtualMachine = [[JSVirtualMachine alloc] init];
    JSContext  *context = [[JSContext alloc]initWithVirtualMachine:virtualMachine];
    //取得当前环境
    context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    [context setExceptionHandler:^(JSContext *cont, JSValue *vaue) {
        NSLog(@"js出错啦!js:%@,vaue:%@",cont,vaue);
    }];
    
    [[SDWebImageManager sharedManager] loadImageWithImgArray:imgUrls isPhoneNetwork:isPhone inContext:context];
    
}

//插入js文件
- (NSString*)joinTheJScodeWithFileName:(NSString*)fileName html:(NSString*)html{
    NSString *jsPaht = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    NSString *jsStr = [[NSString alloc]initWithContentsOfURL:[NSURL fileURLWithPath:jsPaht] encoding:NSUTF8StringEncoding error:nil];
    html = [html stringByReplacingOccurrencesOfString:@"</body>"  withString:jsStr];
    
    return html;
}

@end
