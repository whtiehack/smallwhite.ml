---
title:  vs2008 编译  luaplus 静态库
date: 2011-05-07 08:17:00
tags: CSDN迁移
---
   转贴地址 [http://www.uipower.com/bbs/viewthread.php?tid=152050](http://www.uipower.com/bbs/viewthread.php?tid=152050)

 

 

 

 


--------
最近在做一个项目,使用lua做脚本, 选luaplus做解析器集成到程序中,上网找 luaplus库都不是最新 ,就到http://luaplus.org/去下载最新   
  
按网站上 说法 安装git 执行以下命令:  
 git clone http://git.luaplus.org/luaplus51-all.git  
  
(下载后文件在"C:/Documents and Settings/Administrator/luaplus51-all")  
  
看文档应该是使用jam去生成VS2008 工程,但是怎么用都生成不了,不知道是怎么回事, 只能是自己建个工程来编译了,过程大致如下:  
  
  
1 打开VS2008新建一个名为LuaPlus51 静态库工程  
 (这里只是仅仅是编译LuaPlus静态库)  
  
2 打开luaplus51-all目录  
 luaplus51-all/Src/LuaPlus 是LuaPlus 源代码  
 luaplus51-all/Src/LuaPlus/src 是Lua 源代码  
   
 这里我们是要编译静态库,所以打开luaplus51-all/Src/LuaPlus/StaticLib/CMakeLists.txt  
 根据CMakeLists.txt中 信息,一步一步完成  
  
 2.1 添加文件到工程:  
   
 将SET(LUAPLUS_SRCS ... )中列出 文件复制到LuaPlus51工程目录中(不要改变src/ 目录结构)  
   
 IF (WIN32)  
SET(LUAPLUS_SRCS ${LUAPLUS_SRCS} ../popen.c)  
 ENDIF (WIN32)  
 如果是WIN32 就将../popen.c也复制到工程中, 大多数都要吧!  
   
 将文件添加到工程 VS2008中, "解决方案资源管理器"选中LuaPlus51->添加->现有项, 将上面 文件选中,添加到工程中!  
  
 2.2 配置工程  
 继续看CMakeLists.txt中 内容  
  
 INCLUDE_DIRECTORIES(../src)  
 将src/目录添加到"附加包含目录"中 ( LuaPlus51->属性->配置属性->C/C++->附加包含目录, debug和release都要,如果想编译两种 )  
 这样在LuaPlus编译过程中就能找到Lua  
  
 IF (MSVC)  
 ADD_DEFINITIONS(-D_CRT_SECURE_NO_DEPRECATE -D_CRT_NONSTDC_NO_DEPRECATE)  
 ENDIF (MSVC)  
  
 将"_CRT_SECURE_NO_DEPRECATE" 和 "_CRT_NONSTDC_NO_DEPRECATE" 预编译宏加入到"预处理器"中 ( LuaPlus51->属性->配置属性->C/C++->预处理器->预处理器定义 )  
  
 ADD_DEFINITIONS(-DLUA_OPNAMES)  
   
 将LUA_OPNAMES预编译宏加入到"预处理器"中  
  
 SET_SOURCE_FILES_PROPERTIES(../LuaObject.inl ../LuaStackObject.inl ../LuaState.inl PROPERTIES HEADER_FILE_ONLY true)  
 不用理  
  
 ADD_LIBRARY(LuaPlusStatic STATIC ${LUAPLUS_SRCS} )  
   
 SET_TARGET_PROPERTIES(LuaPlusStatic PROPERTIES COMPILE_FLAGS "-DLUAPLUS_LIB")  
 将LUAPLUS_LIB预编译宏加入到"预处理器"中  
   
 最后在LuaPlus51->属性->配置属性->常规->MFC 使用 = 在静态库中使用 MFC  
LuaPlus51->属性->配置属性->常规->字符集 = 使用多字节字符集  
   
 编译,如果没有出错就OK了,生成LuaPlus51.lib (我编译 是release版 )  
  
 2.3 使用编译 LuaPlus51.lib  
 2.3.1 提取头文件  
 将LuaPlus51 .h 和 .inl (包括src/中 ) 文件复制到LuaPlus文件夹中(要有维持src 目录结构)  
   
 2.3.2 使用LuaPlus51  
 新建一个win32程序工程test, 将LuaPlus文件夹目录添加到"附加包含目录"中 ( test->属性->配置属性->C/C++->附加包含目录, debug和release都要,如果想编译两种 ), 这样test工程就能找到LuaPlus 头文件  
  
 将LuaPlus51.lib添加到"附加依赖项"中( test->属性->配置属性->连接器->附加依赖项, debug 要使用debug LuaPlus51.lib, release要使用release LuaPlus51.lib )  
   
 都设置好之后就编译连接, 过程中可能会出现连接警告,不用管他, 就可以将LuaPlus完美 集成到程序中(去掉讨厌 dll)  
  
  
该问题搞了好几天,发个方法大家交流一下! 

 

 


--------
   
 