---
title: luaplus 与官方文档慢慢扯(三)
date: 2011-05-07 10:13:00
tags: CSDN迁移
---
   以下未知 占位

 

 
--------


 

 
## Class: LuaStateAuto/Owner (Unmanaged Only)

 `LuaStateAuto`  is an auto pointer encapsulation for a  `LuaState`  pointer. When the  `LuaStateAuto`  goes out of scope,  `LuaState::Destroy()`  is automatically called on the contained state. In a Release build,  `LuaStateAuto` 's accessors are inlined, and code generation is as if the  `LuaStateAuto`  object did not even exist.

 Using  `LuaStateAuto`  is illustrated below:

 
```
{ LuaStateAuto stateOwner; // The state is automatically set to NULL. stateOwner = LuaState::Create(); stateOwner->PushNil(); // LuaState::Destroy() is automatically called here. }
```
 `LuaStateOwner`  is derived from  `LuaStateAuto` .  `LuaStateOwner`  can automatically create the  `LuaState`  through the function call  `LuaState::Create` .

 
```
{ LuaStateOwner stateOwner; // Automatically calls LuaState::Create(). stateOwner->PushNil(); // LuaState::Destroy() is automatically called here. }
```
 Since a  `LuaStateAuto`  object merely encapsulates the  `LuaState`  pointer, it is possible to retrieve that pointer by just assigning it.

 
```
LuaState* state = stateOwner;
```
 
```
a
```
 
```

```

## Class: LuaObject

LuaObject封装了所有lua堆栈操作 甚至让你感觉到没有在操作lua堆栈  
而且它比lua capi操作堆栈效率更高  
LuaObject 还有一些特殊能力 这里我就不扯了 我自己也搞不太清楚  
有兴趣的自己看  
--------
LuaPlus provides an API extension over the core of Lua wrapped in the class  `LuaObject` . A  `LuaObject`  gives the full functionality of core Lua's stack entities, but it does so without involving the stack at all. In general,  `LuaObjects`  tend to run a little faster than the core Lua stack equivalent.

 A  `LuaObject`  should be used for all communication with LuaPlus that is external to a callback function.  `LuaStackObjects` , described below, are used in conjunction with callback functions, but the same functional interface is provided for consistency.

 `LuaObjects`  store a pointer to the parent  `LuaState` . In part, this is what makes the **LuaWatchAddin** work. Most importantly,  `LuaObjects`  can just be passed around without any regard for the LuaState they came from.

 It is also important to note  `LuaObject` s are scope-driven. So long as the  `LuaObject`  is in scope, the object is valid. When it goes out of scope, the contents of the  `LuaObject`  will be garbage collected. There is no need to run commands like  `lua_ref()`  to keep an object around. Merely holding onto the  `LuaObject`  instance, be it as a member variable, global variable, or even local variable within a block of code is enough to ensure the  `LuaObject` 's existence.

 A  `Reset()`  function is also provided. It resets the  `LuaObject`  back to a default state where no Lua state is pointed to internally.

 The sample code **TestSuite** performs an in-depth test of  `LuaObject`  and is a useful supplement to this documentation. The sample **TestScript** is also used as a test bed for  `LuaObject`  concepts.


--------
  
