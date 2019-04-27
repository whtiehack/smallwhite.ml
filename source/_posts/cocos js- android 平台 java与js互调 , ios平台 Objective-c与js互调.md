---
title: cocos js- android 平台 java与js互调 , ios平台 Objective-c与js互调
date: 2015-12-28 12:23:31
tags: CSDN迁移
---
  # ios平台 js 调用 Objective-c

 
```
//js调用 objc
var isinstall = jsb.reflection.callStaticMethod('AppController','isWXInstalled');
if(isinstall){
    jsb.reflection.callStaticMethod('AppController','sendAuthRequest');
}
else{
    specialModule._loginfun = null;
    callback('未安装微信!');
}


//objective-c  内AppController 的两个 静态函数
+(void)sendAuthRequest
{
    NSLog(@"wx begin send AuthRequest!!");
    __isWxLogin = true;
    //构造SendAuthReq结构体
    SendAuthReq* req =[[[SendAuthReq alloc ] init ] autorelease ];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"shooter_wxlogin_state" ;
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
}

+(BOOL) isWXInstalled
{
    return [WXApi isWXAppInstalled];
}

```
 
#### 上面是没有参数的情况

 如果有参数   
 还是上代码

 
```
    jsb.reflection.callStaticMethod('AppController','setShareTitle:andContent:andLink:',specialModule.shareTitle,
        specialModule.shareContents,specialModule.shareLink);



//objc的 函数原型

+(void) setShareTitle:(NSString *)title andContent:(NSString *)content andLink:(NSString*)link{

}
```
 
> 注意 特殊符号 冒号 : 
> 
>  
 再看一个做个对比

 
```
jsb.reflection.callStaticMethod('AppController','wxSharePic:filePath:',tofriend,picpath);



//objc函数原型 

+(void) wxSharePic:(BOOL)tofriend filePath:(NSString*)path{

}

```
 
> 还是要 注意冒号 ‘:’   
>  一个冒号代表有一个参数 
> 
>  
 
--------
 
# ios平台 Objective-c 调用 js

 
## 直接上代码.

 
```
#include "ScriptingCore.h"


-(void) onResp:(BaseResp*)resp
{
    NSLog(@"wx resp data code:%d  str:%@",resp.errCode,resp.errStr);
    if (__isWxLogin) {
        __isWxLogin = false;
        SendAuthResp *aresp = (SendAuthResp *)resp;
        if (aresp.errCode== 0) {
            NSString *code = aresp.code;
            char tmp[255]= {0};
            const char* tcode = [code UTF8String];
            sprintf(tmp, "specialModule.nativelogincallback('%s')",tcode);
            ScriptingCore::getInstance()->executeString(tmp);
        }else{
            ScriptingCore::getInstance()->executeString("specialModule.nativelogincallback(null,'未知错误')");
        }
    }else{
        switch (resp.errCode) {
            case 0:
            {
                ScriptingCore::getInstance()->executeString("specialModule.wechatShareMsg(0)");
                break;
            }
            case -2:
            {
                ScriptingCore::getInstance()->executeString("specialModule.wechatShareMsg(2)");
                break;
            }
            default:
                ScriptingCore::getInstance()->executeString("specialModule.wechatShareMsg(3)");
                break;
        }
    }

}

```
 核心与android的 java调用 js一样,   
 就是 evalString 内传入 js的 脚本字符串,即可执行 js.

 
> 注意   
>  virtual int executeString ( const char * codes ) 
> 
>  在ScriptingCore中无用，请使用 _evalString_    
>  For example:   
>   `ScriptingCore::getInstance()->evalString("specialModule.wechatShareMsg(0)",nullptr);` 
> 
>  
 
--------
 
--------
 
