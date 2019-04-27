---
title: 关于 STM_SETIMAGE 的使用 有一个注意事项
date: 2011-05-24 21:01:00
tags: CSDN迁移
---
   HBITMAP holdmap=(HBITMAP)SendMessage(picwnd,STM_SETIMAGE,IMAGE_BITMAP,(LPARAM)hmap); if (holdmap!=NULL) { DeleteObject(holdmap); } DeleteObject(hmap) 

 

 在做一个项目 因为要不停的 STM_SETIMAGE 设置新的位图 

 但是发现一个问题设置一个为图就增长一次内存 很明显.有地方内存泄漏了

 这个问题我调试了几个小时 很悲催

 

 

 发送 STM_SETIMAGE 的时候 必须接收他的返回值 !

 如果之前已经有了对象 必须对他使用 deleteobject

 系统不会帮你delete 如果不接收他的返回值来删除原来的对象

 那么将一直造成内存泄漏

 

 

   
 