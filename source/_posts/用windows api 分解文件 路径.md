---
title: 用windows api 分解文件 路径
date: 2011-01-08 16:25:00
tags: CSDN迁移
---
   #include <stdio.h> #include <Windows.h> #include <wchar.h> #include <stdlib.h> #include <locale> int main() { setlocale(LC_CTYPE, "");//让wprintf 支持中文 LPTSTR szfileName = new TCHAR[MAX_PATH]; GetModuleFileName(NULL, szfileName , MAX_PATH); // 获取盘符、文件名、扩展名等信息 wchar_t drive[_MAX_DRIVE]; wchar_t dir[_MAX_DIR]; wchar_t fname[_MAX_FNAME]; wchar_t ext[_MAX_EXT]; errno_t err; //_tsplitpath err = ::_wsplitpath_s(szfileName, drive, _MAX_DRIVE, dir, _MAX_DIR, fname, _MAX_FNAME, ext, _MAX_EXT); wprintf(L"%s/r/n%s %s %s %s", szfileName,drive,dir,fname,ext ); // 只获取路径 // PathRemoveFileSpec(szfileName); // _wsplitpath_s() 在stdlib.h中。 // PathRemoveFileSpec() 函数在shlwapi.h中。 return 0; } 

   
 