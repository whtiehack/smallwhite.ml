---
title: spy4win 插件 显示隐藏窗口并突破灰色按钮
date: 2011-03-07 03:00:00
tags: CSDN迁移
---
   spy4win没有这个小功能 所以写个小插件

 

 

 #include <windows.h> BOOL WINAPI DllMain(HINSTANCE hinstDLL, DWORD fdwReason, LPVOID lpvReserved) { switch(fdwReason) { case DLL_PROCESS_ATTACH: case DLL_THREAD_ATTACH: case DLL_THREAD_DETACH: case DLL_PROCESS_DETACH: break; } return TRUE; } static LPSTR g_lpPluginName = "显示隐藏窗口并突破灰色按钮"; // 通过传递过来的hDstWin句柄对该窗口进行操作 // hMainWin: Spy4Win主窗体句柄, 可用可不用 // hDstWin: 目标窗口句柄 // lpReserved: 保留 BOOL CALLBACK EnumChildProc( HWND hwnd, LPARAM lParam ) { ShowWindow(hwnd,SW_SHOW); EnableWindow(hwnd,TRUE); return TRUE;//不停枚举 } extern "C" __declspec( dllexport ) DWORD MyDoJob(HWND hMainWin, HWND hDstWin, LPVOID lpReserved) { if(IsWindow(hDstWin)) { // MessageBox(hMainWin, "点击确定以后隐藏目标窗口", // g_lpPluginName, MB_OK | MB_ICONINFORMATION); // ShowWindow(hDstWin, false); // MessageBox(hMainWin, "点击确定以后显示目标窗口", // g_lpPluginName, MB_OK | MB_ICONINFORMATION); // ShowWindow(hDstWin, true); //枚举所有子窗口 显示窗口并且设置为可用 ShowWindow(hDstWin,SW_SHOW); EnableWindow(hDstWin,TRUE);//先启用并显示目标窗口 EnumChildWindows(hDstWin,EnumChildProc,NULL);//枚举所有目标窗口的子窗口 return 1; } else { MessageBox(hMainWin, "当前没有选择窗口或该窗口句柄已失效。", g_lpPluginName, MB_OK | MB_ICONINFORMATION); return 0; } } // 获取插件名字 extern "C" __declspec( dllexport ) LPSTR MyLoadPluginName() { return g_lpPluginName; } 

   
 