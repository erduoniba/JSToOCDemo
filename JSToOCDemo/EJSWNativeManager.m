//
//  EJSWNativeManager.m
//  JSToOCDemo
//
//  Created by Harry on 15/11/23.
//  Copyright © 2015年 HarryDeng. All rights reserved.
//

#import "EJSWNativeManager.h"

@implementation EJSWNativeManager

- (void)saveUserInfo:(NSString *)name :(NSString *)password{
    NSLog(@"EasyJSWebView点击事件带参数");
    
    NSLog(@"js 传递 ： %@ %@", name, password);
}

@end
