---
title: 在dll内 不熟悉__declspec(thread)的话 尽量不要用
date: 2012-01-03 10:53:03
tags: CSDN迁移
---
   有个 dll 在win7 系统正常 

 放到xp系统 访问了 __declspec(thread) 变量 就直接挂掉 

 最后看了下 windows核心编程上的 "线程局部储存" 部分 ,看起来是跟dll初始化部分有关系.

 但是还没有时间仔细研究 最后只能放弃在这个dll中使用线程局部储存

 

 希望对大家有用

   
 