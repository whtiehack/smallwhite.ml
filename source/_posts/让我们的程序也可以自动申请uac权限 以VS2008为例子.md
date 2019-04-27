---
title: 让我们的程序也可以自动申请uac权限 以VS2008为例子
date: 2009-12-24 03:23:00
tags: CSDN迁移
---
   在网上找到半天都没有找到好用一点的方法

 

 只有自己动手研究研究了

 

 在命令行的附加选项中加入下面的一行命令即可

 /MANIFESTUAC:"level='requireAdministrator' uiAccess='false'"

 

 

 看图说话

 

 ![](https://p-blog.csdn.net/images/p_blog_csdn_net/whitehack/EntryImages/20091224/QQ%E6%88%AA%E5%9B%BE%E6%9C%AA%E5%91%BD%E5%90%8D633972218342008750.jpg)

   
 