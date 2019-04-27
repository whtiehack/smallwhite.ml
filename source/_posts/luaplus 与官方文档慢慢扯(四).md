---
title: luaplus 与官方文档慢慢扯(四)
date: 2011-05-08 00:39:00
tags: CSDN迁移
---
   ### Value Storage(值储存? 与lua交换值)

 

 一般使用lua c api push* 来把值压入堆栈

 LuaObjects 提供了另一种实现 它不是基于堆栈的 (具体如何使用 暂时不懂 以后再回头看)

 使用Assign*()系列函数 把值分发进LuaObject 

 下面是 Assign*系列函数

 

 
  * `AssignNil(LuaState* state)`   
  * `AssignBoolean(LuaState* state, bool value)`   
  * `AssignInteger(LuaState* state, int value)`   
  * `AssignNumber(LuaState* state, double value)`   
  * `AssignString(LuaState* state, const char* value)`   
  * `AssignWString(LuaState* state, const lua_WChar* value)`   
  * `AssignUserData(LuaState* state, void* value)`   
  * `AssignLightUserData(LuaState* state, void* value)`   
  * `AssignObject(LuaState* state, LuaObject& value)`   
  * `AssignNewTable(LuaState* state, int narray = 0, int nhash = 0)`   

 LuaObject strObj; strObj.AssignString(state, "Hello, world!"); //把一个字符串分配进 LuaObject 

 

 

 

 

 
### Table Creation(创建table)

 两种方法创建table

 第一种方法

 使用 CreateTable() 函数 CreateTable()类似于 Set*()函数

 在全局范围内创建一个空表 参数是这个表的 key名

 

 第二种方法 是使用 LuaObject 调用AssignNewTable() 在当前的 LuaObject中创建一个空表

 //方法一 LuaObject globalsObj = state->GetGlobals(); LuaObject myArrayOfStuffTableObj = globalsObj.CreateTable("MyArrayOfStuff"); //方法二 LuaObject aStandaloneTableObj; aStandaloneTableObj.AssignNewTable(state); 

 

 

 

 当LuaObject 是一个表 就可以使用操作表的函数 

 有以下几个函数用来获取表成员数

 这里有一个表

 

 
```
MyTable = { WindSpeed = 50, Value = 'Hello', 10, 20, 30 }
```
 
```
调用 GetN() 返回3 GetN()内部使用的是 table.getn() 来获取表成员数
```
 
```
table.getn()只计算从 key 1开始的连续以数值作为key的成员
```
 
```
GetCount() 也是从key 1开始计算数量 不过它的执行速度更快
```
 
```
 GetTableCount() 函数则返回table内的所有元素数量 对 MyTable而言 它返回5
```
 
```

```
 
```

```
 
```

```
 
```

```

### Table Data Lookups(表数据操作)

当 LuaObject 是一个表的时候 操作table的 函数将可用 如果 LuaObject不是table时,调用了操作表函数将触发 assert  
`operator[]运算符 被重载   它接受一些常量作为参数  const char *, int ,	` LuaStackObject 或者LuaObject  
使用operator[] 的话 代码看起来像是lua脚本代码  
  
