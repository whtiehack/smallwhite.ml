---
title: C++ 提权函数
date: 2010-01-17 20:09:00
tags: CSDN迁移
---
   BOOL MyTokenPrivileges(int ProcessID) { HANDLE processHandle; HANDLE hdlTokenHandle; LUID tmpLuid; TOKEN_PRIVILEGES tkp; if (ProcessID==NULL) { processHandle=GetCurrentProcess(); } else { processHandle=MyOpenProcess(ProcessID); } //OpenProcessToken (hdlProcessHandle, 40, hdlTokenHandle) OpenProcessToken(processHandle,40,&hdlTokenHandle); LookupPrivilegeValue(NULL,SE_DEBUG_NAME,&tmpLuid); tkp.PrivilegeCount=1; tkp.Privileges->Luid.LowPart=tmpLuid.LowPart; tkp.Privileges->Luid.HighPart=tmpLuid.HighPart; tkp.Privileges->Attributes=2; return AdjustTokenPrivileges(hdlTokenHandle,0,&tkp,sizeof(tkp),NULL,NULL); }

   
 