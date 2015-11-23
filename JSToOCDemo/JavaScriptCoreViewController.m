//
//  JavaScriptCoreViewController.m
//  JSToOCDemo
//
//  Created by Harry on 15/11/18.
//  Copyright © 2015年 HarryDeng. All rights reserved.
//

#import "JavaScriptCoreViewController.h"

#import <JavaScriptCore/JavaScriptCore.h>

#import "JSCNativeManager.h"

@interface JavaScriptCoreViewController () <UIWebViewDelegate>

@end

@implementation JavaScriptCoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"redirect" ofType:@"html"];
    NSURLRequest *rq = [NSURLRequest requestWithURL:[NSURL URLWithString:htmlPath]];
    [webView loadRequest:rq];
    webView.delegate = self;
    [self.view addSubview:webView];
    
/*-----------------------------------------------------------*/
    //OC注入JS代码，再获取JS代码中的变量
    JSContext *iContext = [[JSContext alloc] init];
    [iContext evaluateScript:@"var arr = [21, 7, 'harry up'];"];    //上下文执行该JS代码（变量）
    JSValue *jsArr = iContext[@"arr"];
    NSArray *ocArr = [jsArr toArray];
    NSLog(@"JS Array: %@ \n OC Array: %@", jsArr, ocArr);
    
    //OC注入JS代码，再获取JS代码中的方法
    NSString *jsCode = @"function sum(a, b) {return a+b;}";       //定义JS方法
    [iContext evaluateScript:jsCode];                            //上下文执行该JS代码（方法）
    JSValue *jsFunc = iContext[@"sum"];                          //从上下文获取JS方法
    JSValue *result = [jsFunc callWithArguments:@[@20, @18]];    //js方法传入参数并且返回结果
    NSLog(@"result : %d", [result toInt32]);
/*-----------------------------------------------------------*/

    //OC注入JS代码（JS文件），再获取JS代码中的方法， （扩展）
    NSString *path = [[NSBundle mainBundle] pathForResource:@"jsCore" ofType:@"js"];
    NSString *pluginScript = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [iContext evaluateScript:pluginScript];                      //上下文执行该JS代码（方法）
    JSValue *jsFunc2 = iContext[@"max"];                          //从上下文获取JS方法
    JSValue *result2 = [jsFunc2 callWithArguments:@[@20, @18]];    //js方法传入参数并且返回结果
    NSLog(@"result2 : %d", [result2 toInt32]);
    
    //2、JS执行OC的postParamters方法
    iContext[@"postParamters"] = ^(NSInteger a, NSInteger b){
        NSDictionary *info = @{@"paramter1" : [NSNumber numberWithInteger:a + 20],
                               @"paramter2" : [NSNumber numberWithInteger:a + 18]};
        return info;
    };
    
    //1、OC执行JS中callBack方法
    JSValue *callBackFunc = iContext[@"callBack"];
    JSValue *vv = [callBackFunc callWithArguments:@[@20, @18]];
    NSDictionary *callBackDic = [vv toDictionary];
    NSLog(@"callBackDic : %@", callBackDic);
/*-----------------------------------------------------------*/
    
    //此处通过当前webView的键获取到jscontext
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"javascriptAction"] = ^(){
        NSArray *args = [JSContext currentArguments];
        for (JSValue *jsVal in args){
            NSLog(@"%@", jsVal);
        }
    };
/*-----------------------------------------------------------*/
    
    JSCNativeManager *manager = [JSCNativeManager new];
    context[@"nativeManager"] = manager;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
