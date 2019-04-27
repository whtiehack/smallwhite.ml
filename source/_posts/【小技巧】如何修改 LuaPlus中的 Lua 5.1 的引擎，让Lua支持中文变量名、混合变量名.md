---
title: 【小技巧】如何修改 LuaPlus中的 Lua 5.1 的引擎，让Lua支持中文变量名、混合变量名
date: 2011-05-12 07:11:00
tags: CSDN迁移
---
   原贴

 [http://blog.csdn.net/chrisxie/archive/2008/09/29/2998290.aspx](http://blog.csdn.net/chrisxie/archive/2008/09/29/2998290.aspx)

 (原贴中的luaplus是老版本 下面我贴的代码是新版的)

 
--------

--------


 

 最近在倒腾 Lua 脚本引擎。Lua 现在广泛用于各种游戏、PSP中，速度极快，与 C++ 宿主代码“相处”能力强，还有第三方增强工程如 LuaPlus， LuaBind 等的支持，笔者正是在使用 LuaPlus 这个不错的 Lua C++ 封装，内置 Lua 5.1 引擎。  
   
 Lua 本身不能支持中文变量名或函数名，作为想尽善尽美的支持脚本的软件来说，当然不爽啦。从网上搜到了一些代码，能够修改老版本的 Lua 核心使得 Lua 支持中文变量名，如：价格=45 之类，但 Lua 5.1 的核心代码已经略有不同了。当然只要稍微作些改动，就能让 Lua 5.1 乖乖的也认识起中文变量名、函数名来。

   
 以 LuaPlus 为例（Visual Studio 2005 IDE环境下）：  
   
 1. 找到 LuaPlus 工程下的 Lua Source Files 下的 llex.c；  
   
 2. 在该文件中找到下面所列函数；  
 static int llex (LexState *ls, SemInfo *seminfo)  
 3. 这是 Lua 的语法分析模块的关键函数，它由一长段 switch 构成，在一串 case 后找到 default 分支  
   
 4. 在该分支下找到如下代码段，这是一段完整的 if 分支，该代码段负责将符合条件的字符组合识别为 identifier （函数名或变量名）或 keyword （关键字）  
 else if (isalpha(ls->current) || ls->current == '_') {//支持中文 #if LUA_WIDESTRING TString *ts; if (ls->current == 'L') { next(ls); if (ls->current == '"' || ls->current == '/'') { read_wstring(ls, ls->current, seminfo); return TK_WSTRING; } save(ls, 'L'); goto afterchar; } /* identifier or reserved word */ #else /* identifier or reserved word */ TString *ts; #endif /* LUA_WIDESTRING */ do { save_and_next(ls); #if LUA_WIDESTRING afterchar: ; #endif } while (isalnum(ls->current) || ls->current == '_' ); ts = luaX_newstring(ls, luaZ_buffer(ls->buff), luaZ_bufflen(ls->buff)); if (ts->tsv.reserved > 0) /* reserved word? */ return ts->tsv.reserved - 1 + FIRST_RESERVED; else { seminfo->ts = ts; return TK_NAME; } }   
 修改为  
 else if (isalpha(ls->current) || ls->current == '_'|| ls->current > 0x80) {//支持中文 增加 || ls->current > 0x80 #if LUA_WIDESTRING TString *ts; if (ls->current == 'L') { next(ls); if (ls->current == '"' || ls->current == '/'') { read_wstring(ls, ls->current, seminfo); return TK_WSTRING; } save(ls, 'L'); goto afterchar; } /* identifier or reserved word */ #else /* identifier or reserved word */ TString *ts; #endif /* LUA_WIDESTRING */ do { if(ls->current > 0x80)//单独判断 if () else 增加 { save_and_next(ls); save_and_next(ls); } else save_and_next(ls); #if LUA_WIDESTRING afterchar: ; #endif } while (isalnum(ls->current) || ls->current == '_' || ls->current > 0x80);//增加部分 ts = luaX_newstring(ls, luaZ_buffer(ls->buff), luaZ_bufflen(ls->buff)); if (ts->tsv.reserved > 0) /* reserved word? */ return ts->tsv.reserved - 1 + FIRST_RESERVED; else { seminfo->ts = ts; return TK_NAME; } }   
 

   
 