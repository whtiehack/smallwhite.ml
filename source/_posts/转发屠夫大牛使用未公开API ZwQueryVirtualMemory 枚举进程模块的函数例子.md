---
title: 转发屠夫大牛使用未公开API ZwQueryVirtualMemory 枚举进程模块的函数例子
date: 2010-12-15 23:59:00
tags: CSDN迁移
---
   #include <windows.h> #include <cstdio> #include <winternl.h> #include <atlstr.h> typedef enum _MEMORY_INFORMATION_CLASS { MemoryBasicInformation, MemoryWorkingSetList, MemorySectionName }MEMORY_INFORMATION_CLASS; typedef NTSTATUS (WINAPI *ZWQUERYVIRTUALMEMORY) ( IN HANDLE ProcessHandle, IN PVOID BaseAddress, IN MEMORY_INFORMATION_CLASS MemoryInformationClass, OUT PVOID MemoryInformation, IN ULONG MemoryInformationLength, OUT PULONG ReturnLength OPTIONAL ); VOID EnumProcessForModule () { ZWQUERYVIRTUALMEMORY QueryVirtualMemoryFunction=NULL; DWORD Index=0; NTSTATUS NtStatus=0; MEMORY_BASIC_INFORMATION InfoMation; BYTE Buffer[MAX_PATH*2+4]={0}; PUNICODE_STRING SectionName=NULL; DWORD Counter; CString ModuleAddress; CString ModuleName; QueryVirtualMemoryFunction=(ZWQUERYVIRTUALMEMORY) ::GetProcAddress ( GetModuleHandle("ntdll.dll"), //ntdll.dll=地府 _T("ZwQueryVirtualMemory") //ZwQueryVirtualMemory=鬼魂名 ); if (QueryVirtualMemoryFunction==NULL) { printf("别瞎TM扯淡啦！"); } else { for(Index;Index<0x80000000;Index+=0x1000) { NtStatus=QueryVirtualMemoryFunction ( (HANDLE)-1, (PULONG)Index, MemoryBasicInformation, &InfoMation, sizeof(InfoMation), NULL ); if (NtStatus>=0) { if (InfoMation.Type==MEM_IMAGE) { if ((DWORD)InfoMation.AllocationBase==Index) { // 这么做是为什么,因为你不这样过滤,你会得到几千个模块,为什么呢？因为模块之间互相映射,唉,挺乱的,实话说我解释的不太清楚,如果你真的想知道你要花几个星期的时间去深入学习下PE啦,如果你不在意你就按照我的方法做就行啦,他其实就是过滤掉同名的模块。 NtStatus=QueryVirtualMemoryFunction ( (HANDLE)-1, (PULONG)Index, MemorySectionName, Buffer, // typedef struct MEMORY_SECTION_NAME // { // UNICODE_STRING SectionFileName; // WCHAR NameBuffer[ANYSIZE_ARRAY]; // } *PMEMORY_SECTION_NAME; // // 但是为什么不用它呢？因为它更底层一些在R3层用它很麻烦,所以放弃它,定义一个和他同样大小的数组,一样可以接收数据,关键在于这个尺寸问题,因为这个结构是在宽字节环境所以我们来计算一下这个结构到底有多大。首先来看第一个成员UNICODE_STRING他的最大值就是MAX_PATH这 // 个宏表示260个字节,又因为它是宽字符环境所以就要*2啦,再来看第二个成员WCHAR大家知道这个宏[ANYSIZE_ARRAY]表示2,同样因为UNICODE的关系要*2也就是4,所以这个结构最大不会超过[MAX_PATH*2+4],那么定义这个尺寸的一个数组接收数据就绰绰有余啦,大家知道数组作为参数的时候会自动降级为指针, 怎么样？还好理解吧？继续...... sizeof(Buffer), NULL ); if (NtStatus>=0) { SectionName=(PUNICODE_STRING)Buffer; ModuleName=SectionName->Buffer; printf("Address:%08X ModuleName/r/n%s/r/n", Index,ModuleName); // ModuleAddress.Format(_T("%x"),Index); // Counter=ListGoodsFilter.InsertItem(Counter,ModuleAddress); // ListGoodsFilter.SetItemText(Counter,1,ModuleName); // 这些都是界面编程和字符串的事,我就不解释啦, } } } } } } } int main() { EnumProcessForModule(); system("pause"); return 0; } 

 

 屠夫大牛的帖子在这里

 

 [http://bbs.pediy.com/showthread.php?t=125080](http://bbs.pediy.com/showthread.php?t=125080)

   
 