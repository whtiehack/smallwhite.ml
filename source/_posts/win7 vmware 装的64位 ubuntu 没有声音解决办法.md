---
title: win7 vmware 装的64位 ubuntu 没有声音解决办法
date: 2015-08-21 20:18:09
tags: CSDN迁移
---
   连接声音,vm就提示 "使用的设备标识号已超出本地系统范围"

 

 解决办法

 1.首先设置声卡使用主机声卡

 2.进入ubuntu 打开终端

 3.输入 sudo su 回车,输入密码,取得root权限 

 4.输入 apt-get remove pulseaudio 回车

 5.搞定

   
 