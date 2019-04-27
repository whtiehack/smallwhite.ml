---
title: __index __newindex metamethod
date: 2011-04-17 16:43:00
tags: CSDN迁移
---
   -- 13.4.1 The __index Metamethod 有点c++继承的意思 -- create a namespace Window = {} -- create the prototype with default values Window.prototype = {x=0, y=0, width=100, height=101, } --定义一个原型表 默认值 -- create a metatable Window.mt = {} --创建 metatable -- declare the constructor function function Window.new (o) --定义new函数 setmetatable(o, Window.mt) return o end --现在我们定义__index metamethod： Window.mt.__index = function (table, key) return Window.prototype[key] end --这样一来，我们创建一个新的窗口，然后访问他缺少的域结果如下： w = Window.new{x=10, y=20} print(w.width) --> 100 --无需把__index metamethod 定义为函数 可以直接给他一个表 Window.mt.__index = Window.prototype --13.4.2 The __newindex Metamethod --__newindex metamethod用来对表更新，__index则用来对表访问 print("--对 w.witdh赋值试试",w.width); w.width=90; print(w.width,Window.prototype.width); -- print("--遍历下表看看") for i,j in pairs(w) do print(i,j) end --很明显 对 width的赋值 直接导致 吧值赋值给了 w表本身 --__newindex metamethod 现在试试__newindex Window.mt.__newindex = Window.prototype print("--定义了 __newindex ") w = Window.new{x=10, y=20} --重新创建表 因为之前的表已经被污染了 print("--对 w.witdh赋值试试",w.width); w.width=90; print(w.width,Window.prototype.width); print("--遍历下表看看") for i,j in pairs(w) do print(i,j) end  

   
 