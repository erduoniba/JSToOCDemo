//
//  NativeManager.h
//  JSToOCDemo
//
//  Created by Harry on 15/11/20.
//  Copyright © 2015年 HarryDeng. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <JavaScriptCore/JavaScriptCore.h>

@protocol JSCNativeManagerExport <JSExport>

///< 对于JS代码是：nativeManager.doSomeThing(s1, s2)，JSExport协议根据JS方法，使用多个:进行分割
- (void)doSomeThing:(NSString *)someThing :(NSString *)s2;

///< 对于JS代码是：nativeManager.onePushSubmit(s1, s2)，JSExport协议根据JS方法中的大写字母进行方法分割
- (void)onePush:(NSString *)s1 submit:(NSString *)s2;

///< 对于JS代码是：buttonClick5(s1, s2, s3, s4) 使用JSExport的提供的宏JSExportAs来处理
JSExportAs(morePraramters,
           - (void)morePraramtersWithP1:(NSString *)p1 p2:(NSString *)p2 p3:(NSString *)p3 p4:(NSString *)p4
           );

@end

@interface JSCNativeManager : NSObject <JSCNativeManagerExport>

@end
