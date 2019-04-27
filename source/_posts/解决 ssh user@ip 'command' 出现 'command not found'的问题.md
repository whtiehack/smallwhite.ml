---
title: 解决 ssh user@ip 'command' 出现 'command not found'的问题
date: 2016-06-18 15:20:15
tags: CSDN迁移
---
  环境 centos6.5   
 状况 A机器 ssh user@B机器 ‘command’ 执行命令_(B机器添加了对A机器的信任)_   
 提示  `'bash: node: command not found'` 

 使用  `ssh user@B机器`  手动执行命令是没有问题的  `echo $PATH;node -v`  也是正常的

 
```
-bash-4.1$ ssh root@B机器IP
Last login: Sat Jun 18 15:14:35 2016 from A机器IP
[root@IOS-Account ~]# echo $PATH;node -v
/data/soft/node/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/sbin:/root/bin
v4.4.4
```
 使用  `ssh user@B机器 'echo $PATH;node -v'`  打印的环境变量路径 与login 方式打印的路径不一样.

 
```
-bash-4.1$ ssh root@B机器IP 'echo $PATH;node -v'
/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/sbin
bash: node: command not found
```
 根据[这篇文章](http://blog.csdn.net/whitehack/article/details/51705889), 找到了原因.   
 以下这两个登录方式的环境变量是不一样的   
  `ssh user@ip`  登录以后是有交互的   
  `ssh user@ip 'command'`  登录以后直接执行命令,然后退出

 最后我的解决方式是

 
```
ssh root@B机器IP 'source ~/.bash_profile;echo $PATH;node -v'
```
 结果:

 
```
-bash-4.1$ ssh root@B机器IP 'source ~/.bash_profile;echo $PATH;node -v'
/data/soft/node/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/sbin:/sbin:/root/bin
v4.4.4
```
   
  