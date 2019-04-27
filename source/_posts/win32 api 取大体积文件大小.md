---
title: win32 api 取大体积文件大小
date: 2011-01-08 18:13:00
tags: CSDN迁移
---
   又是剽窃核心编程..

 #include <stdio.h> #include <Windows.h> #include <tchar.h> #include <locale> int main() { //取文件大小 _tsetlocale(LC_CTYPE,TEXT("")); DWORD dwSizeHigh; DWORD dwSizeLow=GetCompressedFileSize(TEXT("E://Virtual Machines//Windows XP Professional//Windows XP Professional.vmdk"), &dwSizeHigh); _tprintf(TEXT("size:%I64d/n"),dwSizeLow,dwSizeHigh); _tsystem(TEXT("pause")); return 0; } 

 

   
 