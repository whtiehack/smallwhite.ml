---
title: luaplus 与官方文档慢慢扯(一)
date: 2011-05-07 09:05:00
tags: CSDN迁移
---
   此人文笔很烂 将就看吧

 

 LuaState 是 c++版本的 Lua_State 

 大多数 lua的普通c函数 都基础在 LuaState内

 两者效率相差不大

 

 

 创建 LuaState 实例 

 

 LuaState::Create() 静态函数用于创建一个 LuaState 实例

 此函数有一个可选参数 

 如果为true 则加载lua的标准库 同 luaL_openlibs(L)

 

 LuaState* state = LuaState::Create(); LuaState state = new LuaState(); //销毁方法 LuaState::Destroy(state); //将销毁所有与 LuaState 与 lua相关的东西

 

 

 

 还可以把 现有的 lua_state* 挂接到 LuaPlus

 LuaState* castedState = LuaState::CastState(regular_lua_State); 

 

 `DoFile(const char* fileName) 函数用来执行lua脚本  功能同 lua_dofile()` 

 `LoadFile() 功能同 luaL_loadfile()` 

 需调用 Call or PCall 执行

 

 另外还有 

 `DoString()同 ` DoBuffer() luaL_dostring

 `LoadString() ` LoadBuffer 同 luaL_loadbuffer

 

 DoFile LoadFile DoString LoadString 这些函数 还有带两个参数的重载函数 

 与环境相关的第二个参数 LuaObject

 

 

 `DoWString()` ,  `LoadWString()` ,  `DoWBuffer()` , and  `LoadWBuffer()` . 还另有支持w版本的

 

 

 

 

 

 

 获得指定的全局变量

 LuaObject obj = state->GetGlobal("MyGlobalVariable");  

 

 LuaObject 重载了 [] 操作符 LuaObject::operator[]

 所以

 LuaObject globalsObj = state->GetGlobals(); LuaObject obj = globalsObj["MyGlobalVariable"]; LuaObject obj = state->GetGlobals()["MyGlobalVariable"];  

 

 

 还有另外一组函数 可以获得 stack对象

 LuaStackObject obj1 = state->GetGlobals_Stack(); LuaStackObject obj2 = state->GetGlobal_Stack("MyGlobalVariable"); LuaObject obj = state->GetRegistry(); LuaStackObject obj2 = state->GetRegistry_Stack(); //也可以单独获取指定堆栈位置的对象 LuaStackObject obj = state->Stack(1);  

 

 这几组函数很方便

 当然 还有

 LuaStackObject obj = state->StackTop();  

 

 

 

 

 

 

 

   
 