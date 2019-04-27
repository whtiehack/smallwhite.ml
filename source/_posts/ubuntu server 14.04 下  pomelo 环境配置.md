---
title: ubuntu server 14.04 下  pomelo 环境配置
date: 2015-12-24 11:27:41
tags: CSDN迁移
---
  记录下配置过程.以后方便查找

  
  2. sudo su – 输入密码   
      如果分配的密码是随机的,那么先改密码吧. passwd ubuntu - ubuntu 是用户名 
  4. apt-get update 
  6. 安装nodejs   
      [https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions](https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions)   
      其实就3个命令   
       `curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash - 
apt-get install -y nodejs 
apt-get install -y build-essential`    
      可以 输入 node -v 测试下   
      npm -v 测试下 npm 
  8. 安装pomelo   
       `npm install pomelo -g` 
     
      
  10. ok 配置完成.到你的 gameserver 目录 执行   
       `npm install`    
      大功告成
     
       现在已经可以运行pomelo 了   
  `pomelo start -e production -D`  //-D是后台执行的意思

 
```
但是.pomelo会出现错误 
    `[ERROR] console - the command pidstat failed! Error: Command failed: /bin/sh: pidstat: not found`

执行下  `apt-get install sysstat`  解决错误

```
 
--------
 但是还有其它东西要配置. 比如 ftp 传文件用 用 vsftpd 即可   
 1. apt-get install vsftpd   
 2. vim /etc/vsftpd.conf   
 设置 以下配置   
 local_enable=YES   
 write_enable=YES   
 3. esc :wq 保存退出   
 4. service vsftpd restart 重启下 vsftpd 服务   
 5. 我用的腾讯云,现在已经可以用linux帐号使用ftp了

 
```
    还有redis.一定要记得.给redis配置密码. 或 bind ip

```
   
  