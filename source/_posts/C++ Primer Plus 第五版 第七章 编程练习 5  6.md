---
title:  C++ Primer Plus 第五版 第七章 编程练习 5  6
date: 2008-11-18 19:15:00
tags: CSDN迁移
---
  //第七章编程练习6  
```c++
#include
using namespace std;
const int Max = 9;
int Fill_Array( double *Arr, int Num ); /* 填充数组 */


void Show_Array( double *Arr, int Num );


void Reverse_Array( double arr[], int First, int Last );
void main()
{
	cout << ” Please Fill The Array : / n ”;
	double	Arr[Max];
	int	num = Fill_Array( Arr, Max );   /* 填充数组 */
	Show_Array( Arr, num );                 /* 显示数组元素 */
	cout << ” 翻转顺序 / n ”;
	Reverse_Array( Arr, 0, num );           /* 反转数组所有元素 */
	Show_Array( Arr, num );
	Reverse_Array( Arr, 1, num - 1 );       /* 反转除了 第一个和最后一个元素 */
	Show_Array( Arr, num );
}


int Fill_Array( double *Arr, int Num )          /* 填充数组 */
{
	cout << ” / nFill_Array : / n ”;
	if ( Num == 0 )
	{
		return(0);
	}
	int i = 0;
	while ( i != Num )
	{
		cout << ” Fill # ” << i + 1 << ” : ”;
		if ( !(cin >> Arr[i]) )
		{
			break;
		}
		++i;
	}
	return(i);
}


void Show_Array( double *Arr, int Num ) /* 显示数组 */
{
	cout << ” / nShow_Array : / n ”;
	for ( int i = 0; i < Num; ++i )
	{
		cout << ” Show # ” << i + 1 << ” : ” << Arr[i] << endl;;
	}
}


void Reverse_Array( double Arr[], int First, int Last ) /* 反转数组 */
{
	double tmp;
	Last = Last - 1;
	while ( First < Last )
	{
		tmp		= Arr[First];
		Arr[First]	= Arr[Last];
		Arr[Last]	= tmp;
		++First;
		– Last;
	}
}
```

 

  //递归计算阶乘 第七章编程练习 5  
```c++
#include
using namespace std;
double DiGuiJieChen( int Number );


void main()
{
	cout << ” Please enter a number : / n ”;
	int Number;
	cout.setf( ios_base::fixed, ios_base::floatfield );
	while ( cin >> Number )
	{
		double JieChen = DiGuiJieChen( Number );
		cout << JieChen << endl;
	}
}


double DiGuiJieChen( int Number )
{
	double Num = 1;
	if ( Number > 1 )
	{
		Num = Number * DiGuiJieChen( Number - 1 );
	}
	return(Num);
}
```