---
title: CriticalSection临界区封装类
date: 2010-12-31 17:23:00
tags: CSDN迁移
---
   #pragma once //编译一次 class CCriticalSection //临界区封装类 { public: CCriticalSection(DWORD dwSpinCount=0) //使用旋转锁 参考值 4000 不为0 则会创建一个事件内核对象(多线程同时访问这个事件内核对象才有用) { m_bInit=FALSE; if (dwSpinCount==0) { InitializeCriticalSection(); } else InitializeCriticalSectionAndSpinCount(dwSpinCount); } ~CCriticalSection() { DeleteCriticalSection(); } void InitializeCriticalSection() { if (m_bInit) { PRINTFUNDEBUGINFO("已初始化"); return; } ::InitializeCriticalSection(&m_cs); m_bInit=TRUE; } BOOL InitializeCriticalSectionAndSpinCount(DWORD dwSpinCount) //带旋转锁初始化 参考值 4000 如果只有一个cpu处理器 则忽略 dwspincount { if (m_bInit) { PRINTFUNDEBUGINFO("已初始化"); return FALSE; } return m_bInit=::InitializeCriticalSectionAndSpinCount(&m_cs,dwSpinCount); } DWORD SetCriticalSectionSpinCount(DWORD dwSpinCount)//改变旋转锁次数 如果是单处理器 同样忽略 dwspincount { return ::SetCriticalSectionSpinCount(&m_cs,dwSpinCount); } void EnterCriticalSection() //进入临界区 { ::EnterCriticalSection(&m_cs); } void LeaveCriticalSection() //离开临界区 { ::LeaveCriticalSection(&m_cs); } BOOL TryEnterCriticalSection() //尝试进入临界区(立即返回) 如果返回值为true 必须对应一个 leavecriticalsection 如果为false 则不可进入 { return ::TryEnterCriticalSection(&m_cs); } void DeleteCriticalSection()//删除临界区 { if (!m_bInit) { PRINTFUNDEBUGINFO("无对象"); return;//无对象 } m_bInit=FALSE; ::DeleteCriticalSection(&m_cs); } protected: private: BOOL m_bInit;//是否已初始化 CRITICAL_SECTION m_cs;//私有结构 };  

 

 核心编程看到第八章 "关键段和旋转锁" 趁热打铁 整一下

   
 