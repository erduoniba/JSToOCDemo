//
//  WebViewRedirectViewController.m
//  JSToOCDemo
//
//  Created by Harry on 15/11/18.
//  Copyright © 2015年 HarryDeng. All rights reserved.
//

#import "WebViewRedirectViewController.h"

@interface WebViewRedirectViewController () <UIWebViewDelegate>

@end

@implementation WebViewRedirectViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"redirect" ofType:@"html"];
    NSURLRequest *rq = [NSURLRequest requestWithURL:[NSURL URLWithString:htmlPath]];
    [webView loadRequest:rq];
    webView.delegate = self;
    [self.view addSubview:webView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString *urlstr = request.URL.absoluteString;
    NSRange range = [urlstr rangeOfString:@"fdd://"];
    
    if (range.length!=0){
        urlstr = [urlstr substringFromIndex:(range.location+range.length)];
        NSString *method = urlstr;
        
        NSArray *urlArr = [urlstr componentsSeparatedByString:@"?"];
        if (urlArr.count == 2) {
            //带参数的JS点击事件 fdd://jsAction?title=title&message=message
            method = [NSString stringWithFormat:@"%@:", urlArr[0]];
            
            
            NSString *components = urlArr[1];
            NSArray *componentArr = [components componentsSeparatedByString:@"&"];
            
            NSMutableDictionary *paramters = [NSMutableDictionary dictionaryWithCapacity:componentArr.count];
            [componentArr enumerateObjectsUsingBlock:^(NSString *component, NSUInteger idx, BOOL * _Nonnull stop) {
                //title=title
                NSArray *paramterArr = [component componentsSeparatedByString:@"="];
                if (paramterArr.count == 2) {
                    if ([paramterArr[0] length] > 0) {
                        NSString *paramter = [(NSString*)paramterArr[1] stringByRemovingPercentEncoding];
                        [paramters setObject:paramter forKey:paramterArr[0]];
                    }
                }
            }];
            
            SEL selctor = NSSelectorFromString(method);
            [self performSelector:selctor withObject:paramters];
        }
        else{
            SEL selctor = NSSelectorFromString(method);
            [self performSelector:selctor withObject:nil];
        }
        
        return NO;
    }
    
    //http://xf.fangdd.com/shenzhen/48514.html
    //NSRange rangle2 = [urlstr rangeOfString:@"http://xf.fangdd.com/shenzhen/"];
    
    return YES;
}
#pragma clang diagnostic pop

- (void)alertShow {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"不带参数的alert" message:@"这个是UIAlertController的默认样式" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"明白" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertC addAction:cancelAction];
    [alertC addAction:sureAction];
    [self presentViewController:alertC animated:YES completion:Nil];
}

- (void)actionsheetShow {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"不带参数的alert" message:@"这个是UIAlertController的默认样式" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"明白" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *whatAction = [UIAlertAction actionWithTitle:@"你在讲什么?" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertC addAction:cancelAction];
    [alertC addAction:sureAction];
    [alertC addAction:whatAction];
    [self presentViewController:alertC animated:YES completion:Nil];
}

- (void)jsAction:(NSDictionary *)info{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:info[@"title"] message:info[@"message"] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"明白" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertC addAction:cancelAction];
    [alertC addAction:sureAction];
    [self presentViewController:alertC animated:YES completion:Nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
