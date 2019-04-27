---
title: luaplus 与官方文档慢慢扯(七)
date: 2011-05-08 03:29:00
tags: CSDN迁移
---
   ## Class: LuaTableIterator(lua table 迭代类 )

 LuaPlus 提供了一个名为 LuaTableIterator 的类

 他的作用是让我们在c++内遍历lua table时比使用标准lua CAPI更简单 方便 也更安全

 (The iterator is not STL compliant in its current form.)

 使用起来真的非常简单

 LuaStateOwner state; state->DoString( "MyTable = { Hi = 5, Hello = 10, Yo = 6 }" ); LuaObject obj = state->GetGlobals()[ "MyTable" ]; for ( LuaTableIterator it( obj ); it; it.Next() ) { const char* key = it.GetKey().GetString(); int num = it.GetValue().GetInteger(); printf("%s=%d/n",key,num); } // Hello=10 // Hi=5 // Yo=6 

 

 

 
## Class: LuaStackObject

 

 
--------


 

 

 LuaPlus does not use integers to represent stack objects. Instead, those stack indices are wrapped in a  `LuaStackObject` .  `LuaStackObjects`  can be passed directly to a Lua C function, if needed, but it is advised to go through the LuaPlus version of the function.

 Using a  `LuaObject`  is usually the better way to go, since a  `LuaObject`  relieves the user of any stack management at all.  `LuaStackObjects`  are available for use in callback functions or in special case stack management scenarios.

 `LuaStackObjects`  also store a pointer to the parent  `LuaState` . In part, this is what makes the _LuaWatchAddin_ work. Most importantly,  `LuaStackObjects`  can just be passed around without any regard for the  `LuaState`  they came from.

 Most  `LuaStackObject`  functions mirror  `LuaObject`  functions of the same name, so see the section above for more detail.

 
  * Push()/Pop().  

 

 
--------


 

 

 
## Class: LuaRefObject

 

 (使用了LuaObject类 没有必要再使用这个类了)

 

 
--------
LuaPlus enhances the Lua ref table facility by allowing ref'ed objects to be used without using  `GetRef()`  to push them onto the stack.  `LuaRefObject`  encapsulates this new functionality. Assigning a  `LuaObject`  (or another  `LuaRefObject` ) to a  `LuaRefObject`  instance will cause a  `lua_ref()`  to occur. When the  `LuaRefObject`  goes out of scope,  `lua_unref()`  is called.  `LuaRefObject`  is derived from  `LuaObject`  and can operate on ref'ed objects without issue.

 The _LuaWatchAddin_ displays the contents of  `LuaRefObjects` .

 
--------


 

 
--------

## Class: LuaStackTableIterator

 A  `LuaStackTableIterator`  is almost identical to the  `LuaTableIterator`  above, except it provides support for iterating using the stack, similar to how core Lua does it.

 `LuaStackTableIterator`  is fully documented in  `LuaPlus.h` .

 
--------


 

 

 


## Class: LuaAutoBlock(使用了 LuaObject 同样没有必要再使用此类)

 也就是很少使用到这个类 不过如果涉及到 堆栈操作 最好使用此类保护堆栈

 Nothing can be more frustrating than paying attention to stack management. Which function allocates which entry on the stack? How many entries? Did it get popped? Where is that stack leak at?  `LuaAutoBlock`  serves as a fairly useful approach to solving these problems.

 `LuaAutoBlock`  is a C++ class whose constructor stores the index of the stack top. At destruction time, it sets the stack top to the stored index. By providing this functionality as an object, the stack is guaranteed to be restored, regardless of exit points from a function or loop block.

 _Note: When using the LuaObject class, there is no need to worry about stack management, and so LuaAutoBlock provides no benefits in that situation._

 
```
{ LuaAutoBlock autoBlock(state); LuaStackObject testObj = state->GetGlobals_Stack()["Test"]; // Does this allocate a stack item? state->PushString["A string"]; // Does this? testObj.SetNumber("Value", 5); // Does this? // Who cares? LuaAutoBlock automatically cleans it up. }
```
 

 

 


## Class: LuaStateOutFile 

 `LuaStateOutFile`  and derived classes are used in conjunction with  `LuaState::DumpObject()` . When a  `LuaStateOutFile`  object is passed to  `DumpObject()` , that object is used for writing the Lua dump file. The application can derive from  `LuaStateOutFile`  to change the default dumping behavior.

 

 

 


## Namespace: LuaPlus::LuaHelper

 The LuaHelper namespace contains some useful helper functions for retrieving values from LuaObjects. The helper functions perform a lookup into a table for a certain key. If the key is required to be found and is not present, an assertion is triggered. Otherwise, the found value or a default value is returned.

 The following helper functions are available:

 
  * `GetBoolean()`   
  * `GetFloat()`   
  * `GetLightUserData()`   
  * `GetString()`   
  * `GetTable()`   

 

   
 