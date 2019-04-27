---
title: LuaPlus 载入指定库的方法
date: 2011-05-13 17:17:00
tags: CSDN迁移
---
   默认情况下

 

 LuaState* state = LuaState::Create(true);

 是载入了所有基础库

 LuaState* state = LuaState::Create();

 这样就什么库都不载入 不过..连基础库都没了...

 

 

 可是 一般情况下又不需要这么多库 

 所以 改下 luaplus.h 头文件

 

 

LUA_EXTERN_C_BEGIN

 #include "src/lua.h"

 #include "src/lauxlib.h"

 #include "src/lualib.h" //增加这一句即可

 LUA_EXTERN_C_END

   
   
 LuaState* state = LuaState::Create();  
 state->DoString("print(555)");  
 luaopen_base(state->GetCState()); //这样就可以载入指定的库了  
 state->DoString("print(555)");  
   
 附上库  
   
   
 static const luaL_Reg lualibs[] = {  
 {"", luaopen_base},  
 {LUA_LOADLIBNAME, luaopen_package},  
 {LUA_TABLIBNAME, luaopen_table},  
 {LUA_IOLIBNAME, luaopen_io},  
 {LUA_OSLIBNAME, luaopen_os},  
 {LUA_STRLIBNAME, luaopen_string},  
 {LUA_MATHLIBNAME, luaopen_math},  
 {LUA_DBLIBNAME, luaopen_debug},  
 #if LUA_WIDESTRING  
 {LUA_WSTRLIBNAME, luaopen_wstring},  
 #endif /* LUA_WIDESTRING */  
 {NULL, NULL}  
 };  
   
   
   
 