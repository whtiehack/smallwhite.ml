---
title: 学习golang的第一步-自建免费 go modules 代理
comments: true
subtitle: 用 goproxy.io 自建 go modules 代理，部署到 heroku
author:
  nick: smallwhite
  link: 'https://github.com/whtiehack'
date: 2019-04-30 17:48:12
tags: 
  - go
  - proxy
categories: go
permalink: deploy-go-modules-proxy

---


### 引子

最近想研究golang，但是被墙堵住了，科学上网又感觉太慢，而且不方便设置。

突然间发现发现了go有个变量 `GOPROXY` 可以设置代理。

然后各种baidu,gg 发现目前网上主要有这两个 `GOPROXY="https://athens.azurefd.net"` `GOPROXY="https://goproxy.io"` 代理。

但是速度都太慢了，经常有包下载不下来。 所以想研究下看能不能自己搭一个代理方便自己用。 而 goproxy.io提供了一个docker，而且heroku也支持。所有有了这篇类似教程的文章。



### 用 [goproxy](https://github.com/goproxyio/goproxy) 自建 go modules 代理，部署到 [heroku](https://heroku.com)




1. 点击下面这个按钮（或者先fork再点，这样可以自己修改部署脚本）

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy?template=https://github.com/whtiehack/goproxy/tree/master)

用 [goproxy](https://github.com/goproxyio/goproxy) 在 [heroku](https://heroku.com) 自建 go modules 代理。



![image](/images/56861611-1606b680-69d5-11e9-825a-6fa111a782ed.png)



> App name  是一个唯一的 app名字

> Choose a region 有美国和欧洲可以选。个人认为美国的速度还不错。会在region里随机分配一个节点给你，有的节点很快，有的比较慢。不过还是会比 goproxy.io 之类的快。

> 点 Create app ,等一会就部署完成了。


2. 现在你就可以使用你自建的 go modules 代理了。

linux:
`export GOPROXY=https://youappname.herokuapp.com`

windows:
`$env:GOPROXY = "https://youappname.herokuapp.com"`


3. Now, when you build and run your applications, go will fetch dependencies via `https://youappname.herokuapp.com`.


> Note: This proxy can't fetch your private repos of course.

> `youappname` 是你Crate New App 时的 App name



4. 直接打开你申请的链接应该是显示空白。

可以用这个链接测试一下： https://youappname.herokuapp.com/github.com/nsqio/nsq/@v/list


5. heroku 部署的 app，在一段时间内没有流量会被冻结。然后有人访问的时候就才会再次启动。（所以第一次打开会比较慢，启动好了就快了）

6. 提供一个懒人用测试地址，多人用不能保证速度，而且每个月是有限额的(一个人单独用完全足够)。所以还是建议自己 fork 自己建立一个 app。 https://goproxyus.herokuapp.com



###  额外的功能

* 可以用这个代理下载仓库 

1. https://goproxyus.herokuapp.com/github.com/whtiehack/goproxy/@latest

2. https://goproxyus.herokuapp.com/github.com/whtiehack/goproxy/@v/v0.0.0-20190429094219-4f70e1c14471.zip

3. latest 有个问题，不会再次去拿最新代码。

> 或者你知道明确版本的放可以构造url直接下载 : https://goproxyus.herokuapp.com/github.com/node-pinus/pinus/@v/v1.3.10.zip


* 被缓存下来的数据可以打开 https://goproxyus.herokuapp.com 直接浏览并下载。



----


### github 仓库 : <https://github.com/whtiehack/goproxy>

----



### 现有的可用的其它代理：

```shell
export GOPROXY="https://athens.azurefd.net"
export GOPROXY="https://goproxy.io"
export GOPROXY="https://goproxyus.herokuapp.com"
export GOPROXY="https://goproxy.cn"

# 最新官方的
export GOPROXY="https://proxy.golang.org"

```



别忘记开启golang的 modules 特性。



goland 可以这样设置代理：

![1557287491472](/images/1557287491472.png)



-----



#### 2019-10-10 10:35:21 更新

Go 1.13 及以上  

```
$ go env -w GOPROXY=https://yourproxy.com,direct
```



#### 2019-10-25 13:28:30 更新

Go 1.13 及以上  

```
go env -w GOSUMDB="sum.golang.google.cn"
```

#### 2019-10-28 16:16:13 更新

阿里出了一个代理   https://mirrors.aliyun.com/goproxy/

```
export GOPROXY=https://mirrors.aliyun.com/goproxy/
```



#### 2020-03-27 15:43 更新

百度提供的 go 代理  https://goproxy.baidu.com/

```
export GOPROXY=https://goproxy.baidu.com
```



#### 2020-04-02 15:03 更新

sum.golang.google.cn 可能也已经被墙处理了。特别的不稳定

可以关闭 check sum 

` go env -w GOSUMDB=off`



`-w` 是写入文件

` go env ` 可以查看自己的go变量  包括 `env` 保存的目录

