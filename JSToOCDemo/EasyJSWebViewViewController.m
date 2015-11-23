//
//  EasyJSWebViewViewController.m
//  JSToOCDemo
//
//  Created by Harry on 15/11/23.
//  Copyright © 2015年 HarryDeng. All rights reserved.
//

#import "EasyJSWebViewViewController.h"

#import "EasyJSWebView.h"
#import "EJSWNativeManager.h"

@interface EasyJSWebViewViewController () <UIWebViewDelegate>
{
    EasyJSWebView *eWebView;
}

@end

@implementation EasyJSWebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    eWebView = [[EasyJSWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:eWebView];
    
    EJSWNativeManager *manager = [EJSWNativeManager new];
    //将OC管理类对象manager和JS的全局对象easyJSManager绑定
    [eWebView addJavascriptInterfaces:manager WithName:@"easyJSManager"];
    eWebView.delegate = self;
    
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"redirect" ofType:@"html"];
    NSURLRequest *rq = [NSURLRequest requestWithURL:[NSURL URLWithString:htmlPath]];
    [eWebView loadRequest:rq];
    
    
    SEL myMethod = @selector(doSome:other:);
    //创建一个函数签名，这个签名可以是任意的,但需要注意，签名函数的参数数量要和调用的一致。最好使用myMethod
    NSMethodSignature *sig = [[self class] instanceMethodSignatureForSelector:@selector(pop: push:)];
    //通过签名初始化
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
    //设置target
    [invocation setTarget:self];
    //设置selecteor
    [invocation setSelector:myMethod];
    NSString *h = @"hello";
    NSString *w = @"world";
    [invocation setArgument:&h atIndex:2];
    [invocation setArgument:&w atIndex:3];
    //消息调用
    [invocation invoke];
}


- (void)pop:(NSString *)pop push:(NSString *)push{
    
}

- (void)doSome:(NSString *)h other:(NSString *)w{
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
