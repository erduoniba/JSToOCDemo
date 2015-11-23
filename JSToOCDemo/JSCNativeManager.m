//
//  NativeManager.m
//  JSToOCDemo
//
//  Created by Harry on 15/11/20.
//  Copyright © 2015年 HarryDeng. All rights reserved.
//

#import "JSCNativeManager.h"

@implementation JSCNativeManager

- (void)doSomeThing:(NSString *)someThing :(NSString *)s2{
    
    NSLog(@"使用OC对象来处理JS的点击事件");
    
    NSLog(@"js 传递 ： %@ %@", someThing, s2);
}

- (void)onePush:(NSString *)s1 submit:(NSString *)s2{
    NSLog(@"使用OC对象来处理JS的点击事件2");
    
    NSLog(@"js 传递 ： %@ %@", s1, s2);
}

- (void)morePraramtersWithP1:(NSString *)p1 p2:(NSString *)p2 p3:(NSString *)p3 p4:(NSString *)p4{
    NSLog(@"使用OC对象来处理JS的点击事件3");
    
    NSLog(@"js 传递 ： %@ %@ %@ %@", p1, p2, p3, p4);
}

@end