例子:  
//lua创建一个table state->DoString("MyTable = { WindSpeed = 50, Value = 'Hello', 10, 20, 30 }"); //获取这个table LuaObject myTableObj = state->GetGlobals()["MyTable"]; //获取table的成员 字符串作为key LuaObject windSpeedObj = myTableObj["WindSpeed"]; //获取table的成员 数值作为key LuaObject is20Obj = myTableObj[2]; //下面这个方法很神奇呀 LuaObject keyObj; keyObj.AssignString(state, "Value");//把字符串"Value"分派到 LuaObject对象内 LuaObject valueObj = myTableObj[keyObj];//使用 LuaObject 获取MyTable的成员 LuaObject svalue=myTableObj.GetByName("Value");//不使用 operate [] 使用函数获取 Value成员 //输出结果看看 printf("MyTable.WindSpeed:%d MyTable[2]:%d MyTable.Value=%s MyTable.Value:%s/n", windSpeedObj.GetInteger(),is20Obj.GetInteger(),valueObj.GetString(),svalue.GetString()); printf("keyobj:%s/n",keyObj.GetString());//很神奇 --> keyobj:Value //-->MyTable.WindSpeed:50 MyTable[2]:20 MyTable.Value=Hello MyTable.Value:Hello //-->keyobj:Value  
不使用 operate [] 重载运算符 内部使用的函数  
`GetByName(const char* key)`   `GetByIndex(int index)`   `GetByObject(const LuaObject& obj)`   `GetByObject(const LuaStackObject& obj)`   
 

 

 
### Table Data Storage(table数据储存 ?)

 LuaObject 对表操的作 通过 Set*()一系列函数实现

 而每一种 Set*()函数 都有3个重载函数 

 Set*()系列函数 的第一个参数是key key可以是 const char * ,int 和 LuaObject

 下面是Set*()系列函数

 

   `SetNil(key)`   `SetBoolean(key, bool value)`   `SetInteger(key, int value)`   `SetNumber(key, double value)`   `SetString(key, const char* value)`   `SetWString(key, const lua_WChar* value)`   `SetUserData(key, void* value)`   `SetLightUserData(key, void* value)`   `SetObject(key, LuaObject& value)`   

 

 每个 Set*() 函数返回当前对象的引用,所以在单个语句中可以出现多个 Set*() 函数

 

 例子:  
 LuaObject tableObj; tableObj.AssignNewTable(state);//创建一个表 tableObj.SetString("MyKey", "Hello, world!");//设置这个表 的 key "MyKey"的值为 "Hello, world!" state->GetGlobals().SetObject("mytable",tableObj);//把这个table 保存为全局变量 mytable LuaObject globalsObj = state->GetGlobals(); globalsObj.SetBoolean("InUse", true).SetNumber(5, 2000); state->DoString("print(mytable.MyKey,InUse,_G[5])"); //-->Hello, world! true 2000    
   
 ### Table Data Lookups(表数据查找)

   
 Lookup() 函数提供了一种简单的方法递归查找指定表项,它的字符串参数接受以 .分隔表示的table  
 还是上面的例子  
 LuaObject tableObj; tableObj.AssignNewTable(state);//创建一个表 tableObj.SetString("MyKey", "Hello, world!");//设置这个表 的 key "MyKey"的值为 "Hello, world!" state->GetGlobals().SetObject("mytable",tableObj);//把这个table 保存为全局变量 mytable LuaObject globalsObj = state->GetGlobals(); LuaObject valueObj = globalsObj.Lookup("mytable.MyKey"); printf("mytable.MyKey:%s TypeName:%s/n", valueObj.GetString(),valueObj.TypeName()); //-->mytable.MyKey:Hello, world! TypeName:string    
   
   
   
 ### Table Manipulation(对表的操作)

 

 一些对表的插入 移除 排序等操作 简单的封装在了 LuaObject 

 现在已有的函数 Insert() ( table.insert), Remove() (table.remove), and Sort() (table.sort)

 

 

 

 
### Cloning Objects(复制Object对象)

 LuaObject 提供了一个方法 Clone() 允许简单的复制 LuaObject

 对于lua的表 执行深度复制 对于其他任何值 执行简单复制 

 一般情况下够用了

 Clone()并不处理循环的表 如果对循环的表执行 Clone() 可能导致内存不足或者堆栈溢出 

 

 

 
### Comparing Objects(Object比较)

 可以通过 == 和 < 操作符 比较两个对象 

 

 内部的比较是通过 lua_equal() 和 lua_lessthan()函数实现的   
   


 

 

 

 

 
### Implicit Conversion Between LuaStackObject and LuaObject(LuaObject 和 LuaStackObject的隐式转换)

 

 很多时候 需要访问lua堆栈上的对象

 例如 回调函数收到一个LuaStackObjects 数组 

 在写代码时 LuaStackObject 和LuaObject 的方法非常的相似  

 然而 LuaObjects 对象可以不用考虑堆栈 所以 两个对象间的转换还是有点必要的

 例:

 LuaStackObject stack1Obj(state, 1);//创建 LuaStackObject 对象 当前堆栈上的第一个值 LuaStackObject stack2Obj(state, 2);//创建 LuaStackObject 对象 当前堆栈上的第二个值 //LuaObject 和 LuaStackObject的隐式转换 LuaObject nonStack1Obj(stack1Obj); // 或者直接 LuaObject nonStack2Obj = stack2Obj;  

 

 

 
### Pushing a LuaObject onto the Lua Stack(把LuaObject 放入 Lua堆栈)

 一般情况下 把 LuaObject放入 lua堆栈是很罕见的

 虽然如此 还是可以通过 Push() 函数 把LuaObject放入lua堆栈

 LuaObject tableObj;//创建一个 LuaObject对象 tableObj.AssignNewTable(state); tableObj.SetString("Key", "My String"); // 这样就可以把该table放入lua堆栈了 tableObj.Push(); // 但是记得一定要清理 //不过 作为lua c函数的话 return 1;//可以作为返回值 

 

 

 

   
   
 