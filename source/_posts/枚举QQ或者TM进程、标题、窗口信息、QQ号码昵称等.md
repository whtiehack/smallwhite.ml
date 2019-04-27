---
title: 枚举QQ或者TM进程、标题、窗口信息、QQ号码昵称等
date: 2011-01-03 15:15:00
tags: CSDN迁移
---
   相关链接: http://bbs.eyuyan.com/read.php?tid=244922&fpage=3

 

 

begin

 

 网页返回:

 portraitCallBack({"xxxxxxxx":["http://imgcache.qq.com/qzone_v4/client/userinfo_

 icon/5001.gif",157,0,0,0,0,"xxxxx",0]})

 网页返回end

 

 

 RunTime:46ms findstr:

 hwnd:197566 ClassName:TXGuiFoundation

 WindowText:TM2009

 PID:2984 ProcessName:TM.exe QQ:xxxxxx NickName:xxxxxxx

 Path:D:/Program Files/Tencent/TM2009/Bin/TM.exe

 

 请按任意键继续. . .

   
 

 

 #include <Windows.h> #include <atlstr.h> //可以用 cstring了 哈哈哈哈 #include <tlhelp32.h> #include <stdio.h> #include <locale> //#pragma comment(lib,"kernel32.lib") //#pragma comment(lib,"user32.lib") //#pragma comment(linker, "/SUBSYSTEM:windows") //#pragma comment(linker, "/ENTRY:main") #import <msxml3.dll> byte * XmlHttp(LPWSTR szHttpAddr,PDWORD pdwLen=0); //返回 byte* 必须 外部 free() byte * XmlHttp(LPWSTR szHttpAddr,PDWORD pdwLen) //返回 byte* 必须 外部 free() { CoInitialize(0); MSXML2::IXMLHTTPRequestPtr http=NULL;//(__uuidof(XMLHTTP)); HRESULT hr; hr=http.CreateInstance(L"Msxml2.XMLHTTP"); if (hr!=0) return NULL; hr=http->open(L"GET", szHttpAddr, false); if (hr!=0) { if (pdwLen!=NULL) *pdwLen=0; http.Release(); CoUninitialize(); return NULL; } http->setRequestHeader(L"Referer",""); http->setRequestHeader(L"Accept-Language","zh-cn"); http->setRequestHeader(L"Content-Type","application/x-www-form-urlencoded"); hr=http->send(); if (hr!=0) { if (pdwLen!=NULL) *pdwLen=0; http.Release(); CoUninitialize(); return NULL; } _variant_t vbin = http-> responseBody; char * pBuf2=NULL; SafeArrayAccessData(vbin.parray,(void **)&pBuf2); if (pBuf2==NULL) { if (pdwLen!=NULL) *pdwLen=0; SafeArrayUnaccessData(vbin.parray); http.Release(); CoUninitialize(); return NULL; } long size=vbin.parray-> rgsabound[0].cElements; byte *bRet=(byte*)malloc(size+1); bRet[size]=0; memcpy(bRet,pBuf2,size); SafeArrayUnaccessData(vbin.parray); http.Release(); CoUninitialize(); if (pdwLen!=NULL) *pdwLen=size; return bRet;//外部自己必须 Free; } inline __int64 FileTimeToQuadWord(PFILETIME pft) //FILETIME to int64 { return Int64ShllMod32(pft->dwHighDateTime,32)|pft->dwLowDateTime; } inline __int64 GetThreadRunTime() //取线程当前占用cpu时间 单位:100ns(纳秒) { FILETIME ftKernelTime,ftUserTime,ftDummy; GetThreadTimes(GetCurrentThread(),&ftDummy,&ftDummy,&ftKernelTime,&ftUserTime); return FileTimeToQuadWord(&ftKernelTime)+FileTimeToQuadWord(&ftUserTime); } int SearchByteShuZu(byte * bForSearch,int ifLen, byte* bWaitSearch, int iwLen,int iFirstSearchPos) {//寻找字节集数组(待寻找的,待寻找的最大长度,要寻找的,要寻找的长度,起始寻找位置) 返回-1 为未找到 位置从0开始 int iCurrentPos=0;//待搜索位置 if (iFirstSearchPos>ifLen)//超过待搜索的长度 { return -1; } if (iwLen>ifLen)//要搜索的长度比 待搜索的长度大 返回 { return -1; } if (iwLen==0||ifLen==0) { return -1;//0 返回 } // bForSearch+=iFirstSearchPos;//设置起始搜索位置 iCurrentPos+=iFirstSearchPos;//设置起始搜索位置 bForSearch+=iCurrentPos;//设置指针 对应 while(1) { while(*bForSearch!=*bWaitSearch)//找到第一个相同的 { iCurrentPos+=1;//当前搜索位置前进1 bForSearch+=1;//当前指针前进1 if (iCurrentPos>ifLen) //长度超过待搜索的整体长度返回 { return -1; } } for (int i=0;i<iwLen;++i)//开始对比 { if (*(bForSearch+i)!=*(bWaitSearch+i)) { iCurrentPos+=1;//当前搜索位置前进1 bForSearch+=1;//当前指针前进1 //设置下指针前进1 break;//找到一个不同的 跳出 } if (i+1==iwLen) { return iCurrentPos;//找到列 } } } } WCHAR * GetWindowProcessPathW(HWND hwnd,WCHAR *szBuff) { DWORD dwProcessID=0; GetWindowThreadProcessId(hwnd,&dwProcessID); if (dwProcessID==0) { return NULL; } HANDLE hsnap=CreateToolhelp32Snapshot(TH32CS_SNAPMODULE,dwProcessID); if (hsnap==INVALID_HANDLE_VALUE) { return NULL; } MODULEENTRY32W me32={sizeof(MODULEENTRY32W)}; Module32FirstW(hsnap,&me32); CloseHandle(hsnap); return lstrcpyW(szBuff,me32.szExePath); } LPWSTR GetQQProcessQQNum(DWORD dwProcessID,LPWSTR szBuff) //取QQ进程QQ号码 同样可以取 TM的 { HANDLE hProcessHandle=OpenProcess(PROCESS_VM_READ|PROCESS_QUERY_INFORMATION,FALSE,dwProcessID); if (hProcessHandle==INVALID_HANDLE_VALUE) { return NULL; } LPWSTR szRet=NULL; MEMORY_BASIC_INFORMATION mbi={0}; void* pAddress=NULL; WCHAR szFind[]=L"Msg2.0.db"; int nFindLen=lstrlenW(szFind)*sizeof(WCHAR); while (VirtualQueryEx(hProcessHandle,pAddress,&mbi,sizeof(MEMORY_BASIC_INFORMATION))!=0) { if (mbi.Protect!=PAGE_EXECUTE &&mbi.Protect!=PAGE_NOACCESS&&mbi.Protect!=PAGE_NOCACHE) { void *lpBuff=malloc(mbi.RegionSize); if (ReadProcessMemory(hProcessHandle,pAddress,lpBuff,mbi.RegionSize,NULL)) { int nRet=SearchByteShuZu((byte*)lpBuff,mbi.RegionSize,(byte*)szFind,nFindLen,0); if (nRet!=-1 && (WCHAR*)((byte*)lpBuff+nRet-4)[0]!='/0') { // wprintf(L"findQQ %X %s/r/n",(byte*)pAddress+nRet,(byte*)lpBuff+nRet); // byte bCopy[50]={0}; // ReadProcessMemory(hProcessHandle,(byte*)pAddress+nRet-28,bCopy,40,NULL); LPWSTR szTmp=(LPWSTR)lpBuff; szTmp[nRet/sizeof(WCHAR)]=L'/0'; szTmp=(LPWSTR)((byte*)lpBuff+nRet-28); wcsrchr(szTmp,L'//')[0]=L'/0'; lstrcpyW(szBuff,wcsrchr(szTmp,L'//')+1); // wprintf(L"finds %X %s /r/n",(byte*)pAddress+nRet-28,szBuff); // wprintf(L"QQ:%s",szBuff); szRet=szBuff; free(lpBuff); break; } } free(lpBuff); } pAddress=(void*)((SIZE_T)pAddress+mbi.RegionSize); } CloseHandle(hProcessHandle); return szRet; } LPWSTR GetQQNickName(LPWSTR szQQNum,LPWSTR szBuff,int cchWideChar)//取QQ昵称 { //http://base.qzone.qq.com/fcg-bin/cgi_get_portrait.fcg?uins=qqnum&get_nick=1 CStringW str; str.Format(L"http://base.qzone.qq.com/fcg-bin/cgi_get_portrait.fcg?uins=%s&get_nick=1",szQQNum); // char szAnsiHttp[MAX_PATH]; // WideCharToMultiByte(CP_ACP,0,str,str.GetLength()+1,szAnsiHttp,MAX_PATH,NULL,NULL); byte *bRet=XmlHttp((LPWSTR)str.GetString()); //,0,0,0,"SmallWhite",0]}) printf("网页返回:/r/n%s/r/n网页返回end/r/n/r/n/r/n",bRet); if (bRet==NULL) { return NULL; } char*szRet=(char*)bRet; strrchr(szRet,'/"')[0]='/0'; szRet=strrchr(szRet,'/"')+1; // printf("qqnick:%s/r/n",szRet); MultiByteToWideChar(CP_ACP,0,szRet,-1,szBuff,cchWideChar); free(bRet); return szBuff; } int main() { setlocale(LC_CTYPE, "");//让wprintf 支持中文 printf("begin/r/n/r/n"); __int64 qwRunTime=GetThreadRunTime(); HWND hwnd=FindWindowExW(NULL,NULL,NULL,NULL); CStringW str=L""; while (hwnd!=NULL) { WCHAR szClassName[MAX_PATH]; WCHAR szWindowText[MAX_PATH]; GetClassNameW(hwnd,szClassName,MAX_PATH); GetWindowTextW(hwnd,szWindowText,MAX_PATH); if (lstrcmpW(szClassName,L"TXGuiFoundation")==0 && (SearchByteShuZu((byte*)szWindowText,lstrlenW(szWindowText)*sizeof(WCHAR),(byte*)L"TM",lstrlenW(L"TM")*sizeof(WCHAR),0)!=-1|| SearchByteShuZu((byte*)szWindowText,lstrlenW(szWindowText)*sizeof(WCHAR),(byte*)L"QQ",lstrlenW(L"QQ")*sizeof(WCHAR),0)!=-1)) { WCHAR szProcessPath[MAX_PATH]; GetWindowProcessPathW(hwnd,szProcessPath); DWORD dwProcessID; GetWindowThreadProcessId(hwnd,&dwProcessID); WCHAR szQQ[128]={0}; // GetQQProcessQQNum(dwProcessID,szQQ); if (GetQQProcessQQNum(dwProcessID,szQQ)==NULL) { hwnd=FindWindowExW(NULL,hwnd,NULL,NULL); continue; } WCHAR szNickName[128]={0}; GetQQNickName(szQQ,szNickName,sizeof(szNickName)); str.AppendFormat(L"hwnd:%-8d ClassName:%s/r/nWindowText:%s/r/nPID:%-5d ProcessName:%s/tQQ:%s NickName:%s/r/nPath:%s/r/n/r/n",hwnd,szClassName,szWindowText, dwProcessID,wcsrchr(szProcessPath,L'//')+1,szQQ,szNickName,szProcessPath); } hwnd=FindWindowExW(NULL,hwnd,NULL,NULL); } qwRunTime=GetThreadRunTime()-qwRunTime; wprintf(L"RunTime:%dms/r/n/r/n/r/n%s", (DWORD)(qwRunTime/1000/10),str); // MessageBoxW(GetActiveWindow(),str,L"",NULL); return 0; }

 

 

 

 

 

   
 