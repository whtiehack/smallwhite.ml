---
title: cocos  HttpClient  enableCookies  大坑
date: 2015-08-04 15:00:43
tags: CSDN迁移
---
  cocos2dx 3.6

 
```
//cookieFile 必须填  nullptr   
void enableCookies(const char* cookieFile);



HttpClient::getInstance()->enableCookies(nullptr);
```
 如果填自己编的一个文件名. 那么在 android 上 cookies 会失效!   
 而其它平台却不会有问题

   
  