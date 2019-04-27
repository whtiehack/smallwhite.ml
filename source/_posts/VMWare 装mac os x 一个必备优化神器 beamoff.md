---
title: VMWare 装mac os x 一个必备优化神器 beamoff
date: 2015-07-26 23:47:53
tags: CSDN迁移
---
  [http://files.cnblogs.com/files/yipu/beamoff.zip](http://files.cnblogs.com/files/yipu/beamoff.zip)

 这个程序设置为登录启动比较好   
 源码很简单:

 
```
//
//  AppDelegate.m
//  beamoff
//
//  Created by ANDREI VAYAVODA on 09.11.14.
//  Copyright (c) 2014 ANDREI VAYAVODA. All rights reserved.
//

#import "AppDelegate.h"
extern void CGSSetDebugOptions(int);
extern void CGSDeferredUpdates(int);

typedef enum {
    disableBeamSync = 0,
    automaticBeamSync = 1,
    forcedBeamSyncMode = 2
} beamSyncMode;


@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    int mode = disableBeamSync;

    CGSSetDebugOptions(mode ? 0 : 0x08000000);
    CGSDeferredUpdates(mode);
    [self.window close];
    [NSApp terminate:self];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
```
 beamoff 在github 上的地址:   
 [https://github.com/JasF/beamoff](https://github.com/JasF/beamoff)

 另外还有一个必须做的优化

 
> “系统偏好设置” 进入”辅助功能” 然后勾选”减少透明度”
> 
>  
 另一个:

 
> “系统偏好设置”进入”Dock”  `最小化窗口时使用:`  选择“缩放效果”
> 
>  
 another:

 
> “系统偏好设置”进入”扩展”,然后将不使用的组件勾掉.
> 
>  
 这几步搞完以后,界面响应速度在我的pc上提升好几倍.

 **beamoff 设置为开机自动运行方法**

 
> 下载 [http://files.cnblogs.com/files/yipu/beamoff.zip](http://files.cnblogs.com/files/yipu/beamoff.zip)   
>  mac会自动解压 得到 beamoff.app   
>  系统偏好设置 - 用户与群组 - 选中你自己的用户名 - 选择 “登录项” 选项卡 - 点 + 号   
>  找到你下载的beamoff.app
> 
>  
   
  