# android 平台 js 调用 java

 示例 可以参考 [http://www.cocos2d-x.org/docs/manual/framework/html5/v3/reflection/zh](http://www.cocos2d-x.org/docs/manual/framework/html5/v3/reflection/zh)

 
```
//js 调用 java
var o = jsb.reflection.callStaticMethod(className, methodName, methodSignature, parameters...)
//以上各个参数的意义看下面


```
 
--------
 
### className

 参数中的className必须是包含Java包路径的完整类名，例如我们在org.cocos2dx.javascript这个包下面写了一个Test类：

 
```
package org.cocos2dx.javascript;

public class Test {

    public static void hello(String msg){
        System.out.println(msg);
    }

    public static int sum(int a, int b){
        return a + b;
    }

    public static int sum(int a){
        return a + 2;
    }

}
```
 那么这个Test类的完整类名应该是  `org/cocos2dx/javascript/Test` 

 
--------
 
### methodName

 方法名很简单，就是方法本来的名字，例如sum方法的名字就是sum。

 
--------
 
### methodSignature

 方法签名稍微有一点复杂，最简单的方法签名是()V，它表示一个没有参数没有返回值的方法。其他一些例子：

 `(I)V` 表示参数为一个int，没有返回值的方法   
  `(I)I` 表示参数为一个int，返回值为int的方法   
  `(IF)Z` 表示参数为一个int和一个float，返回值为boolean的方法   
 现在有一些理解了吧，括号内的符号表示参数类型，括号后面的符号表示返回值类型。因为Java是允许函数重载的，可以有多个方法名相同但是参数返回值不同的方法，方法签名正是用来帮助区分这些相同名字的方法的。

 目前Cocos2d-js中支持的Java类型签名有下面4种：

 
```
Java类型     签名
int         I
float       F
boolean     Z
String      Ljava/lang/String;`
```
 
--------
 
### parameters

 参数可以是0个或任意多个，直接使用js中的number，bool和string就可以。

 
--------
 
### 使用示例,调用上面的Test类中的静态方法：

 
```
//调用hello方法
jsb.reflection.callStaticMethod("org/cocos2dx/javascript/Test", "hello", "(Ljava/lang/String;)V", "this is a message from js");

//调用第一个sum方法
var result = jsb.reflection.callStaticMethod("org/cocos2dx/javascript/Test", "sum", "(II)I", 3, 7);
cc.log(result); //10

//调用第二个sum方法
var result = jsb.reflection.callStaticMethod("org/cocos2dx/javascript/Test", "sum", "(I)I", 3);
cc.log(result); //5
```
 
### 需要注意的

 另外有一点需要注意的就是，在android应用中，cocos的渲染和js的逻辑是在gl线程中进行的，而android本身的UI更新是在app的ui线程进行的，所以如果我们在js中调用的Java方法有任何刷新UI的操作，都需要在ui线程进行。

 例如，在下面的例子中我们会调用一个Java方法，它弹出一个android的Alert对话框。

 
```
//给我们熟悉的AppActivity类稍微加点东西
public class AppActivity extends Cocos2dxActivity {

    private static AppActivity app = null;
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        app = this;
    }

    public static void showAlertDialog(final String title,final String message) {

        //这里一定要使用runOnUiThread
        app.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                AlertDialog alertDialog = new AlertDialog.Builder(app).create();
                alertDialog.setTitle(title);
                alertDialog.setMessage(message);
                alertDialog.setIcon(R.drawable.icon);
                alertDialog.show();
            }
        });
    }
}
```
 然后我们在js中调用

 
```
jsb.reflection.callStaticMethod("org/cocos2dx/javascript/AppActivity", "showAlertDialog", "(Ljava/lang/String;Ljava/lang/String;)V", "title", "hahahahha");
```
 这样调用你就可以看到一个android原生的Alert对话框了。

 
--------
 
## android平台 java 调用 js

 java调用 js 很简单. cocos 封装了一个 Cocos2dxJavascriptJavaBridge

 
```
import org.cocos2dx.lib.Cocos2dxJavascriptJavaBridge;



    private void popTip(int msg){
        Cocos2dxJavascriptJavaBridge.evalString("specialModule.wechatShareMsg("+msg+");");
    }


Cocos2dxJavascriptJavaBridge.evalString("specialModule.nativelogincallback('" + code + "');");

Cocos2dxJavascriptJavaBridge.evalString("specialModule.nativelogincallback(false,1);");


```
 核心就是 evalString 内传入 js的 脚本字符串,即可执行 js.

   
  