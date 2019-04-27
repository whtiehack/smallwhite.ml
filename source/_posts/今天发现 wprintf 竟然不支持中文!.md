---
title: 今天发现 wprintf 竟然不支持中文!
date: 2011-01-03 17:28:00
tags: CSDN迁移
---
   #include <locale>

 

 包含头文件先

 

 程序入口调用:

 setlocale(LC_CTYPE, "");//让wprintf 支持中文

 

 为啥?别问我 我也不知道为啥

 那为啥要call setlocale? 我还是不知道为啥

   
 