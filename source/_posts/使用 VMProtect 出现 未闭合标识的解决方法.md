---
title: 使用 VMProtect 出现 未闭合标识的解决方法
date: 2011-06-25 02:39:00
tags: CSDN迁移
---
   [http://vmpsoft.com/forum/viewtopic.php?f=4&t=223](http://vmpsoft.com/forum/viewtopic.php?f=4&amp;t=223)

 

 导致出现未闭合标识的 原因是因为 编译器优化

 

 一个解决方法是

 在需要vm的代码 前后 使用 预编译宏

 

 

 #pragma optimize( "g", off )  
VMProtectBegin;

 // code

 VMProtectEnd;  
#pragma optimize( "g", on )

 

 

 

 另一种方法就是 项目属性里 关闭优化...

 

 我正在找一种折中的方法..

   
 