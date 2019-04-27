---
title: 使用HANDLE_MSG宏简化Win32应用的开发
date: 2011-08-17 20:42:56
tags: CSDN迁移
---
   [http://blog.csdn.net/tanghw/article/details/5438093](http://blog.csdn.net/tanghw/article/details/5438093)

 

 

 

 

 Win32应用中的回调函数WndProc用于接收Windows向应用程序直接发送的消息，以及响应消息。大多情况下，我们这样编写代码：

 

 [view plain](http://blog.csdn.net/tanghw/article/details/5438093#)  
   
 
  1. LRESULT CALLBACK WndProc(HWND hWnd, 
  2. UINT message, 
  3. WPARAM wParam, 
  4. LPARAM lParam ) 
  5. { 
  6. int cxClient, cyClient; 
  7. PAINTSTRUCT ps; 
  8. HDC hdc; 
  9. switch( message ) 
  10. { 
  11. case WM_SIZE: 
  12. cxClient = LOWORD(lParam); 
  13. cyClient = HIWORD(lParam); 
  14. break; 
  15. case WM_PAINT: 
  16. hdc = BeginPaint( hWnd, &ps ); 
  17. EndPaint( hWnd, &ps ); 
  18. break;<br /> 
  19. case WM_DESTROY: 
  20. PostQuitMessage( 0 ); 
  21. break; 
  22. } 
  23. return DefWindowProc( hWnd, message, wParam, lParam ); 
  24. }   
 

 这种方式通过switch分支语句分理处理各个消息，结构简单明了。但有2个问题：

 
  1. 在所处理的消息多了后，全部代码都集中于一个switch语句中，变量容易相互污染，且代码很长，不容易定位代码。
  2. 大多数的消息都有相应的WPARAM、LPARAM参数，但对于每个消息，其WPARAM、LPARAM参数的具体内容又不一致。就像上面WM_SIZE中的代码，我们怎么知道cyClient、cyClient的信息就放在lParam而不是wParam中，且cxClient的信息在lParam的低位，cyClient的信息在lParam的高位？我们需要随时查询SDK文档以了解这两个参数中各有什么含义，以及如何恰当地将这些参数抽取出来。不管怎样，上面的代码实际上就是个让人一团雾水的魔术代码(Magic Code).WindowsX.h定义了许多宏，可以帮助我们解决上述这些问题。其中HANDLE_MSG宏可以大大简化Win32开发。下面我们先看使用HANDLE_MSG宏后的代码：

 

 [view plain](http://blog.csdn.net/tanghw/article/details/5438093#)  
   
 
  1. void OnSize(HWND hwnd, UINT state, int cx, int cy) 
  2. { 
  3. } 
  4. void OnPaint(HWND hWnd) 
  5. { 
  6. PAINTSTRUCT ps; 
  7. HDC hdc; 
  8. hdc = BeginPaint( hWnd, &ps ); 
  9. EndPaint( hWnd, &ps ); 
  10. } 
  11. void OnWinDestroy(HWND hWnd) 
  12. { 
  13. PostQuitMessage(0); 
  14. } 
  15. LRESULT CALLBACK WndProc(HWND hWnd, 
  16. UINT message, 
  17. WPARAM wParam, 
  18. LPARAM lParam ) 
  19. { 
  20. switch( message ) 
  21. { 
  22. HANDLE_MSG(hWnd, WM_SIZE, OnSize); 
  23. HANDLE_MSG(hWnd, WM_PAINT, OnPaint); 
  24. HANDLE_MSG(hWnd, WM_DESTROY, OnWinDestroy); 
  25. } 
  26. return DefWindowProc( hWnd, message, wParam, lParam ); 
  27. }   
 

 与使用HANDLE_MSG宏之前的代码相比，我们根本不需使用LOWORD、HIWORD来提取cxCleint及cyClient的信息，OnSize函数的参数已经有cx及cy，而且还传进一个表示窗口变化类型的参数state，如SIZE_RESTORED, SIZE_MAXSHOW等。ps与hdc这两个变量移至OnPaint函数中而成为真正的局域变量。在switch分支语句中，对于每一个消息，都使用HANDLE_MSG宏清晰地将消息与消息处理函数对应起来，代码非常简洁。而无论是在消息处理函数，或是switch分支中，我们均无需显式地加上break语句。

 下面我们来看看HANDLE_MSG宏是如何做到这一点的。HANDLE_MSG宏的定义如下所示：

 

 [view plain](http://blog.csdn.net/tanghw/article/details/5438093#)  
   
 
  1. #define HANDLE_MSG(hwnd, message, fn) / 
  2. case (message): return HANDLE_##message((hwnd), (wParam), (lParam), (fn))   
 

 HANDLE_MSG(hwnd, message, fn)是宏的签名。hwnd是需处理消息的窗口句柄，message是消息，fn是指向负责消息处理的函数指针。当编译器遇到此宏，将在编译时将其转换为

 

 [view plain](http://blog.csdn.net/tanghw/article/details/5438093#)  
   
 
  1. case (message): return HANDLE_##message((hwnd), (wParam), (lParam), (fn))   
 

 的形式。##是ANSI C标准中的预处理器，用于将前后两个符号直接连接起来。因此，当message为WM_SIZE时，HANDLE_##message就变成：

 

 [view plain](http://blog.csdn.net/tanghw/article/details/5438093#)  
   
 
  1. HANDLE_WM_SIZE   
 

 因此，对于

 

 [view plain](http://blog.csdn.net/tanghw/article/details/5438093#)  
   
 
  1. HANDLE_MSG(hWnd, WM_SIZE, OnSize)   
 

 编译器将转换为：

 

 [view plain](http://blog.csdn.net/tanghw/article/details/5438093#)  
   
 
  1. case WM_SIZE: 
  2. return HANDLE_WM_SIZE(hwnd, wParam, lParam, OnSize)   
 

 我们注意到，尽管HANDLE_MSG宏中未使用wParam及lParam参数，但展开宏后，这两个参数均加进来了。

 HANDLE_WM_SIZE也是一个在WindowsX.h中定义的宏，其原型如下：

 

 [view plain](http://blog.csdn.net/tanghw/article/details/5438093#)  
   
 
  1. #define HANDLE_WM_SIZE(hwnd, wParam, lParam, fn) / 
  2. ((fn)((hwnd), (UINT)(wParam), (int)(short)LOWORD(lParam), (int)(short)HIWORD(lParam)), 0L)   
 

 正是在HANDLE_WM_SIZE宏中，自动将wParam, lParam的高位及低位分别抽出，作为OnSize函数的实参进行传递。

 应注意，不同消息处理函数的参数列表是不一样的。如OnSize函数，其参数列表包括HWND, UINT, int, int, 而OnPaint、OnWindDestory函数均只有一个HWND参数。那么，如何声明这些消息处理函数的签名？很简单，在WindowsX.h文件中找到定义HANDLE_WM_SIZE的地方，其上面有一行注释：

 

 [view plain](http://blog.csdn.net/tanghw/article/details/5438093#)  
   
 
  1. /* void Cls_OnSize(HWND hwnd, UINT state, int cx, int cy) */ 
  2. #define HANDLE_WM_SIZE(hwnd, wParam, lParam, fn) / 
  3. ((fn)((hwnd), (UINT)(wParam), (int)(short)LOWORD(lParam), (int)(short)HIWORD(lParam)), 0L)   
 

 Cls_OnSize函数已经给出了函数的签名，因此，我们只需将此签名复制过来，并将Cls_OnSize更名为自己选择的函数名称即可。

   
   
 