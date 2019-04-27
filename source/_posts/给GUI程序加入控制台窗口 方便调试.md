---
title: 给GUI程序加入控制台窗口 方便调试
date: 2010-12-16 00:22:00
tags: CSDN迁移
---
   下面代码是给程序加入控制台

 可以使用console的一系列函数了

 例如 printf(); 以及一些控制台颜色函数

 

 if (!AllocConsole()) { // MyDbgPrint("创建调试控制台失败"); } else { char szBuff[128]; wsprintfA(szBuff,"游戏调试输出窗口 进程ID:%d", GetCurrentProcessId()); SetConsoleTitleA(szBuff); //设置控制台标题 freopen("conin$", "r+t", stdin); freopen("conout$", "w+t", stdout); freopen("conout$", "w+t", stderr); } 

 

 给gui程序加入这个 调试程序非常方便了

 下面是关闭控制台

 fclose(stderr); fclose(stdout); fclose(stdin); FreeConsole(); 

 

 

 

 

 还有一种模式是 把控制台的输出 附加到 父进程的控制台里面

 

 if (!AttachConsole(ATTACH_PARENT_PROCESS)) { MyDbgPrint("附加到父进程控制台失败"); } else { // char szBuff[128]; // wsprintfA(szBuff,"游戏调试输出窗口 进程ID:%d", // GetCurrentProcessId()); // SetConsoleTitleA(szBuff); freopen("conin$", "r+t", stdin); freopen("conout$", "w+t", stdout); freopen("conout$", "w+t", stderr); } 

 这样 此进程的输出就会转到父进程的控制台内了 

 

   
 