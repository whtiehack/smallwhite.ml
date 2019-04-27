---
title: Lua语言中pairs和ipairs的区别
date: 2011-04-16 17:51:00
tags: CSDN迁移
---
   tbl = {"alpha", "beta", ["one"] = "uno", ["two"] = "dos"}

 for key, value in ipairs(tbl) do

 print(key, value)

 end

 --pairs()

 --pairs()函数基本和ipairs()函数用法相同, 区别在于pairs()可以遍历整个table, 即包括数组及非数组部分.

 -->如有pairs迭代输出如下：

 -->1 alpha

 -->2 beta

 -->one uno

 -->two dos

 -->如有ipairs迭代输出如下：

 --ipairs()

 --ipairs()函数用于遍历table中的数组部分.

 -->1 alpha

 -->2 beta

   
 