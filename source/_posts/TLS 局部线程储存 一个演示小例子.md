---
title: TLS 局部线程储存 一个演示小例子    
date: 2011-01-28 11:06:00
tags: CSDN迁移
---
   #include <Windows.h> #include <stdio.h> __declspec(thread) int gt_nNum=0;//全局tls变量 CRITICAL_SECTION g_cs;//临界区 void WINAPI TestThread(int * pParam) { __declspec(thread) static int st_nNum=0;//静态tls变量 srand(GetTickCount()); for (int i=0;i<5;i++) { EnterCriticalSection(&g_cs);//进入临界区 printf("Thread:%04X gt_nNum:%08X %d st_nNum:%08X %d Param:%08X %d/r/n", GetCurrentThreadId(),>_nNum,gt_nNum++,&st_nNum,st_nNum++,pParam,(*pParam)++); LeaveCriticalSection(&g_cs);//离开临界区 Sleep(rand()%200); } } #define THREADNUM 4 int main() { system("pause"); InitializeCriticalSection(&g_cs);//初始化临界区 //发现一个秘密 InitializeCriticalSection 看起来没有内核对象 调用以后程序句柄数没有增加 printf("Begin/r/n"); system("pause"); HANDLE hThreads[THREADNUM]={NULL}; for ( int i=0;i<THREADNUM;i++) { hThreads[i]=CreateThread(NULL,NULL,(LPTHREAD_START_ROUTINE)TestThread,>_nNum,NULL,NULL);//主线程的tls变量传递给子线程 } WaitForMultipleObjects(THREADNUM,hThreads,TRUE,INFINITE);//等待线程全部执行完毕 for (int i=0;i<THREADNUM;i++)//清扫战场 { CloseHandle(hThreads[i]); } DeleteCriticalSection(&g_cs);//删除临界区 printf("End/r/n"); system("pause"); return 0; } 

   
 