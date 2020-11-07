---
title: 转换key格式OPENSSH PRIVATE KEY 转换为 RSA PRIVATE KEY
comments: true
subtitle: OPENSSH PRIVATE KEY 转换为 RSA PRIVATE KEY
author:
  nick: smallwhite
  link: 'https://github.com/whtiehack'
date: 2020-11-07 22:49:21
tags: 
  - linux
categories: linux
permalink: convert-ssh-key-format-rsa-openssh
---

### git bash 里的 scp 不支持 openssh格式的key

所以需要转换

```
-----BEGIN OPENSSH PRIVATE KEY-----
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
-----END OPENSSH PRIVATE KEY-----
```

转换为 

```
-----BEGIN RSA PRIVATE KEY-----
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
-----END RSA PRIVATE KEY-----
```

### 步骤


1. 打开 puttygen.exe

1. 点 load 加载你的 OPENSSH key文件

1. 点 Conversions -> Export OpenSSH key

1. 保存




