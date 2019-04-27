---
title: luaplus 与官方文档慢慢扯(五)
date: 2011-05-08 02:19:00
tags: CSDN迁移
---
   ### Registering Callbacks(注册lua c函数)

 函数原型

 int Callback(LuaState* state);  

 

 作为一种替代机制 lua stack 是通过LuaStack类提供的

 LuaPlus的回调函数使用了一种简单的函数机制 可以让全局函数 静态函数 非虚成员函数 与虚成员函数 成为回调函数

 

 下面是一个示例 例子很简单就不注释了 (唯一需要注意的是 LuaStack args(state);)

 static int LS_LOG(LuaState* state) { printf("In static function/n"); return 0; } class Logger { public: int LS_LOGMEMBER(LuaState* state) { LuaStack args(state);//需要注意这里哦 printf("In member function. Message: %s/n", args[1].GetString()); return 0; } virtual int LS_LOGVIRTUAL(LuaState* state) { printf("In virtual member function/n"); return 0; } }; LuaObject globalsObj = state->GetGlobals(); globalsObj.Register("LOG", LS_LOG); state->DoString("LOG()"); Logger logger; globalsObj.Register("LOGMEMBER", logger, &Logger::LS_LOGMEMBER); state->DoString("LOGMEMBER('The message')"); globalsObj.Register("LOGVIRTUAL", logger, &Logger::LS_LOGVIRTUAL); state->DoString("LOGVIRTUAL()");  

 

 使用 Register() 函数注册回调函数.

 LuaObject 提供了几种重载的 Register() 函数:

 void Register( const char* funcName, lua_CFunction function, int nupvalues = 0 ); void Register( const char* funcName, int (*func)(LuaState*), int nupvalues = 0 ); void Register( const char* funcName, const Callee& callee, int (Callee::*func)(LuaState*), int nupvalues = 0 );  

 

 

 
### Registering Object Dispatch Functors(注册一个c++类到lua)

 虽然Register() 可以注册 c++类成员函数 但是他的第二个参数需要提供一个类对象 

 但是内部调用成员函数时候 this指针是一个常量 所以 Register()函数不是适合镜像c++类到lua中

 

 this指针的问题 是通过 RegisterObjectFunctor() 函数解决的

 官方文档原文

 

 
--------
Even though  `Register()`  can dispatch to C++ member functions, it uses a 'this' pointer as provided by the second argument passed to the function. The 'this' pointer is constant, and  `Register()`  is not suited for mirroring class hierarchies in Lua.

 The solution to the 'this' pointer issue is through  `RegisterObjectFunctor()` . It is a specialized form of  `Register()`  where a 'this' pointer isn't provided during the closure registration. Instead, it is retrieved from either the calling userdata or the calling table's  `__object`  member, which must be a full or light userdata.

 
--------


 下面 是实现2个c++类到lua的例子

 class MultiObject { public: MultiObject(int num) : m_num(num) { } int Print(LuaState* state) { printf("%d/n", m_num); return 0; } void Print2(int num) { printf("%d %d/n", m_num, num); } protected: int m_num; }; //注册一个metatable LuaObject metaTableObj = state->GetGlobals().CreateTable("MultiObjectMetaTable"); metaTableObj.SetObject("__index", metaTableObj);//设置metatable是他自己 metaTableObj.RegisterObjectFunctor("Print", &MultiObject::Print);//在table内注册一个 print函数 //现在 我们在lua内实现两个对象 obj1 obj2 MultiObject obj1(10); LuaObject obj1Obj = state->BoxPointer(&obj1); obj1Obj.SetMetaTable(metaTableObj); state->GetGlobals().SetObject("obj1", obj1Obj); MultiObject obj2(20); LuaObject obj2Obj = state->BoxPointer(&obj2); obj2Obj.SetMetaTable(metaTableObj); state->GetGlobals().SetObject("obj2", obj2Obj); //两个c++对象已经设置好了 现在测试下 state->DoString("obj1:Print() ; print(obj1)"); state->DoString("obj2:Print() ; print(obj2)"); // 10 // userdata: 002EB940 // 20 // userdata: 002EB9D0 

 

 

 上面的obj1 和 obj2 是作为  userdata 然后设置它的metatables 的方法创建的   
 另一种方法是将代表的c++对象的tuserdata作为表的成员 __object  
 LuaObject table1Obj = state->GetGlobals().CreateTable("table1"); table1Obj.SetLightUserData("__object", &obj1); table1Obj.SetMetaTable(metaTableObj); LuaObject table2Obj = state->GetGlobals().CreateTable("table2"); table2Obj.SetLightUserData("__object", &obj2); table2Obj.SetMetaTable(metaTableObj); state->DoString("table1:Print()"); state->DoString("table2:Print()");    
 

 

 
### Registering Functions Directly(直接注册普通函数)

 LuaPlus通过RegisterDirect() 可以直接注册c++函数

 float Add(float num1, float num2) { return num1 + num2; } LuaStateOwner state; state->GetGlobals().RegisterDirect("Add", Add); state->DoString("print(Add(10, 5))");  

 以这种方式注册的函数 函数可以是任何形式的 内部会自动进行函数参数的类型检查

 如果lua调用函数 传入的参数无效 则触发 luaL_argassert 导致调用失败

 例如 state->DoString("print(Add(10, 'Hello'))"); 这样就导致失败了

 

 全局函数可以这样注册 而成员函数也同样可以这样注册

 void LOG(const char* message) { printf("In global function: %s/n", message); } class Logger { public: void LOGMEMBER(const char* message) { printf("In member function: /n", message); } virtual void LOGVIRTUAL(const char* message) { printf("In virtual member function: %s/n", message); } }; LuaObject globalsObj = state->GetGlobals(); globalsObj.RegisterDirect("LOG", LOG); Logger logger; globalsObj.RegisterDirect("LOGMEMBER", logger, &Logger::LOGMEMBER); globalsObj.RegisterDirect("LOGVIRTUAL", logger, &Logger::LOGVIRTUAL); state->DoString("LOG('Hello')"); state->DoString("LOGMEMBER('Hello')"); state->DoString("LOGVIRTUAL('Hello')");  

 直接注册的函数在目前版本中最多只支持7个参数

 

 

 

 
### Object Dispatch to Directly Called C++ Member Functions(注册普通c++成员函数)

 官方文档原文

 
--------
Even though  `RegisterDirect()`  can dispatch directly to C++ member functions, it uses a 'this' pointer as provided by the second argument passed to the function. The 'this' pointer is constant, and  `RegisterDirect()`  is not suited for mirroring class hierarchies in Lua. 

 The solution to the 'this' pointer issue is through  `RegisterObjectDirect()` . It is a specialized form of RegisterDirect() where a 'this' pointer isn't provided during the closure registration. Instead, it is retrieved from either the calling userdata or the calling table's  `__object`  member, which must be a full or light userdata. The techniques presented in this section mirror closely the  `RegisterObjectFunctor()`  description above.

 
--------


 使用上一个注册c++对象的那个示例 

 向metatable内直接注册普通的c++成员函数

 metaTableObj.RegisterObjectDirect("Print2", (MultiObject*)0, &MultiObject::Print2);  

 测试

 state->DoString("obj1:Print2(5)"); state->DoString("obj2:Print2(15)"); state->DoString("table1:Print2(5)"); state->DoString("table2:Print2(15)");   

 

 

 


### Unregistering Callbacks(撤销已经注册到lua内的对象)

 注销回调非常简单 只需将其设置为nil

 


```
globalsObj.SetNil("LOG");
```
 
```

```
 
```

```

### 

 

   
 