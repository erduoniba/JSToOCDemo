//
//  EJSWNativeManager.h
//  JSToOCDemo
//
//  Created by Harry on 15/11/23.
//  Copyright © 2015年 HarryDeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface EJSWNativeManager : NSObject

- (void)saveUserInfo:(NSString *)name :(NSString *)password;

- (void)ocTojs:(UIWebView *)webView;

@end
