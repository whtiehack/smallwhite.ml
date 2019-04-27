---
title: luaplus 与官方文档慢慢扯(二)
date: 2011-05-07 09:20:00
tags: CSDN迁移
---
   堆栈操作相关函数

 

 
  * `GetTop()`  - Mirrors  `lua_gettop()` .  
  * `SetTop(int index)`  - Mirrors  `lua_settop()` .  
  * `PushValue(int index)`  - Mirrors  `lua_pushvalue()` .  
  * `PushValue(LuaStackObject& object)`  - Mirrors  `lua_pushvalue()` .  
  * `Remove(int index)`  - Mirrors  `lua_remove()` .  
  * `Insert(int index)`  - Mirrors  `lua_insert()` .  
  * `Replace(int index)`  - Mirrors  `lua_remove()` .  
  * `CheckStack(int size)`  - Mirrors  `lua_checkstack()` .  
  * `XMove(LuaState* to, int n)`  - Mirrors  `lua_xmove()` .  
  * `Equal(int index1, int index2)`  - Mirrors  `lua_equal()` .  
  * `RawEqual(int index1, int index2)`  - Mirrors  `lua_rawequal()` .  
  * `LessThan(int index1, int index2)`  - Mirrors  `lua_lessthan()` .  

 

 值压入堆栈

 

 
  * `PushNil()`  - Mirrors  `lua_pushnil()` .  
  * `PushInteger(int n)`  - Mirrors  `lua_pushinteger()` .  
  * `PushNumber(lua_Number n)`  - Mirrors  `lua_pushnumber()` .  
  * `PushLString(const char* s, size_t len)`  - Mirrors  `lua_pushlstring()` .  
  * `PushLWString(const lua_WChar* s, size_t len)`  - Mirrors  `lua_pushlwstring()` .  
  * `PushString(const char* s)`  - Mirrors  `lua_pushstring()` .  
  * `PushWString(const lua_WChar* s)`  - Mirrors  `lua_pushwstring()` .  
  * `PushBoolean(bool value)`  - Mirrors  `lua_pushboolean()` .  
  * `PushLightUserData(void* p)`  - Mirrors  `lua_pushlightuserdata()` . 

 

 把函数压入堆栈

 

 
  * `PushCClosure(lua_CFunction fn, int n)`  - Mirrors  `lua_pushcclosure()` .  
  * `PushCClosure(function, n)`  - function 有一个参数  `LuaState*   可以压入全局函数 静态函数 以及 成员函数.神奇!`  
  * `PushCFunction(lua_CFunction fn)`  - 同 lua_pushcfunction 

 

 检查参数

 

 
  * `TypeError(narg, tname)`  - Mirrors  `luaL_typerror()` .  
  * `ArgError(narg, extramsg)`  - Mirrors  `luaL_argerror()` .  
  * `CheckLString(numArg, len)`  - Mirrors  `luaL_checklstring()` .  
  * `OptLString(numArg, def, len)`  - Mirrors  `luaL_optlstring()` .  
  * `CheckNumber(numArg)`  - Mirrors  `luaL_checknumber()` .  
  * `OptNumber(nArg, def)`  - Mirrors  `luaL_optnumber()` .  
  * `ArgCheck(condition, numarg, extramsg)`  - Mirrors  `luaL_argcheck()` .  
  * `CheckString(numArg)`  - Mirrors  `luaL_checkstring()` .  
  * `OptString(numArg, def)`  - Mirrors  `luaL_optstring()` .  
  * `CheckInt(numArg)`  - Mirrors  `luaL_checkint()` .  
  * `CheckLong(numArg)`  - Mirrors  `luaL_checklong()` .  
  * `OptInt(numArg, def)`  - Mirrors  `luaL_optint()` .  
  * `OptLong(numArg, def)`  - Mirrors  `luaL_optlong()` .  
  * `CheckStack(int sz, const char* msg)`  - Mirrors  `luaL_checkstack()` .  
  * `CheckType(narg, t)`  - Mirrors  `luaL_checktype()` .  
  * `CheckAny(int narg)`  - Mirrors  `luaL_checkany()` .  
  * `CheckUData(int ud, const char* tname)`  - Mirrors  `luaL_checkudata()` . 

 

 操作堆栈table相关函数 (It is highly recommended  `LuaObject`  is used instead, as it provides a much better C++ alternative than the Lua stack.) -->强烈建议使用 LuaObject来操作 因为它提供了比lua堆栈函数更好的替代方法

 

 
  * `SetTable(int index)`  - Mirrors  `lua_settable()` .  
  * `RawSet(int index)`  - Mirrors  `lua_rawset()` .  
  * `RawSetI(int index, int n)`  - Mirrors  `lua_rawseti()` .  
  * `SetMetaTable(int index)`  - Mirrors  `lua_setmetatable()` .  
  * `SetGlobals(int index)`  - Mirrors  `lua_setfenv()` . Backward compatible.  
  * `SetFEnv(int index)`  - Mirrors  `lua_setfenv()` .  
  * `SetGlobal(const char *name)`  - Mirrors  `lua_setglobal()` .  
  * `Ref(int lock)`  - Mirrors  `luaL_ref()` .  
  * `Unref(int ref)`  - Mirrors  `luaL_unref()` .  
  * `SetDefaultMetaTable(int type)`  - Sets the default meta table for the given type with the table at the stack top. 
  * --这个函数暂时不懂  

 

 

 

   
 