### Object Type

  
`LuaObject可以包含任意一种lua定义的类型  还有一种 wide string type 这是LuaPlus自己定义的类型`   
``   
`有以下几种方法检测指定类型(当然 如果是数字 用 IsString返回的会是1 因为number可以转换成string 这是lua的特性不可避免的)`   
``  `IsNil() - Tests if the object is nil.  Mirrors 
lua_isnil(). 
IsTable() - Tests if the object is a table.  Mirrors 
lua_istable(). 
IsUserData() - Tests if the object is userdata (including light 
userdata).  Mirrors lua_isuserdata(). 
IsCFunction() - Tests if the object is a C function.  Mirrors 
lua_iscfunction(). 
IsInteger() - Tests if the exact type of the object is a 
number.  See IsConvertibleToNumber() for the LuaObject 
equivalent of lua_isnumber(). 
IsNumber() - Tests if the exact type of the object is a 
number.  See IsConvertibleToNumber() for the LuaObject 
equivalent of lua_isnumber(). 
IsString() - Tests if the exact type of the object is a 
string.  See IsConvertibleToString() for the LuaObject 
equivalent of lua_isstring(). 
IsWString() - Tests if the exact type of the object is a wide 
string.  See IsConvertibleToWString() for the wide string 
equivalent of lua_isstring(). 
IsConvertibleToInteger() - Tests if the object is convertible 
to a number.  The object being tested can be a number, string, or wide string.  
Mirrors lua_isnumber(). 
IsConvertibleToNumber() - Tests if the object is convertible to 
a number.  The object being tested can be a number, string, or wide string.  
Mirrors lua_isnumber(). 
IsConvertibleToString() - Tests if the object is convertible to 
a string.  The object being tested can be a number or a string.  Mirrors 
lua_isstring(). 
IsConvertibleToWString() - Tests if the object is convertible 
to a wide string.  The object being tested can be a number or a wide string.  
Mirrors lua_iswstring(), the wide character equivalent of 
lua_isstring(). 
IsFunction() - Tests if the object is a function.  Mirrors 
lua_isfunction(). 
IsNone() - Tests if the object is out of range on the stack.  
Mirrors lua_isnone(). 
IsLightUserData() - Tests if the object is specifically light 
user data. 
IsBoolean() - Tests if the object is a boolean.  Mirrors 
lua_isboolean(). `   




可以通过 Type()函数检查原始的真实类型   
Type()的返回值是 LuaStatue类的一个枚举类型 下面是这个枚举值  
enum Types { TNONE = (-1), TNIL = 0, TBOOLEAN = 1, TLIGHTUSERDATA = 2, TNUMBER = 3, TSTRING = 4, TTABLE = 5, TFUNCTION = 6, TUSERDATA = 7, TTHREAD = 8, TWSTRING = 9, }; 可以通过  `LuaObject` 类的函数  `TypeName()`  获得到类型名 有点类似 lua_typename()  
### 取值函数

  
如果实际类型不可以转换你所要取的类型   
在 debug版本 都会触发assert  
  
* `int ToInteger()`  - Mirrors  `lua_tonumber()` . 尝试从object对象内取出证书 即使实际类型为一个字符串 
  * `lua_Number ToNumber()`  - Mirrors  `lua_tonumber()` . 尝试从object对象内取出证书 即使实际类型为一个字符串 
  * `const char* ToString()`  - Mirrors  `lua_tostring()` . 尝试取出字符串,如果实际类型为number number将被强制转换为string 
  * `const lua_WChar* ToWString()`  - Mirrors  `lua_towstring()` . 尝试取出 宽字符串,如果实际类型为number number将被强制转换为宽字符
  * `int GetInteger()`  - 取出整数 如果实际类型不是number将触发assert 
  * `float GetFloat()`  -同上 
  * `double GetDouble()`  - Retrieves the double the object represents. Asserts if the object is not of a numeric type. 
  * `lua_Number GetNumber()`  - Retrieves the lua_Number the object represents. Asserts if the object is not of a numeric type. 
  * `const char* GetString()`  - Retrieves the string the object represents. Asserts if the object is not a single byte string type. 
  * `const lua_WChar* GetWString()`  - Retrieves the wide string the object represents. Asserts if the object is not a double byte string type. 
  * `lua_CFunction GetCFunction()`  - Retrieves the C function pointer the object represents. Asserts if the object is not a C function. 
  * `void* GetUserData()`  - Retrieves the userdata or light userdata the object represents. Asserts if the object is not a userdata. 
  * `void* GetLightUserData()`  - Retrieves the light userdata the object represents. Asserts if the object is not a light userdata. 
  * `bool GetBoolean()`  - Retrieves the boolean the object represents. Asserts if the object is not a boolean convertible type.   
```
  
```
 如果 LuaObject 是 ANSI 或 宽字符 字符串,可以通过 StrLen() 取得字符串的长度 
```
ToStrLen() 函数可用于获取自动转换到字符串的number类型的长度 ToStrLen () 同 lua_strlen() 
```
 

 如果 object 类型为 table,function,userdata 或者 light userdata 那么 可以通过 GetLuaPointer() 获得储存在lua内部的指针

   
   
 
```
LuaObject obj = state->GetGlobal("SomeVariable"); if (obj.IsString()) { const char* str = obj.GetString(); } //一个示例
```
   
 

   
 