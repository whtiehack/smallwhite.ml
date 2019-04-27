---
title: C++ Primer Plus 第五版中文版 第六章 编程练习6
date: 2008-11-14 19:38:00
tags: CSDN迁移
---
   程序要求:  
 编写一段程序,记录捐助给"维护合法权利团体"的钱.该程序要求用户输入捐献者数目,然后要求用户输入每一个捐献者姓名和款项 . 这些信息被储存在一个动态分配的结构数组中.每个结构有两个成员.用来储存姓名的字符数组(或STRING对象)和用来储存款项的double成员.读取所有数据后.程序将显示所有捐款超过10000的捐款者姓及其捐款数额.该列表应包含一个标题.指出线面的捐款为重要捐款人. 然后程序列出其他捐款者 .. 如果某类别没有捐款者 则程序打印单词 "none".该程序只显示这2种类别 而不进行排序..  
   
//记录捐助给 "维护合法权利团体的钱"  
```c++

#include
#include
#include
using namespace std;
struct JuanZhuZhe
{
	char	name[80];
	double	money;
};
int main()
{
	cout << ” 你 大 爷 ? ”;
	int number = 0;
	cout << “ 请输入捐助 者 人数目 : ”;
	cin >> number;
	if ( number <= 0 )
	{
		cout << ” 没 捐 款 者 ~~Bye ` / n ”;
		return(1);
	}
	JuanZhuZhe	*XinXiZu	= new JuanZhuZhe[number];
	int		i		= 0;
	while ( cout << ” 请输入捐 款 人 # ” << i + 1 << ” : ” && cin >> XinXiZu[i].name && cout << ” 请输入捐 款 数 # ” << i + 1 << ” : ” && cin >> XinXiZu[i].money )
	{
		++i;
		if ( i == number )
		{
			break;
		}
	}
	if ( i == 0 )
	{
		cout << ” 没 信息 Bye / n ”;
		return(2);
	}
	cout << ” 重要捐 款 人 捐 款 数 / n ”;
	int ji = 0;
	for ( int f = 0; f < i; ++f )
	{
		if ( XinXiZu[f].money > 10000 )
		{
			cout << XinXiZu[f].name << ” “ << XinXiZu[f].money << endl;
			++ji;
		}
		if ( f == (i - 1) )
		{
			if ( ji == 0 )
			{
				cout << ” none none / n ”;
			}
		}
	}
	cout << ” 其他捐 款 者 捐 款 数 / n ”;
	ji = 0;
	for ( f = 0; f < i; ++f )
	{
		if ( XinXiZu[f].money <= 10000 )
		{
			cout << XinXiZu[f].name << ” “ << XinXiZu[f].money << endl;
			++ji;
		}
		if ( f == (i - 1) && ji == 0 )
		{
			cout << ” none none / n ”;
		}
	}
	delete[]XinXiZu;
	return(0);
}


/* 本人菜鸟一个 = =# 我到现在还不会 怎么吧 char数组换成 string 来用…貌似我看书还是不仔细.. */
```