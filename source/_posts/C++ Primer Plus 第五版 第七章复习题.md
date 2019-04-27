---
title: C++ Primer Plus 第五版 第七章复习题
date: 2008-11-18 03:41:00
tags: CSDN迁移
---
   C++ Primer Plus 第五版 第七章复习题 4  
 编写一个接受3个参数的函数,指向数组中第一个元素的指针,指向数组最后一个元素后面的一个指针 以及一个int值,  
 并将数组中所有元素设置为这个int值.  
 
 ```c++
 #include <iostream>
 
 using namespace std;
 void SetArray( int ArrFirst, int ArrEnd, int Set );
 
 
 void main()
 {
 	cout << ” begin / n ”;
 	int Arr[5] = { 1 };
 	for ( int i = 0; i < 5; ++i )
 	{
 		cout << i + 1 << ” : “ << Arr[i] << endl;
 	}
 	SetArray( Arr, Arr + 5, 10 );
 	for ( i = 0; i < 5; ++i )
 	{
 		cout << i + 1 << ” : “ << Arr[i] << endl;
 	}
 	cout << Arr[5] << endl; /* …. */
 }
 
 
 void SetArray( int ArrFirst, int ArrEnd, int Set )
 {
 	int *Now;
 	Now = ArrFirst;
 	int i = 0;
 	while ( Now != ArrEnd )
 	{
 		cout << i << ” “;
 		*Now = Set;
 		++Now;
 	}
 	cout << endl;
 }
 ```
 第七章编程练习 5

 编写将 double 数组名和长度作为参数,并返回该数组中最大值的函数.该函数不应该修改数组的内容.

 
```c++

#include  <iostream>
using namespace std;
const int ArrMax = 5;
double SelectTheMaxNumber( const double  * Arr, int Max );
void main()
{
	    double Arr[ArrMax]	= { -4534, -223, -265434, -544, -7768 };
	    double ArrT[ArrMax] = { 4534, 223, 265434, 544, 7768 };
	    double MaxNumber	= SelectTheMaxNumber( Arr, ArrMax );
	    cout  << "The Max Number is " << MaxNumber << endl;
	    MaxNumber = SelectTheMaxNumber( ArrT, ArrMax );
	    cout  << "The Max Number 2 is " << MaxNumber << endl;
	    return;
}
double SelectTheMaxNumber( const double  * Arr, int Max )
{
	    double MaxNumber = *Arr;                    /* 设置初始值为数组第一个元素 */
	    for ( int i = 1; i < Max; ++i )             /* 起始为1  跳过第一个元素 从第二个元素开始 */
	    
	{
		        if ( Arr[i] > MaxNumber )
		         {
			            MaxNumber = Arr[i];
			        
		}
		    
	}


	    return MaxNumber;
}

```

 第七章复习题8

 编写一个函数其原型如下,

 int replace(char *str,char c1,char c2);

 该函数将字符串中所有c1都替换成c2,并返回替换次数

```c++

#include  <iostream>
using namespace std;
int Replace( char  * str, char c1, char c2 );
void main()
{
	    char str[50] = "oosadrordsorewfwofwo/0";    /* ...至今搞不懂 为啥 这里改成 char *str 内存就访问出错了 */
/*   char *str="oosadrordsorewfwofwo/0"; */
		    int CiShu = Replace( str, 'o', 'A' );
	    cout  << str << endl;
	    cout  << "次数"  << CiShu << endl;
	    return;
}
int Replace( char  * str, char c1, char c2 )
{
	    int Num = 0;
	    while ( *str != 0 )
	     {
		        if ( *str == c1 )
		         {
			            ++ Num;
			            *str = c2;
			        
		}
		        ++ str;
		    
	}
	    return Num;
}

```