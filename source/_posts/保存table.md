---
title: 保存table   
date: 2011-04-16 15:37:00
tags: CSDN迁移
---

```
	--保存table   保存带有循环的table
function basicSerialize (o)
    if type(o) == "number" then
       return tostring(o)
    else       -- assume it is a string
       return string.format("%q", o)
    end
end


function save (name, value, saved)
    saved = saved or {}         -- initial value
    io.write(name, " = ")
    if type(value) == "number" or type(value) == "string" then
       io.write(basicSerialize(value), "/n")
    elseif type(value) == "table" then
       if saved[value] then     -- value already saved?
           -- use its previous name
           io.write(saved[value], "/n")
       else
           saved[value] = name  -- save name for next time
           io.write("{}/n")     -- create a new table
           for k,v in pairs(value) do  -- save its fields
              local fieldname = string.format("%s[%s]", name,
                                        basicSerialize(k))
              save(fieldname, v, saved)
           end
       end
    else
       error("cannot save a " .. type(value))
    end
end

save('s',{a=12, b='Lua', key='another "one"'})
print("--保存带有循环的table")
a = {x=1, y=2; {3,4,5}}
a[2] = a      -- cycle
a.z = a[1]    -- shared sub-table
save('a',a);
print("--保存带有共享部分的表")
a = {{"one", "two"}, 3}
b = {k = a[1]}
save('a', a)
save('b', b)
print("--使用同一个saved表来调用save函数/n--结果将共享相同部分");
local t = {}
save('a', a, t)
save('b', b, t)

		--似懂非懂....
--上面这种方法是Lua中常用的方法，当然也有其他一些方法可以解决问题。
--比如，我们可以不使用全局变量名来保存，即使用封包，用chunk构造一个local值然后返回之；
--通过构造一张表，每张表名与其对应的函数对应起来等。
--Lua给予你权力，由你决定如何实现。

```
 