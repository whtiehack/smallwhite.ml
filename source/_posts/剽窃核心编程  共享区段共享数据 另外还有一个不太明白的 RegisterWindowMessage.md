---
title: 剽窃核心编程  共享区段共享数据 另外还有一个不太明白的 RegisterWindowMessage
date: 2011-01-21 23:27:00
tags: CSDN迁移
---
   g_uMsgAppInstCountUpdate =

 RegisterWindowMessage(TEXT("MsgAppInstCountUpdate"));//注册一个消息

   
 PostMessage(HWND_BROADCAST, g_uMsgAppInstCountUpdate, 0, 0);  
   
 让我觉得非常神奇  
 

 /****************************************************************************** Module: AppInst.cpp Notices: Copyright (c) 2008 Jeffrey Richter & Christophe Nasarre ******************************************************************************/ #include "../CommonFiles/CmnHdr.h" /* See Appendix A. */ #include <windowsx.h> #include <tchar.h> #include "Resource.h" /////////////////////////////////////////////////////////////////////////////// // The system-wide window message, unique to the application UINT g_uMsgAppInstCountUpdate = WM_APP+123; /////////////////////////////////////////////////////////////////////////////// // Tell the compiler to put this initialized variable in its own Shared section so it is shared by all instances of this application. //告诉编译器 把这个已初始化的变量放到 Shared 区段内 #pragma data_seg("Shared") volatile LONG g_lApplicationInstances = 0;//volatile 修饰符 告诉编译器不要对该变量做任何优化 #pragma data_seg()//这一句告诉编译器 到此为止! 吧中间的[已]初始化变量放入Shared区段中 //我们也可以显式的吧已初始化或者未初始化的变量放入 Shared区段 __declspec(allocate("Shared")) int g_a=5; __declspec(allocate("Shared")) int g_b;//未初始化 // Tell the linker to make the Shared section readable, writable, and shared. #pragma comment(linker, "/Section:Shared,RWS")//(编译指令)设置区段类型 R读 W写 E执行 S共享 /////////////////////////////////////////////////////////////////////////////// BOOL Dlg_OnInitDialog(HWND hWnd, HWND hWndFocus, LPARAM lParam) { chSETDLGICONS(hWnd, IDI_APPINST); // Force the static control to be initialized correctly. PostMessage(HWND_BROADCAST, g_uMsgAppInstCountUpdate, 0, 0);//广播消息 return(TRUE); } /////////////////////////////////////////////////////////////////////////////// void Dlg_OnCommand(HWND hWnd, int id, HWND hWndCtl, UINT codeNotify) { switch (id) { case IDCANCEL: EndDialog(hWnd, id); break; } } /////////////////////////////////////////////////////////////////////////////// INT_PTR WINAPI Dlg_Proc(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam) { if (uMsg == g_uMsgAppInstCountUpdate) { SetDlgItemInt(hWnd, IDC_COUNT, g_lApplicationInstances, FALSE); } switch (uMsg) { chHANDLE_DLGMSG(hWnd, WM_INITDIALOG, Dlg_OnInitDialog); chHANDLE_DLGMSG(hWnd, WM_COMMAND, Dlg_OnCommand); } return(FALSE); } /////////////////////////////////////////////////////////////////////////////// int WINAPI _tWinMain(HINSTANCE hInstExe, HINSTANCE, PTSTR, int) { // Get the numeric value of the systemwide window message used to notify all top-level windows when the module's usage count has changed. g_uMsgAppInstCountUpdate = RegisterWindowMessage(TEXT("MsgAppInstCountUpdate"));//注册一个消息 // There is another instance of this application running InterlockedExchangeAdd(&g_lApplicationInstances, 1); DialogBox(hInstExe, MAKEINTRESOURCE(IDD_APPINST), NULL, Dlg_Proc); // This instance of the application is terminating InterlockedExchangeAdd(&g_lApplicationInstances, -1);//退出了 -1 // Have all other instances update their display PostMessage(HWND_BROADCAST, g_uMsgAppInstCountUpdate, 0, 0);//广播一下 return(0); } //////////////////////////////// End of File //////////////////////////////////  

   
 