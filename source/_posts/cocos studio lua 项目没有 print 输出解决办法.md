---
title: cocos studio lua 项目没有 print 输出解决办法
date: 2015-06-20 23:27:27
tags: CSDN迁移
---
   感谢启发帖: http://blog.k-res.net/archives/1833.html  


 

 AppDelegate.cpp 加上一句 

 

 
```
engine->executeString("print = release_print");
```
  
 搞定! 

 纠结了整整2天! 

 希望对同样纠结的同学有用!

   
 