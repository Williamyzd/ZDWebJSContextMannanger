//
//  ViewController.m
//  WebJSContextdemo
//
//  Created by william on 16/5/27.
//  Copyright © 2016年 william. All rights reserved.
//

#import "ViewController.h"
#import "ZDWebJSContextMananger.h"
#define URL @"http://www.izijia.cn/shouji/shoujimdd/jgb6_5633/"
@interface ViewController ()<UIWebViewDelegate>
@property (nonatomic,weak)UIWebView *webview;
@property (nonatomic,strong)ZDWebJSContextMananger *webMananger;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIWebView *webview = [[UIWebView alloc]initWithFrame:self.view.bounds];
    webview.delegate = self;
    [self.view addSubview:webview];
    self.webview = webview;
    self.webMananger = [[ZDWebJSContextMananger alloc]initWithWebView:self.webview url:URL defaultImg:@"icon.jpg"];
    // Do any additional setup after loading the view, typically from a nib.
}
//加载图片
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [self.webMananger loadImgsWithIsPhoneNet:YES];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{
    NSLog(@"出错啦!!!错误:%@",error);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
