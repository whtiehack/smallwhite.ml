---
title: C++ Primer Plus 第五版 复习题7 函数模板 函数模板具体化
date: 2008-11-27 22:42:00
tags: CSDN迁移
---
   1. #include <iostream>  
  3.  
  5. struct box 
  7. { 
  9. int a; 
  11. int b; 
  13. int c; 
  15. int d; 
  17. }; 
  19.  
  21. template <class T> //函数模板  
  23. T MaxValue (T x,T y) 
  25. { 
  27. return x > y ? x:y; 
  29. } 
  31.  
  33.  
  35. template <> box MaxValue (box a,box b) //函数模板具体化  
  37. { 
  39. return a.a >b.a ? a : b; 
  41. } 
  43.  
  45. using namespace std; 
  47.  
  49. void main() 
  51. { 
  53. cout <<MaxValue(555,666)<<endl;  
  55. cout <<MaxValue(1.1,0.5)<<endl; 
  57. box a={1,2,3,4}; 
  59. box b={2,3,4,5}; 
  61. cout <<MaxValue(a,b).a<<endl; //重载函数模板具体化  
  63. }  
   
 