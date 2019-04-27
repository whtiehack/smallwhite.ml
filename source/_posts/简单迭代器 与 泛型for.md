---
title: 简单迭代器 与 泛型for
date: 2011-04-13 22:06:00
tags: CSDN迁移
---
   初学lua很多地方似懂非懂

 

 保存下来以后查看

 

 环境是 luaforwidows

 编辑器用的scite lfw自带了

 

 

 

function list_iter (t) --迭代器

 local i = 0

 local n = table.getn(t) --list_iter 是一个工厂?

 return function () --返回的是函数

 --print("返回元素闭包函数被调用")

 i = i + 1

 if i <= n then return t[i] end

 end

 end

 

 t = {10, 20, 30}

 iter = list_iter(t) -- creates the iterator

 print("iter ",iter); --得到返回的那个闭包函数?

 while true do

 local element = iter() -- calls the iterator

 if element == nil then break end

 print(element)

 end

 

 print("泛型for")

 t = {11, 21, 31} --不懂..

 --[[范性for为迭代循环处理所有的薄记（bookkeeping）：首先调用迭代工厂；

 内部保留迭代函数，因此我们不需要iter变量；

 然后在每一个新的迭代处调用迭代器函数；

 当迭代器返回nil时循环结束--]]

 for element in list_iter(t) do

 print(element)

 end

   
   
 