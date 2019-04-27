---
title: VS 2008 MFC CString 转换 int
date: 2008-10-21 21:57:00
tags: CSDN迁移
---
   m_ed.GetWindowTextW(str);  
 char * time;  
 time=(char *)(LPCTSTR)str;  
 int titi;  
 titi=atoi(time);

 

 网上搜索了很久.也没有找到好的转换

 

 然后我 偶然的试了这个方法..没想到可以成功转换 = =#

 

 

   
 