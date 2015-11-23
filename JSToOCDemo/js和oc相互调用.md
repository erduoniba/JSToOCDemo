# JS和OC相互调用

####1、现状：
`人人都是产品经理` [聊聊Web App、Hybrid App与Native App的设计差异](http://www.woshipm.com/pd/123646.html)

`标点符（钱魏 Way）` [Native App、Web App 还是Hybrid App？](http://www.biaodianfu.com/native-app-or-web-app-or-hybrid-app.html)

![image](http://img.my.csdn.net/uploads/201511/18/1447814628_9097.jpg)

![image](http://img.my.csdn.net/uploads/201511/18/1447814766_5082.jpg)

1）Native APP：Native Code编程，代码编译之后以2进制或者字节码的形式运行在OS上，直接调用OS的Device API；

2）Web APP，以HTML+JS+CSS等WEB技术编程，代码运行在浏览器中，通过浏览器来调用Device API（取决于HTML5未来的支持能力）：

3）Hybrid APP，部分代码以WEB技术编程，部分代码由某些Native Container承担（例如PhonGAP(Cordova)插件，BAE插件），其目的是在HTML5尚未完全支持Device API和Network API的目前阶段，承担这部分职责。（我们当前所使用的）


####2、Hybrid APP问题：
处理原生代码（OC）和HTML5的交互（JS）问题


####3、JS调用OC代码：

#####3.1 实现 `UIWebView` 的代理，然后根据NSURLRequest的URL进行不同处理,JS中的将要传递的数据作为URL  `重定向` :

	//webView的代理相应重定向
	- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
		NSString *requestString = [[[request URL]  absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    	NSLog(@"should-------");
    	if ([requestString hasPrefix:@"fdd://"]) {
        	//根据自己定义的规则，通过字符串的值，调用OC的方法。这里就输出一下字符串了。
       	 	NSLog(@"===%@",requestString); //可能包含商品的ID，APP拿到这个ID，使用OC代码执行相关操作
       	 	return NO; //YES 表示正常加载网页 返回NO 将停止网页加载
    	}

    	return YES;
	}
	
优点：`勉强实现JS调用OC代码，容易理解 ＝_＝`

缺点：`硬编码，扩展性差`


#####3.2 对3.1的一些扩展：

`zttjhm的专栏` [UIWebView中Html中用JS调用OC方法及OC执行JS代码](http://blog.csdn.net/zttjhm/article/details/43304329/)

**HTML代码：**
	
	<html>
    <head>
        <title>HTML中用JS调用OC方法</title>
        <meta http-equiv="Content-Type"content="text/html; charset=UTF-8">
            <script>
            </script>
    </head>        
            <body>
                <br>
                <br/>
                <a href ='fdd://alertShow'>alert提示</a>    //href 要跳转的链接   
                <br>
                <br/>
                <a href ='fdd://actionsheetShow'>actionsheet提示</a>          
            </body>
	</html>

	
**iOS代码：**

	#pragma clang diagnostic push
	#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
	- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    	NSString *urlstr = request.URL.absoluteString;
    	NSRange range = [urlstr rangeOfString:@"fdd://"];
    
    	if (range.length!=0){
       	 	urlstr = [urlstr substringFromIndex:(range.location+range.length)];
        	NSString *method = urlstr;
			SEL selctor = NSSelectorFromString(method);
			[self performSelector:selctor withObject:nil];
        	return NO;
    	}
    
    	return YES;
	}
	#pragma clang diagnostic pop
	
	- (void)alertShow{
	
	}
	
	- (void)actionsheetShow{
	
	}

优点：`实现JS调用OC代码，使用OC方法来处理JS的对应事件，可读性好`

缺点：`需要两端约定好方法，方法传多个参数不好处理`


#####3.3 JavaScriptCore框架：
`CocoaChina` [iOS7新JavaScriptCore框架介绍](http://www.cocoachina.com/ios/20140409/8127.html)

`hayageek` [Execute Javascript in iOS Applications](http://hayageek.com/execute-javascript-in-ios/)

`阿福的专栏` [IOS7开发～JavaScriptCore（一）](http://blog.csdn.net/lizhongfu2013/article/details/9232129)

`阿福的专栏` [IOS7开发～JavaScriptCore（二）](http://blog.csdn.net/zfpp25_/article/details/9236357)

`Kaitiren的专栏` [JavaScriptCore框架在iOS7中的对象交互和管理教程](http://blog.csdn.net/kaitiren/article/details/23256191)

`http://trac.webkit.org/` [JavaScriptCore框架源码OC](http://trac.webkit.org/browser/trunk/Source/JavaScriptCore/API)

`http://opensource.apple.com/`[JavaScriptCore框架源码C++](http://opensource.apple.com/source/JavaScriptCore/)

`limlimlim的专栏` [Javascript字典操作](http://blog.csdn.net/limlimlim/article/details/9088161)

`j_akill的专栏` [ios开发，javascript直接调用oc代码而非通过改变url回调方式](http://blog.csdn.net/j_akill/article/details/44463301)

`jwzhangjie的专栏` [OC与JS互相调用](http://blog.csdn.net/jwzhangjie/article/details/46823721)



JavaScriptCore框架只要引入了5个文件，每个文件里都定义跟文件名对应的类：

1. JSContext (**提供着运行环境**)

2. JSValue (**JavaScript和Object-C之间互换的桥梁**)

3. JSManagedValue （**将 JSValue 转为 JSManagedValue 类型后，可以添加到 JSVirtualMachine 对象中，这样能够保证你在使用过程中 JSValue 对象不会被释放掉，当你不再需要该 JSValue 对象后，从 JSVirtualMachine 中移除该 JSManagedValue 对象，JSValue 对象就会被释放并置空。**）

4. JSVirtualMachine（**JSVirtualMachine就是一个用于保存弱引用对象的数组，加入该数组的弱引用对象因为会被该数组 retain，所以保证了使用时不会被释放，当数组里的对象不再需要时，就从数组中移除，没有了引用的对象就会被系统释放。**）

5. JSExport(**神秘的语言穿梭机—JSExport协议**)


**HTML代码：**
	
	<html>
    <head>
        <title>HTML中用JS调用OC方法</title>
        <meta http-equiv="Content-Type"content="text/html; charset=UTF-8">
            <script>
            </script>
    </head>
            
            <body>
                <br>
                <br/>
				<button id="hallo" onclick="buttonClick2('JS点击方法传递参数标题', 'JS点击方法传递参数信息')"> JavaScriptCore点击方法传递参数 </button>
				
				<br><br/>
                <button id="hallo" onclick="buttonClick3('JS点击方法传递参数标题', 'JS点击方法传递参数信息')"> JavaScriptCore点击方法传递参数,使用对象方式 </button>
                
                <br><br/>
                <button id="hallo" onclick="buttonClick4('JS点击方法传递参数标题2', 'JS点击方法传递参数信息2')"> JavaScriptCore点击方法传递参数,使用对象方式2 </button>
                
                <br><br/>
                <button id="hallo" onclick="buttonClick5('JS点击1', 'JS点击2', 'JS点击3', 'JS点击4')"> JavaScriptCore点击方法传递多个参数,使用对象方式3 </button>
                
				<!--html页面绑定js事件，一般放在href之后，如果放在之前加载JS事件会阻塞界面-->
                <script type="text/javascript" src="redirect.js"></script>
                      
            </body>
	</html>
	
**JS代码：**

	function max(a, b){
    	return a>b?a:b;
	}

	function callBack(a, b){
    	var paramters = postParamters(20, 18); //执行OC的postParamters方法
    	var par1 = paramters['paramter1'];
    	var par2 = paramters['paramter2'];
    	paramters['paramter1'] = par1 + a;
    	paramters['paramter2'] = par2 + b;
    	return paramters;
	}
	
	function buttonClick2(title, message){
    	javascriptAction(title, message);
	}

	var nativeManager; //需要全局申明
	function buttonClick3(title, message){
    	nativeManager.doSomeThing('js to os' + title + '  ' , message);
	}

	function buttonClick4(title, message){
    	nativeManager.onePushSubmit('js to os' + title + '  ' , message);
	}

	function buttonClick5(s1, s2, s3, s4){
    	nativeManager.morePraramters(s1, s2, s3, s4);
	}
	
**iOS代码：**

OC注入JS代码:

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

OC通过JS文件注入JS代码

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


OC和HTML上的JS交互
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"redirect" ofType:@"html"];
    NSURLRequest *rq = [NSURLRequest requestWithURL:[NSURL URLWithString:htmlPath]];
    [webView loadRequest:rq];
    webView.delegate = self;
    [self.view addSubview:webView];
    
    //此处通过当前webView的键获取到jscontext
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //通过context对JS上的每一个方法进行回调监听
    context[@"javascriptAction"] = ^(){
        NSArray *args = [JSContext currentArguments];
        for (JSValue *jsVal in args){
            NSLog(@"%@", jsVal);
        }
    };

	//通过对象对JS上的每一个方法进行回调监听
    context[@"nativeManager"] = [NativeManager new];
    
`NativeManager.h`代码：


	#import <Foundation/Foundation.h>
	#import <JavaScriptCore/JavaScriptCore.h>

	@protocol NativeManagerExport <JSExport>

	///< 对于JS代码是：nativeManager.doSomeThing(s1, s2)，JSExport协议根据JS方法，使用多个:进行分割
	- (void)doSomeThing:(NSString *)someThing :(NSString *)s2;

	///< 对于JS代码是：nativeManager.onePushSubmit(s1, s2)，JSExport协议根据JS方法中的大写字母进行方法分割
	- (void)onePush:(NSString *)s1 submit:(NSString *)s2;

	///< 对于JS代码是：buttonClick5(s1, s2, s3, s4) 使用JSExport的提供的宏JSExportAs来处理
	JSExportAs(morePraramters,
           - (void)morePraramtersWithP1:(NSString *)p1 p2:(NSString *)p2 p3:(NSString *)p3 p4:(NSString *)p4
           );
	@end

	@interface NativeManager : NSObject <NativeManagerExport>
	@end
	
`NativeManager.m`代码：

	#import "NativeManager.h"

	@implementation NativeManager

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
	

**iOSlog日志：**
	
	JSToOCDemo[28592:1486323] JS Array: 21,7,harry up 
	OC Array: (
    21,
    7,
    "harry up"
	)
	
	JSToOCDemo[54490:1751112] result : 38
	JSToOCDemo[60727:1932210] callBackDic : {
		paramter1 = 60;
    	paramter2 = 56;
	}

	JSToOCDemo[28592:1486529] JS点击方法传递参数标题
	JSToOCDemo[28592:1486529] JS点击方法传递参数信息

优点：`实现JS调用OC代码，使用OC类来管理JS的对应方法，模块化清晰，能处理多个带参数方法`

缺点：`内存问题需要自己处理好`


#####3.4 EasyJSWebView第三方代码：
`github` [dukeland/EasyJSWebView](https://github.com/dukeland/EasyJSWebView)

`开源中国-珲少` [IOS NSInvocation应用与理解](http://my.oschina.net/u/2340880/blog/398552)

`iteye-啸笑天` [Objective C运行时（runtime）技术的几个要点总结](http://justsee.iteye.com/blog/2019541)


**HTML代码：**

	<button onClick="javascript:easyJSManager.saveUserInfo('111111', '2222222')">EasyJSWebView点击事件带参数</button>


**iOS代码：**

	EasyJSWebView *eWebView = [[EasyJSWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:eWebView];
    
    EJSWNativeManager *manager = [EJSWNativeManager new];
    //将OC管理类对象manager和JS的全局对象easyJSManager绑定
    [eWebView addJavascriptInterfaces:manager WithName:@"easyJSManager"];
    eWebView.delegate = self;
    
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"redirect" ofType:@"html"];
    NSURLRequest *rq = [NSURLRequest requestWithURL:[NSURL URLWithString:htmlPath]];
    [eWebView loadRequest:rq];

`EJSWNativeManager.h`代码:

	#import <Foundation/Foundation.h>
	
	@interface EJSWNativeManager : NSObject
	- (void)saveUserInfo:(NSString *)name :(NSString *)password;
	@end
	
`EJSWNativeManager.m`代码:

	#import "EJSWNativeManager.h"

	@implementation EJSWNativeManager
	- (void)saveUserInfo:(NSString *)name :(NSString *)password{
    	NSLog(@"EasyJSWebView点击事件带参数");
    	NSLog(@"js 传递 ： %@ %@", name, password);
    }
	@end	
	
`EasyJSWebView源码`分析：在`UIWebViewDelegate`代理的`webViewDidStartLoad`方法中，根据 **[eWebView addJavascriptInterfaces:manager WithName:@"easyJSManager"]** 方法的OC管理类对象manager和JS的全局对象easyJSManager在document创建新的子节点，该子节点的href对应的链接是由easyJSManager和manager的方法按照**`一定方式拼接`**，在点击HTML上的 “EasyJSWebView点击事件带参数”按钮时，button的onClick事件：javascript:easyJSManager.saveUserInfo会重新 调用OC的`webView: shouldStartLoadWithRequest: navigationType:`方法，这个时候再根据**`一定方式拼接`**来找到该点击事件所附带的信息。


优点：`实现JS调用OC代码，使用OC类来管理JS的对应方法，模块化清晰`

缺点：`必须继承EasyJSWebView，这使得它和第三方优秀的webview不好同时使用`


####3、OC调用JS代码：
