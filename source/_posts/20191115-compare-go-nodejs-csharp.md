---
title: go c nodejs csharp 可能不太准确的性能测试 
comments: true
subtitle: 用斐波那契对 go c nodejs csharp 做性能测试对比，可能不太准确
author:
  nick: smallwhite
  link: 'https://github.com/whtiehack'
date: 2019-11-15 18:28:44
tags: 
  - go
  - nodejs
  - csharp
categories: nodejs
permalink: compare-go-nodejs-csharp

---



### 斐波那契数列 (百度百科)

斐波那契数列（Fibonacci sequence），又称[黄金分割](https://baike.baidu.com/item/黄金分割/115896)数列、因[数学家](https://baike.baidu.com/item/数学家/1210991)列昂纳多·斐波那契（Leonardoda Fibonacci）以兔子繁殖为例子而引入，故又称为“[兔子数列](https://baike.baidu.com/item/兔子数列/6849441)”，指的是这样一个数列：1、1、2、3、5、8、13、21、34、……在数学上，斐波那契数列以如下被以[递推](https://baike.baidu.com/item/递推/1740695)的方法定义：F(1)=1，F(2)=1, F(n)=F(n-1)+F(n-2)（n>=3，n∈N*）在现代物理、准晶体结构、化学等领域，斐波纳契数列都有直接的应用，为此，美国数学会从1963年起出版了以《斐波纳契数列季刊》为名的一份数学杂志，用于专门刊载这方面的研究成果。



----



### 测试方法

每种语言都用递归和非递归两种方式来测试。

100w次非递归 fibonacci(50);

100次递归 fibonacci(30);



主要是测试代码执行效率。





----



#### nodejs

* 版本

```
node -v
v10.14.1
```

* 测试代码

```

console.log('test begin')

function fibonacci(n) {
    let one = 1;
    let two = 1;
    let three = 0
    for (let i = 3; i <= n; i++) {　　　　//此处代码重点部分，用three累加前两个数的和，也是斐波那契数列的精髓所在。
        three = one + two;
        one = two;
        two = three;

    }
    if (n === 1 || n === 2) {　　　　//判断n==1或2的情况下返回undefined
        return one;
    }
    return three;　　　　　　　//最后返回three
}


function fibonacci2(n) {
    if (n === 1 || n === 2) {
        return 1;
    }
    return fibonacci2(n - 1) + fibonacci2(n - 2)
}

console.log('start 1')
console.time("fibo")
for (let i = 0; i < 1000000; i++) {
    fibonacci(50)
}
console.timeEnd("fibo")

console.log('start 2')
console.time("fibo2")
for (let i = 0; i < 100; i++) {
    fibonacci2(30)
}
console.timeEnd("fibo2")
console.log('11', fibonacci(30))
console.log('22', fibonacci2(30))

```

* nodejs运行结果：

```
test begin
start 1
fibo: 57.954ms
start 2
fibo2: 833.642ms
11 832040
22 832040
```



---

#### go and c

* 版本

```
go version
go version go1.13.1 windows/amd64


gcc --version
gcc (tdm64-1) 5.1.0
Copyright (C) 2015 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

```



* 测试代码



```
package main

/*

int cfibo(int n){
	int one = 1;
	int two = 1;
	int three = 0;
	for(int i=3;i<=n;i++){
		three = one+two;
		one = two;
		two = three;
	}
	if(n==1||n==2){
		return one;
	}
	return three;
}

int cfibo2(int n){
    if (n == 1 || n == 2) {
        return 1;
    }
	return cfibo2(n - 1) + cfibo2(n - 2);
}


void testcfibo(){
	for (int i = 0; i < 1000000; i++) {
		cfibo(50);
	}
}

void testcfibo2(){
	for (int i = 0; i < 100; i++) {
		cfibo2(30);
	}
}
*/
import "C"
import (
	"fmt"
	"time"
)

func main() {
	fmt.Println("start 1")
	t1 := time.Now()
	for i := 0; i < 1000000; i++ {
		fibo(50)
	}
	fmt.Println("fibo:", time.Now().Sub(t1))

	fmt.Println("start 2")
	t1 = time.Now()
	for i := 0; i < 100; i++ {
		fibo2(30)
	}
	fmt.Println("fibo2:", time.Now().Sub(t1))
	fmt.Println("11", fibo(30))
	fmt.Println("22", fibo2(30))

	fmt.Println("c start 1")
	t1 = time.Now()
	C.testcfibo()
	fmt.Println("cfibo:", time.Now().Sub(t1))

	fmt.Println("c start 2")
	t1 = time.Now()
	C.testcfibo2()
	fmt.Println("cfibo2:", time.Now().Sub(t1))
	fmt.Println("11", C.cfibo(30))
	fmt.Println("22", C.cfibo2(30))
}

func fibo(n int) int {
	one := 1
	two := 1
	three := 0
	for i := 3; i <= n; i++ {
		three = one + two
		one = two
		two = three
	}
	if n == 1 || n == 2 {
		return one
	}
	return three
}

func fibo2(n int) int {
	if n == 1 || n == 2 {
		return 1
	}
	return fibo2(n-1) + fibo2(n-2)
}

```



* 编译命令



```
go build -ldflags="-s -w" testfibo.go
```



* go and c 运行结果：



```
start 1
fibo: 30.0017ms
start 2
fibo2: 422.0242ms
11 832040
22 832040
c start 1
cfibo: 0s
c start 2
cfibo2: 199.0114ms
11 832040
22 832040

```





----

#### csharp

* 版本



```
dotnet --version
3.0.100
```

* 测试代码



```
using System;

namespace testdot
{
    class Fibo
    {
        public static int fibo(int n)
        {
            var one = 1;
            var two = 1;
            var three = 0;
            for (var i = 3; i <= n; i++)
            {
                three = one + two;
                one = two;
                two = three;
            }
            if (n == 1 || n == 2)
            {
                return one;
            }
            return three;
        }
        public static int fibo2(int n)
        {
            if (n == 1 || n == 2)
            {
                return 1;
            }
            return fibo2(n - 1) + fibo2(n - 2);
        }
    }
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("start 1");
            var t = DateTime.Now;
            for (var i = 0; i < 1000000; i++)
            {
                Fibo.fibo(50);
            }
            Console.WriteLine("fibo {0}", (DateTime.Now - t).Milliseconds);
            Console.WriteLine("start 2");
            t = DateTime.Now;
            for (var i = 0; i < 100; i++)
            {
                Fibo.fibo2(30);
            }
            Console.WriteLine("fibo2 {0}", (DateTime.Now - t).Milliseconds);
            Console.WriteLine("11 {0}", Fibo.fibo(30));
            Console.WriteLine("22 {0}", Fibo.fibo2(30));
        }

    }
}

```



* 编译命令



```
dotnet publish -c Release
```





* 运行结果



```
start 1
fibo 41
start 2
fibo2 443
11 832040
22 832040

```





---



测试结果只是做为一个参考。



测试结果不一定准确，主要注重的是代码执行效率。

尤其是c部分的测试，用的是cgo。