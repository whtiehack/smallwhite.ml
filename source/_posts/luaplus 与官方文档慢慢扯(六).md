---
title: luaplus 与官方文档慢慢扯(六) 
date: 2011-05-08 02:47:00
tags: CSDN迁移
---
   ### Calling Functions(调用lua函数)

 

 LuaObject 尝试简化Lua API 接口函数  
 它做到了完全屏蔽掉堆栈方面的操作   
 一般情况下,调用Lua的函数可以在一行代码中完成  
   
 #### Recommended Style(推荐风格)

   
 利用一些c++模板的技巧,使我们调用lua函数好像是在调用普通的c++函数  
 LuaStateOwner state; state->DoString("function Add(x, y) return x + y end"); LuaFunction<float> Add = state->GetGlobal("Add"); printf("Add: %d/n", Add(2, 7));    
   
   
 模板 LuaFunction<RT> 带有一个参数 RT (return type) ,意思是返回值类型  
 参数类型可以自动判断,但是返回值不行, 所以需要手动设置返回值类型 默认的返回值类型是 void  
 LuaStateOwner state; state->DoString("function Print(str) print(str) end"); LuaFunction<> Print = state->GetGlobal("Print"); Print("Hello, world!");    
   
   
 LuaPlus可以使用的内置返回值类型有  
 * `bool`   
  * `char`   
  * `unsigned char`   
  * `short`   
  * `unsigned short`   
  * `int`   
  * `unsigned int`   
  * `long`   
  * `unsigned long`   
  * `float`   
  * `double`   
  * `const char*`   
  * `const lua_WChar*`   
  * `lua_CFunction`   
  * `LuaStateCFunction`   
  * `LuaStackObject`   
  * `LuaObject`   
  * `const void*`   
  * `LuaArgNil()`   
  * `LuaLightUserData(pointer)`   
  * `LuaUserData(pointer)`     
 

 与直接注册c++普通函数一样 调用lua函数同样只支持最多7个参数

 

 

 
#### Iostream-like Style(Iostream-like 风格)(iostream这部分基本不懂...)

 LuaPlus also employs a convention similar to the Standard C++ library's iostream functionality. A simple example follows:

 LuaStateOwner state; state->DoString("function Add(x, y) return x + y end"); LuaObject funcObj = state->GetGlobal("Add"); { LuaAutoBlock autoBlock(state); LuaCall call = funcObj(); LuaStackObject retObj = call << 2 << 7 << LuaRun(); printf("Add: %d/n", retObj.GetInteger()); }  

 

 The function call starts by "calling" the  `LuaObject` .  `LuaObject`  provides an overloaded function operator(). Then, each argument to the function is added to the argument list, left to right. Finally, when all arguments are added,  `LuaRun()`  executes the function call.

 It can't be avoided that a Lua function call puts return values on the stack. The  `LuaStackObject`  returned by the LuaPlus function call is the first return value. There may be more.

 `operator<<`  understands most Lua types. The  `nil`  type is special, though. In order to tell LuaPlus a  `nil`  should be inserted in the function's argument list,  `LuaArgNil()`  must be passed in.

 
```
LuaObject funcObj = state->GetGlobal("PrintIt"); LuaCall call = funcObj; LuaStackObject retObj = call << "String" << LuaArgNil() << LuaRun();
```
 `LuaRun()`  takes an optional argument detailing the number of return values allowed. By default, multiple return values are allowed.

 
```
LuaObject funcObj = state->GetGlobal("ThreeReturnValues"); LuaCall call = funcObj; LuaStackObject retObj = call << LuaRun(1); // Only accept one return value.
```
 

 

 

 
### Metatables(元表)

 可以通过  `GetMetaTable() 函数获得 Metatable 的 LuaObject` 

 Metatable 作为一个基本类型被共享,详细需要参考下面的 元表增强部分(Metatable Enhancements)部分

 

 下面不懂

 
--------
A metatable can be changed for a LuaObject via the SetMetaTable() function. If the LuaObject represents a table or userdata, the metatable change is as per standard Lua. If the LuaObject is a basic type, the metatable is changed for all basic types.

 


--------


   
 

 

   
 