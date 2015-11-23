//
//  MasterViewController.m
//  JSToOCDemo
//
//  Created by Harry on 15/11/18.
//  Copyright © 2015年 HarryDeng. All rights reserved.
//

#import "MasterViewController.h"

#import "WebViewRedirectViewController.h"
#import "JavaScriptCoreViewController.h"
#import "EasyJSWebViewViewController.h"

@interface MasterViewController ()

@property NSMutableArray *objects;

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _objects = [NSMutableArray array];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"data"] = @"UIWebView代理重定向";
    dic[@"action"] = @"gotoWebViewRedirect";
    [_objects addObject:dic];
    
    dic = [NSMutableDictionary dictionary];
    dic[@"data"] = @"JavaScriptCore框架处理";
    dic[@"action"] = @"gotoJavaScriptCore";
    [_objects addObject:dic];
    
    dic = [NSMutableDictionary dictionary];
    dic[@"data"] = @"EasyJSWebView第三方代码处理";
    dic[@"action"] = @"gotoEasyJSWebView";
    [_objects addObject:dic];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 界面跳转
- (void)gotoWebViewRedirect{
    [self.navigationController pushViewController:[WebViewRedirectViewController new] animated:YES];
}

- (void)gotoJavaScriptCore{
    [self.navigationController pushViewController:[JavaScriptCoreViewController new] animated:YES];
}

- (void)gotoEasyJSWebView{
   [self.navigationController pushViewController:[EasyJSWebViewViewController new] animated:YES];
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSDictionary *dic = _objects[indexPath.row];
    NSString *title = dic[@"data"];
    cell.textLabel.text = title;
    return cell;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = _objects[indexPath.row];
    NSString *actionString = dic[@"action"];
    SEL selector = NSSelectorFromString(actionString);
    if (selector) {
        [self performSelector:selector];
    }
}
#pragma clang diagnostic pop

@end
