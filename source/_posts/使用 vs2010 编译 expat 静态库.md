---
title: 使用 vs2010 编译 expat 静态库
date: 2011-04-27 22:20:00
tags: CSDN迁移
---
   使用 vs2010 建立一个静态库工程

 设置使用多字节集

 

 

 然后按照 expat_static 内用到 的所有文件复制到你的静态库工程目录下

 

 然后按照头文件 源文件 添加进你的静态库工程

 

 

 然后修改expat.h 

 在第一行加入

 #define XML_STATIC 1

 

 

 

 然后编译即可

 

   
 