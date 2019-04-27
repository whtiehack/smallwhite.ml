---
title: 用Aheadlib 生成lpk 修改了下
date: 2011-08-18 17:58:14
tags: CSDN迁移
---
   [传送门:AheadLib 2.2.150](http://blog.csdn.net/sunyikuyu/article/details/6179796)  


 [传送门:AheadLib 2.2.150 源码](http://www.yonsm.net/post/162/)  


 

 Aheadlib 默认生成的lpk没办法直接使用 必须修改 

 下面是我参考了一个朋友给我的源 修改而成

 

 

 


```

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 头文件
#include <Windows.h>
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


#pragma comment(linker, "/SECTION:.text,REW" ) //设PE节：.text,可读可执行    貌似是为了那个特殊函数而设置的?
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 导出函数
#pragma comment(linker, "/EXPORT:LpkTabbedTextOut=_AheadLib_LpkTabbedTextOut,@1")
#pragma comment(linker, "/EXPORT:LpkDllInitialize=_AheadLib_LpkDllInitialize,@2")
#pragma comment(linker, "/EXPORT:LpkDrawTextEx=_AheadLib_LpkDrawTextEx,@3")
#pragma comment(linker, "/EXPORT:LpkEditControl=_AheadLib_LpkEditControl,@4")
#pragma comment(linker, "/EXPORT:LpkExtTextOut=_AheadLib_LpkExtTextOut,@5")
#pragma comment(linker, "/EXPORT:LpkGetCharacterPlacement=_AheadLib_LpkGetCharacterPlacement,@6")
#pragma comment(linker, "/EXPORT:LpkGetTextExtentExPoint=_AheadLib_LpkGetTextExtentExPoint,@7")
#pragma comment(linker, "/EXPORT:LpkInitialize=_AheadLib_LpkInitialize,@8")
#pragma comment(linker, "/EXPORT:LpkPSMTextOut=_AheadLib_LpkPSMTextOut,@9")
#pragma comment(linker, "/EXPORT:LpkUseGDIWidthCache=_AheadLib_LpkUseGDIWidthCache,@10")
#pragma comment(linker, "/EXPORT:ftsWordBreak=_AheadLib_ftsWordBreak,@11")
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 宏定义
#define EXTERNC extern "C"
#define NAKED __declspec(naked)
#define EXPORT __declspec(dllexport)

#define ALCPP EXPORT NAKED
#define ALSTD EXTERNC EXPORT NAKED void __stdcall
#define ALCFAST EXTERNC EXPORT NAKED void __fastcall
#define ALCDECL EXTERNC NAKED void __cdecl
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// AheadLib 命名空间
namespace AheadLib
{
	HMODULE m_hModule = NULL;	// 原始模块句柄
	DWORD m_dwReturn[11] = {0};	// 原始函数返回地址

	// 加载原始模块
	inline BOOL WINAPI Load()
	{
		TCHAR tzPath[MAX_PATH];
		TCHAR tzTemp[MAX_PATH * 2];
		GetSystemDirectory((LPSTR)tzPath,MAX_PATH);
		strcat_s(tzPath,"\\lpk.dll");
		m_hModule = LoadLibrary(tzPath);
		if (m_hModule == NULL)
		{
			wsprintf(tzTemp, TEXT("无法加载 %s，程序无法正常运行。"), tzPath);
			MessageBox(NULL, tzTemp, TEXT("AheadLib"), MB_ICONSTOP);
		}

		return (m_hModule != NULL);	
	}
		
	// 释放原始模块
	inline VOID WINAPI Free()
	{
		if (m_hModule)
		{
			FreeLibrary(m_hModule);
		}
	}

	// 获取原始函数地址
	FARPROC WINAPI GetAddress(PCSTR pszProcName)
	{
		FARPROC fpAddress;
		CHAR szProcName[16];
		TCHAR tzTemp[MAX_PATH];

		fpAddress = GetProcAddress(m_hModule, pszProcName);
		if (fpAddress == NULL)
		{
			if (HIWORD(pszProcName) == 0)
			{
				wsprintf(szProcName, "%d", pszProcName);
				pszProcName = szProcName;
			}

			wsprintf(tzTemp, TEXT("无法找到函数 %hs，程序无法正常运行。"), pszProcName);
			MessageBox(NULL, tzTemp, TEXT("AheadLib"), MB_ICONSTOP);
			ExitProcess(-2);
		}

		return fpAddress;
	}
}
using namespace AheadLib;
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
extern "C" {
void	AheadLib_LpkEditControl();
}
BOOL	g_Init=FALSE;
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 入口函数

/***********************************************************
*		创建日期:	2011/08/18	1:47	
*		作    者:	SW
*		备    注:	newl.cpp
*		函数功能:	
*		返 回 值:	
***********************************************************/
BOOL WINAPI InitializeMyData()
{
	BOOL bREt = Load();
	DWORD pLpkEditControl =  (DWORD)GetProcAddress(m_hModule,"LpkEditControl");
	CopyMemory((LPVOID)((DWORD)AheadLib_LpkEditControl-4),(PVOID)((DWORD)pLpkEditControl-4),0x44);

	//初始化放在这里好了
	OutputDebugString("初始化放到这里好了");

	return bREt;
}
BOOL WINAPI DllMain(HMODULE hModule, DWORD dwReason, PVOID pvReserved)
{
	if (dwReason == DLL_PROCESS_ATTACH)
	{
		BOOL bRet =TRUE;
		DisableThreadLibraryCalls(hModule);
		if (g_Init)
		{
			OutputDebugString("DllMain lpk has Initialized");
		}
		else
		{
			g_Init=TRUE;
			OutputDebugString("lpk DllMain  Initialize");
			bRet = InitializeMyData();
		}
		return bRet;
	}
	else if (dwReason == DLL_PROCESS_DETACH)
	{
		Free();
	}

	return TRUE;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 导出函数
ALCDECL AheadLib_LpkTabbedTextOut(void)
{
	// 保存返回地址
	__asm POP m_dwReturn[0 * TYPE long];

	// 调用原始函数
	GetAddress("LpkTabbedTextOut")();

	// 转跳到返回地址
	__asm JMP m_dwReturn[0 * TYPE long];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 导出函数
ALCDECL AheadLib_LpkDllInitialize(void)
{
	// 保存返回地址
	__asm POP m_dwReturn[1 * TYPE long];
//	OutputDebugString("AheadLib_LpkDllInitialize");
	// 调用原始函数
	GetAddress("LpkDllInitialize")();

	// 转跳到返回地址
	__asm JMP m_dwReturn[1 * TYPE long];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 导出函数
ALCDECL AheadLib_LpkDrawTextEx(void)
{

	// 保存返回地址
	__asm POP m_dwReturn[2 * TYPE long];

	// 调用原始函数
	GetAddress("LpkDrawTextEx")();

	// 转跳到返回地址
	__asm JMP m_dwReturn[2 * TYPE long];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



extern "C" {
	__declspec(naked) void	AheadLib_LpkEditControl()
	{
		__asm nop	__asm nop	__asm nop		__asm nop		__asm nop		__asm nop		__asm nop		__asm nop
		__asm nop		__asm nop		__asm nop		__asm nop	__asm nop
		__asm nop
		__asm nop
		__asm nop
		__asm nop
		__asm nop
		__asm nop
		__asm nop

		__asm nop
		__asm nop
		__asm nop
		__asm nop

		__asm nop
		__asm nop
		__asm nop
		__asm nop

		__asm nop
		__asm nop
		__asm nop
		__asm nop

		__asm nop
		__asm nop
		__asm nop
		__asm nop

		__asm nop
		__asm nop
		__asm nop
		__asm nop

		__asm nop
		__asm nop
		__asm nop
		__asm nop

		__asm nop
		__asm nop
		__asm nop
		__asm nop

		__asm nop
		__asm nop
		__asm nop
		__asm nop

		__asm nop
		__asm nop
		__asm nop
		__asm nop

		__asm nop
		__asm nop
		__asm nop
		__asm nop

		__asm _emit 0
		__asm _emit 0
		__asm _emit 0
		__asm _emit 0
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 导出函数
// ALCDECL AheadLib_LpkEditControl(void)
// {

// 	// 保存返回地址
// 	__asm POP m_dwReturn[3 * TYPE long];
// 
// 	// 调用原始函数
// 	GetAddress("LpkEditControl")();
// 
// 	// 转跳到返回地址
// 	__asm JMP m_dwReturn[3 * TYPE long];
// }
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 导出函数
ALCDECL AheadLib_LpkExtTextOut(void)
{

	// 保存返回地址
	__asm POP m_dwReturn[4 * TYPE long];

	// 调用原始函数
	GetAddress("LpkExtTextOut")();

	// 转跳到返回地址
	__asm JMP m_dwReturn[4 * TYPE long];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 导出函数
ALCDECL AheadLib_LpkGetCharacterPlacement(void)
{

	// 保存返回地址
	__asm POP m_dwReturn[5 * TYPE long];

	// 调用原始函数
	GetAddress("LpkGetCharacterPlacement")();

	// 转跳到返回地址
	__asm JMP m_dwReturn[5 * TYPE long];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 导出函数
ALCDECL AheadLib_LpkGetTextExtentExPoint(void)
{

	// 保存返回地址
	__asm POP m_dwReturn[6 * TYPE long];

	// 调用原始函数
	GetAddress("LpkGetTextExtentExPoint")();

	// 转跳到返回地址
	__asm JMP m_dwReturn[6 * TYPE long];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 导出函数
ALCDECL AheadLib_LpkInitialize(void)
{
	// 保存返回地址
	__asm POP m_dwReturn[7 * TYPE long];
	if (!g_Init)	//这个函数可能会优于 dllmain 被调用 so...
	{
		OutputDebugString("LpkInitialize Initialize");
		g_Init=TRUE;
		if (!InitializeMyData())
		{
			MessageBox(0,"lpk Initialize Failure!","error",0);
			ExitProcess(EXIT_FAILURE);
		}
	}
	// 调用原始函数
	GetAddress("LpkInitialize")();

	// 转跳到返回地址
	__asm JMP m_dwReturn[7 * TYPE long];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 导出函数
ALCDECL AheadLib_LpkPSMTextOut(void)
{

	// 保存返回地址
	__asm POP m_dwReturn[8 * TYPE long];

	// 调用原始函数
	GetAddress("LpkPSMTextOut")();

	// 转跳到返回地址
	__asm JMP m_dwReturn[8 * TYPE long];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 导出函数
ALCDECL AheadLib_LpkUseGDIWidthCache(void)
{

	// 保存返回地址
	__asm POP m_dwReturn[9 * TYPE long];

	// 调用原始函数
	GetAddress("LpkUseGDIWidthCache")();

	// 转跳到返回地址
	__asm JMP m_dwReturn[9 * TYPE long];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 导出函数
ALCDECL AheadLib_ftsWordBreak(void)
{

	// 保存返回地址
	__asm POP m_dwReturn[10 * TYPE long];

	// 调用原始函数
	GetAddress("ftsWordBreak")();

	// 转跳到返回地址
	__asm JMP m_dwReturn[10 * TYPE long];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

```
  
  


   
 