---
title: 使用 LoadLibrary 远线程向进程注入dll
date: 2011-05-12 11:15:00
tags: CSDN迁移
---
   BOOL WINAPI InjectDllWithLoadLibrary(HANDLE hProcess,LPCTSTR lpszDllPath)//; //使用 LoadLibrary的方式注入dll { LPVOID lpNameAddr=VirtualAllocEx(hProcess,NULL,lstrlen(lpszDllPath)+sizeof(TCHAR),MEM_COMMIT,PAGE_EXECUTE_READWRITE); if (lpNameAddr==NULL) { return FALSE; } if (!WriteProcessMemory(hProcess,lpNameAddr,lpszDllPath,lstrlen(lpszDllPath),NULL)) { VirtualFree(lpNameAddr,NULL,MEM_FREE); return FALSE; } LPVOID lpLoadLibraryAddr=(LPVOID)GetModuleHandle(_T("Kernel32.dll")); lpLoadLibraryAddr=(LPVOID)GetProcAddress((HMODULE)lpLoadLibraryAddr, #ifdef UNICODE "LoadLibraryW" #else "LoadLibraryA" #endif ); HANDLE hThread=CreateRemoteThread(hProcess,NULL,NULL,(LPTHREAD_START_ROUTINE)lpLoadLibraryAddr,lpNameAddr,NULL,NULL); if (hThread==NULL) { VirtualFree(lpNameAddr,NULL,MEM_FREE); return FALSE; } WaitForSingleObject(hThread,INFINITE); CloseHandle(hThread); VirtualFree(lpNameAddr,NULL,MEM_FREE); return TRUE; } 

   
 