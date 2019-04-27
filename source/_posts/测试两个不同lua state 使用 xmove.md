---
title: 测试两个不同lua state 使用 xmove
date: 2011-05-21 15:16:00
tags: CSDN迁移
---
   ```
void [lua_xmove](http://pgl.yoyo.org/luai/i/lua_xmove) ([lua_State](http://pgl.yoyo.org/luai/i/lua_State) *from, [lua_State](http://pgl.yoyo.org/luai/i/lua_State) *to, int n);
```
 

 Exchange values between different threads of the _same_ global state.

 

 This function pops  `n`  values from the stack  `from` , and pushes them onto the stack  `to` .

 官方文档 介绍的 是 可以在同一个状态机内的不同线程 交换数据 

 这里的线程指的是lua自己的线程(协同程序)

 

 

 

 事实上,对于两个不同的lua_state* 如果使用lua_xmove来交换数据,xmove是不会出错的

 不过,虽然表面上看起来没问题,但是会存在一些潜伏问题

 

 实际上lua_xmove他只是交换了内存地址

 如果 from方的 垃圾收集器工作了 把这个值收回了 那么 to方 在访问这个值就会出错了

 

 还有一个情况,

 我们都知道,lua的字符串 (==)比较 都是使用字符串指针地址来比较的,因为lua内相同字符串只有一个副本.

 

 所以,如果xmove的是字符串.

 那么.我们 在 to 方 内 使用相同的字符串 与move来的字符串 做相等比较 返回的会是false.

 

 

 

 

 ---

 好了,罗嗦了这么多,其实我想表达的是

 如果move的是全局函数 是不会有任何问题的! 对于其他值 table和string 最好不要这样做

   
 