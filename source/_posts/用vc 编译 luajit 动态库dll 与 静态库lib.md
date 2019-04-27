---
title: 用vc 编译 luajit 动态库dll 与 静态库lib
date: 2011-05-28 01:51:00
tags: CSDN迁移
---
   开始菜单内找到VC的命令提示符 

 并且 cd 到 你的luajit src目录

 我的是 E:/Lua/LuaJIT-2.0.0-beta7/src

 

 Setting environment for using Microsoft Visual Studio 2010 x86 tools. D:/Program Files/Microsoft Visual Studio 10.0/VC>cd E:/Lua/LuaJIT-2.0.0-beta7/src D:/Program Files/Microsoft Visual Studio 10.0/VC>e: E:/Lua/LuaJIT-2.0.0-beta7/src> 

 然后输入 msvcbuild.bat 回车 就编译好 dll动态库了

 

 再次输入 msvcbuild.bat static 回车 就编译好 lib静态库了

 

 

 

 引用头文件与lua一样 lua.hpp

 

 另外 luajit 本身就支持中文变量名....不要跟我一样乱折腾了 真哈屁

 

   
 