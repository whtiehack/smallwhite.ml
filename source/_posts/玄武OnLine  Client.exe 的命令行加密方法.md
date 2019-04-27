---
title: 玄武OnLine  Client.exe 的命令行加密方法
date: 2011-05-04 00:38:00
tags: CSDN迁移
---
   朋友让帮忙分析这个游戏的命令行的加密方法 

 (挺有意思的

 

 

 这是分析完的

 LPSTR WINAPI GetXWLoginParam(LPSTR szBuff)//; //至少64字节buff { FILETIME ft={0}; GetSystemTimeAsFileTime(&ft); ft.dwLowDateTime+=0x2AC18000; ft.dwHighDateTime+=0xFE624E21; DWORD dwLow=ft.dwLowDateTime; DWORD dwHigh=ft.dwHighDateTime; DWORD dwRet=0; __asm { pushad; mov ecx,0x989680; mov eax,dwHigh; xor edx,edx; div ecx; mov eax,dwLow; div ecx; mov dwRet,eax; mov edx,eax; xor edi,edi; mov eax,0x89be; xor ecx,ecx; LableLoop: lea esi,dword ptr ds:[ecx+eax] imul eax,esi; inc ecx; cmp ecx,7; jb LableLoop; inc eax; imul eax,edx; imul eax,edx; //eax为结果 //-897168924 mov dwRet,eax; popad; } lstrcpy(szBuff,TEXT(" -")); ZeroMemory(szBuff+3,15);//清0 char *szNow=szBuff+3; while (dwRet!=0) { DWORD dwYu=dwRet%0xa; *szNow=dwYu+'0'; szNow++; dwRet=dwRet/0xa; } return szBuff; } 

 

 

 

 

 

 下面是分析过程中保存的原型

 

 

 

 

0040903F |. E8 4C290500 call __Launch.0045B990

 00409044 |> 8D4E F0 lea ecx,dword ptr ds:[esi-10]

 00409047 |. E8 9E80FFFF call __Launch.004010EA

 0040904C |. EB 54 jmp short __Launch.004090A2

 0040904E |> 897C24 60 mov dword ptr ss:[esp+60],edi

 00409052 |. 897C24 64 mov dword ptr ss:[esp+64],edi

 00409056 |. 897C24 68 mov dword ptr ss:[esp+68],edi

 0040905A |. C68424 D80100>mov byte ptr ss:[esp+1D8],24

 00409062 |. 8B7424 28 mov esi,dword ptr ss:[esp+28]

 00409066 |. 6A 05 push 5

 00409068 |. 8D4C24 24 lea ecx,dword ptr ss:[esp+24]

 0040906C |. E8 8288FFFF call __Launch.004018F3

 00409071 |. 50 push eax

 00409072 |. 6A 04 push 4

 00409074 |. 8D4424 68 lea eax,dword ptr ss:[esp+68]

 00409078 |. 50 push eax

 00409079 |. 56 push esi

 0040907A |. E8 E1FF0300 call __Launch.00449060 ; 计算参数

 0040907F |. 83C4 0C add esp,0C

 00409082 |. 50 push eax

 00409083 |. 8D4C24 24 lea ecx,dword ptr ss:[esp+24]

 00409087 |. E8 6788FFFF call __Launch.004018F3

 0040908C |. 50 push eax ; |FileName

 0040908D |. 68 58CA5000 push __Launch.0050CA58 ; |Operation = ""

 00409092 |. 57 push edi ; |hWnd

 00409093 |. FF15 0CD44F00 call dword ptr ds:[<&SHELL32.ShellExecut>; /zheli

 00409099 |. 8D4C24 5C lea ecx,dword ptr ss:[esp+5C]

 0040909D |. E8 2DB1FFFF call __Launch.004041CF

 004090A2 |> 8B4C24 18 mov ecx,dword ptr ss:[esp+18]

 004090A6 |. 83C1 F0 add ecx,-10

 

 00775F08 20 20 2D 30 36 37 37 38 30 37 39 33 31 00 -0677807931.

 

 ds:[004FD130]=76C62FDE (kernel32.GetSystemTimeAsFileTime)

 

 

 

 file=GetSystemTimeAsFileTime();

 file.low+=2AC18000

 file.high+=FE624E21

 

 004A8EDA |. 8B4C24 14 mov ecx,dword ptr ss:[esp+14] ; ecx=常数989680

 004A8EDE |. 8B4424 10 mov eax,dword ptr ss:[esp+10] ; eax=high那个高位

 004A8EE2 |. 33D2 xor edx,edx

 004A8EE4 |. F7F1 div ecx

 004A8EE6 |. 8BD8 mov ebx,eax

 004A8EE8 |. 8B4424 0C mov eax,dword ptr ss:[esp+C] ; 低位

 004A8EEC |. F7F1 div ecx

 004A8EEE |. 8BD3 mov edx,ebx ; eax就是值了

 

 0049AB44 |. 8D45 F8 lea eax,[local.2]

 0049AB47 |. 50 push eax ; /pFileTime

 0049AB48 |. FF15 30D14F00 call dword ptr ds:[<&KERNEL32.GetSystemTimeAsFi>; /GetSystemTimeAsFileTime

 0049AB4E |. 8B45 F8 mov eax,[local.2] ; eax低位

 0049AB51 |. 8B4D FC mov ecx,[local.1] ; ecx 高位

 0049AB54 |. 6A 00 push 0

 0049AB56 |. 05 0080C12A add eax,2AC18000

 0049AB5B |. 68 80969800 push 989680

 0049AB60 |. 81D1 214E62FE adc ecx,FE624E21

 0049AB66 |. 51 push ecx

 0049AB67 |. 50 push eax

 0049AB68 |. E8 63E30000 call __Launch.004A8ED0

 0049AB6D |. 8B4D 08 mov ecx,[arg.1]

 0049AB70 |. 85C9 test ecx,ecx

 0049AB72 |. 74 05 je short __Launch.0049AB79

 0049AB74 |. 8901 mov dword ptr ds:[ecx],eax

 0049AB76 |. 8951 04 mov dword ptr ds:[ecx+4],edx

 

 004A8ED0 /$ 53 push ebx

 004A8ED1 |. 56 push esi

 004A8ED2 |. 8B4424 18 mov eax,dword ptr ss:[esp+18]

 004A8ED6 |. 0BC0 or eax,eax

 004A8ED8 |. 75 18 jnz short __Launch.004A8EF2

 004A8EDA |. 8B4C24 14 mov ecx,dword ptr ss:[esp+14] ; ecx=常数989680

 004A8EDE |. 8B4424 10 mov eax,dword ptr ss:[esp+10] ; eax=high那个高位

 004A8EE2 |. 33D2 xor edx,edx

 004A8EE4 |. F7F1 div ecx

 004A8EE6 |. 8BD8 mov ebx,eax

 004A8EE8 |. 8B4424 0C mov eax,dword ptr ss:[esp+C] ; 低位

 004A8EEC |. F7F1 div ecx

 004A8EEE |. 8BD3 mov edx,ebx ; eax就是值了

 004A8EF0 |. EB 41 jmp short __Launch.004A8F33

 004A8EF2 |> 8BC8 mov ecx,eax

   
 