---
title: 使用镜像安装jenkins
comments: true
subtitle: 使用镜像安装jenkins，包括初始化时
author:
  nick: smallwhite
  link: 'https://github.com/whtiehack'
date: 2020-04-03 14:46:33
tags: 
  - jenkins
  - mirrors
categories: jenkins
permalink: install-jenkins-use-mirrors
---







设置jenkins插件下载镜像也可以参考。



网上好几个文章都是要不停的改 `default.json`文件。治标不治本。





### download and install Jenkins

下载地址： https://jenkins.io/zh/download/

安装过程：略



安装好以后先不要启动，如果已经启动了先停止

`jenkins stop`



#### 修改 UpdateCenter 地址为 清华的境像地址

进入 Jenkins 目录 找到 `hudson.model.UpdateCenter.xml` 文件。



 修改 `url`为  `https://mirrors.tuna.tsinghua.edu.cn/jenkins/updates/update-center.json`



#### 设置 `nginx` 或者 `caddy` 代理

* nginx

```
rewrite ^/download/plugins/(.*)$ https://mirrors.tuna.tsinghua.edu.cn/jenkins/plugins/$1? last;
```

or

```nginx
location /download/plugins
{
    proxy_next_upstream http_502 http_504 error timeout invalid_header;
    proxy_set_header Host mirrors.tuna.tsinghua.edu.cn;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for; 
    rewrite /download/plugins(.*) /jenkins/plugins/$1 break;
    proxy_pass https://mirrors.tuna.tsinghua.edu.cn;
}

```



* caddy

```caddyfile
:80 {
   gzip
   log stdout
   rewrite /download/plugins {
	  r (.*)
      to /jenkins/plugins/{1}
   }
   proxy / https://mirrors.tuna.tsinghua.edu.cn
}

```



#### 设置 `hosts` 

找到`hosts`文件 添加一行  

`192.168.1.10 updates.jenkins-ci.org`

如果 代理设置在本地 就填 `127.0.0.1`



#### 启动 Jenkins



`jenkins start`



打开 ` localhost:8080`



这样就可以有一个愉快的安装过程了。









### 更新



可以直接使用 jenkins中文社区提供的 UpdateCenter地址，就可以不需要配置代理了



`https://updates.jenkins-zh.cn/update-center.json`



不过不知道什么原因，我更换成这个地址时尝试失败了。



如果换成这个地址有问题 就停止 jenkins，地址换回去 再重新启动





### 2020/06/02 更新



`hudson.model.UpdateCenter.xml`  文件在 mac下的 `/Users/xxx/.jenkins` 目录



caddy 配置. 可以更新 war版本了.

```

:80 {
   gzip
   log stdout
   rewrite /download {
	  r (.*)
      to /jenkins/{1}
   }
   proxy / https://mirrors.tuna.tsinghua.edu.cn
}
```



