---
title: cocos ios,other linker flags 加入 -objc 编译报错解决方案
date: 2016-04-01 13:01:53
tags: CSDN迁移
---
  在嵌入 supersonic 的广告sdk时 遇到了同样的问题.   
 supersonic也要求加入 -ObjC

 
--------
 
```
Undefined symbols for architecture armv7s:
  "_GCControllerDidDisconnectNotification", referenced from:
      -[GCControllerConnectionEventHandler observerConnection:disconnection:] in libcocos2dx iOS.a(CCController-iOS.o)
  "_GCControllerDidConnectNotification", referenced from:
      -[GCControllerConnectionEventHandler observerConnection:disconnection:] in libcocos2dx iOS.a(CCController-iOS.o)
  "_OBJC_CLASS_$_GCController", referenced from:
      objc-class-ref in libcocos2dx iOS.a(CCController-iOS.o)
     (maybe you meant: _OBJC_CLASS_$_GCControllerConnectionEventHandler)
ld: symbol(s) not found for architecture armv7s
clang: error: linker command failed with exit code 1 (use -v to see invocation)
```
 
> 我用的是iphone5c，昨天使用admob的广告，这个sdk要求要将Other Linker Flags 设置成 -ObjC。不知如何解决以上报错。
> 
>  
 
### 解决方法：

 增加两个库：   
 MediaPlayer.framework   
 GameController.framework

 原因参见：

 
> [http://stackoverflow.com/questions/24844766/linking-errors-when-adding-admob-to-ios-cocos2d-x-3-2](http://stackoverflow.com/questions/24844766/linking-errors-when-adding-admob-to-ios-cocos2d-x-3-2)
> 
>  [http://blog.csdn.net/yinxin2745154/article/details/48497403](http://blog.csdn.net/yinxin2745154/article/details/48497403)
> 
>  
   
  