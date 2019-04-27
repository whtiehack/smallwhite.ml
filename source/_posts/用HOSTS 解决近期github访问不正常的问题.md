---
title: 用HOSTS 解决近期github访问不正常的问题
date: 2016-11-11 16:37:58
tags: CSDN迁移
---
  hosts加入 

 
```
151.101.100.133 assets-cdn.github.com
```
 我这边就搞定了.

 如果还是不太正常 再加上这个域名的试试

 
```
151.101.100.133 avatars1.githubusercontent.com
151.101.100.133 avatars2.githubusercontent.com
```
 原理是:

 在这个网站 `http://tool.chinaz.com/dns?type=1`  查询你访问github 出问题的 域名

 找个你访问正常的IP 修改hosts.

   
  