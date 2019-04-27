---
title: c++ 重载 new delete  用堆来分配内存
date: 2011-01-25 09:10:00
tags: CSDN迁移
---
   #include <windows.h> #include <tchar.h> #include <stdio.h> class CSomeClass { public: DWORD m_dwValue;//一个成员变量 CSomeClass() { printf("Run %s /r/n",__FUNCTION__); m_dwValue=0; } ~CSomeClass() { printf("Run %s /r/n",__FUNCTION__); } static HANDLE s_hHeap; static DWORD s_dwNewClassNum; void *operator new(size_t size)//重载new操作符 如果继承此类 子类也可以重新重载 new和 delete { printf("Run %s /r/n",__FUNCTION__); if (s_hHeap==NULL) { s_hHeap =HeapCreate(HEAP_GENERATE_EXCEPTIONS,0,0); if (s_hHeap==NULL) { return NULL; } } void *p=HeapAlloc(s_hHeap,HEAP_ZERO_MEMORY,size); if (p==NULL) { return NULL; } s_dwNewClassNum++; return p; } void operator delete(void *p) { printf("Run %s /r/n",__FUNCTION__); if (HeapFree(s_hHeap,NULL,p)) { s_dwNewClassNum--; } if (s_dwNewClassNum==0) { HeapDestroy(s_hHeap);//没有类了 销毁堆 s_hHeap=NULL; } } public: operator DWORD() const //重载一个赋值符号 { return m_dwValue; } protected: private: }; HANDLE CSomeClass::s_hHeap=NULL;//初始化静态变量 DWORD CSomeClass::s_dwNewClassNum=0; int main() { CSomeClass *pClass=new CSomeClass; pClass->m_dwValue=250; printf("enen`` %d/r/n",*pClass+110); delete pClass; return 0; }

   
 