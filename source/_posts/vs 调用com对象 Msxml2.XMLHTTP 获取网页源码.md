---
title: vs 调用com对象 Msxml2.XMLHTTP 获取网页源码 
date: 2011-01-03 11:13:00
tags: CSDN迁移
---
   到处扯 终于扯到 vs 能用的 com对象调用方式了

 

 相信有不少人在找vs c++ 调用 com对象的方法

 

 参考 [http://topic.csdn.net/u/20070315/16/5a9a278f-4bf1-43e4-908e-a78ad69b0796.html](http://topic.csdn.net/u/20070315/16/5a9a278f-4bf1-43e4-908e-a78ad69b0796.html)

 

 

 写的非常乱 也不知道有没有资源泄露

 #include <Windows.h> #include <atlstr.h> //可以用 cstring了 #include <stdio.h> #import <msxml3.dll> using namespace MSXML2; byte * XmlHttp(LPSTR szHttpAddr) //返回 byte* 必须 delete[] { CoInitialize(0); IXMLHTTPRequestPtr http=NULL;//(__uuidof(XMLHTTP)); http.CreateInstance("Msxml2.XMLHTTP"); http->open("GET", szHttpAddr, false); http->setRequestHeader("Referer",""); http->setRequestHeader("Accept-Language","zh-cn"); http->setRequestHeader("Content-Type","application/x-www-form-urlencoded"); http->send(); _variant_t vbin = http-> responseBody; char * pBuf2=NULL; byte *bRet=NULL; if (vbin.vt==(VT_ARRAY|VT_UI1)) { SafeArrayAccessData(vbin.parray,(void **)&pBuf2); long size=vbin.parray-> rgsabound[0].cElements; // raw bytes stream utf-8 to uniocde ,1 get size int nwLen = MultiByteToWideChar(CP_ACP,0,pBuf2,-1,NULL,0); printf( "UTF8 String len:%d/n ",nwLen); LPWSTR lpw=new WCHAR[nwLen]; memset (lpw,0,(nwLen)*sizeof(WCHAR)); //make the buffer empty, use <memory.h> printf( "bytes:%d/n ",(nwLen)*sizeof(WCHAR)); // utf-8 to uniocde ,2 convert MultiByteToWideChar( CP_ACP, 0,pBuf2, size, lpw, nwLen ); BYTE *result=new BYTE[(nwLen)*sizeof(WCHAR)]; memset(result,0,(nwLen)*sizeof(WCHAR)); // unicode to LPSTR WideCharToMultiByte( CP_ACP, 0,lpw, -1,(LPSTR)result, (nwLen)*sizeof(WCHAR), NULL, NULL ); printf( "ANSI String[%d]=%s/n ",_tcslen((LPCTSTR)result),result); _bstr_t bstring((LPCTSTR)result); delete[] lpw; delete[] result; SafeArrayUnaccessData(vbin.parray); bRet=(byte*)lpw; MessageBox(NULL, (LPCTSTR)bstring, _T( "Results "), MB_OK); } http.Release(); CoUninitialize(); return bRet; } int main() { system("pause"); XmlHttp("http://www.17u2.com"); system("pause"); return 0; }

 

 

 

 

 下面是我自己写的简化版 不知道我写的是否有什么隐性问题 不过看起来应该足够用了 

 

 

 #import <msxml3.dll> byte * XmlHttp(LPWSTR szHttpAddr,PDWORD pdwLen=0); //返回 byte* 必须 外部 free() byte * XmlHttp(LPWSTR szHttpAddr,PDWORD pdwLen) //返回 byte* 必须 外部 free() { CoInitialize(0); MSXML2::IXMLHTTPRequestPtr http=NULL;//(__uuidof(XMLHTTP)); HRESULT hr; hr=http.CreateInstance(L"Msxml2.XMLHTTP"); if (hr!=0) return NULL; hr=http->open(L"GET", szHttpAddr, false); if (hr!=0) { if (pdwLen!=NULL) *pdwLen=0; http.Release(); CoUninitialize(); return NULL; } http->setRequestHeader(L"Referer",""); http->setRequestHeader(L"Accept-Language","zh-cn"); http->setRequestHeader(L"Content-Type","application/x-www-form-urlencoded"); hr=http->send(); if (hr!=0) { if (pdwLen!=NULL) *pdwLen=0; http.Release(); CoUninitialize(); return NULL; } _variant_t vbin = http-> responseBody; char * pBuf2=NULL; SafeArrayAccessData(vbin.parray,(void **)&pBuf2); if (pBuf2==NULL) { if (pdwLen!=NULL) *pdwLen=0; SafeArrayUnaccessData(vbin.parray); http.Release(); CoUninitialize(); return NULL; } long size=vbin.parray-> rgsabound[0].cElements; byte *bRet=(byte*)malloc(size+1); bRet[size]=0; memcpy(bRet,pBuf2,size); SafeArrayUnaccessData(vbin.parray); http.Release(); CoUninitialize(); if (pdwLen!=NULL) *pdwLen=size; return bRet;//外部自己必须 Free; } 

 

 

 

 

 

 

 

 //下面这个协议头貌似很好用 http->setRequestHeader(L"Connection",L"keep-alive"); http->setRequestHeader(L"Accept",L"application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5"); http->setRequestHeader(L"User-Agent",L"Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US) AppleWebKit/534.10 (KHTML, like Gecko) Chrome/8.0.552.224 Safari/534.10"); // http->setRequestHeader(L"Accept-Encoding",L"gzip,deflate,sdch"); http->setRequestHeader(L"Accept-Language",L"zh-CN,zh;q=0.8"); 

 

 访问 3g.163.com 不会被秒杀了

 

   
 