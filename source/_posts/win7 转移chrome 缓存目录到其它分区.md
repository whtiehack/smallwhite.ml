---
title: win7 转移chrome 缓存目录到其它分区
date: 2015-09-03 00:55:28
tags: CSDN迁移
---
   使用 mklink 目录链接 实现

 1.关闭 Chrome

 2.打开 "资源管理器" 在地址栏 输入 


```
%USERPROFILE%\AppData\Local\
```
就是 "C:\Users\Administrator\AppData\Local" 文件夹 

 3.剪切 "Google" 目录 到你想放 缓存目录的分区

 我的是放到E盘 的 Program 目录下 "E:\Program\Google"

 

 4.组合键 "WIN+R" 打开"运行"窗口 输入 

 


```
mklink /D %USERPROFILE%\AppData\Local\Google "D:\Program Files\Google
```
  


 5.搞定 .可以开启 Chrome 了

 

 原来位置多了个 目录链接

 ![](https://img-blog.csdn.net/20150903005412668?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQv/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/Center)  


   
 