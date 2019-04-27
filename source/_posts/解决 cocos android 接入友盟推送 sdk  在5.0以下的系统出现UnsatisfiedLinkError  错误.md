---
title: 解决 cocos android 接入友盟推送 sdk  在5.0以下的系统出现UnsatisfiedLinkError  错误
date: 2016-03-07 14:08:57
tags: CSDN迁移
---
  根据我的测试.android 版本>=5.0是没有这个问题的.在 4.2.2 好像也没有这个问题

 错误提示

 
```
03-07 13:52:36.159: E/AndroidRuntime(22073): java.lang.UnsatisfiedLinkError: Couldn't load cocos2djs from loader dalvik.system.PathClassLoader[DexPathList[[zip file "/data/app/XXX.XXX.XXX.apk"],nativeLibraryDirectories=[/data/app-lib/com.Hsgame.Kill2-1, /vendor/lib, /system/lib]]]: findLibrary returned null

```
 如果还接入的友盟的统计. 也有类似的错误

 
```
java.lang.UnsatisfiedLinkError: Couldn't load libmobclickcpp from loader dalvik.system.PathClassLoader[DexPathList[[zip file "/data/app/XXX.XXX.XXX.apk"],nativeLibraryDirectories=[/data/app-lib/com.Hsgame.Kill2-1, /vendor/lib, /system/lib]]]: findLibrary returned null
```
 解决方法:   
 删除 `PushSDK/libs` 下的  `arm64-v8a`   `armeabi-v7a`   `mips`   `mips64`   `x86`   `x86_64`  目录   
 问题解决!

 还减少了APK包体.整个世界都清净了!!!

   
  