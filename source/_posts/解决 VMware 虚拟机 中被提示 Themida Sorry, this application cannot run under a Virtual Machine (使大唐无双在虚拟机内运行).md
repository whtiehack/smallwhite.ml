---
title: 解决 VMware 虚拟机 中被提示 Themida Sorry, this application cannot run under a Virtual Machine (使大唐无双在虚拟机内运行)
date: 2010/12/17 00:18:00
tags: CSDN迁移
---
   解决方法原文地址

 [http://communities.vmware.com/message/593280](http://communities.vmware.com/message/593280)

 

 

 记事本打开 VMX 文件 类似 Windows XP Professional.vmx 

 

 在文本末尾加入一行

 

 

 monitor_control.restrict_backdoor = "TRUE"

 

 

 

 保存文件

 

 现在启动虚拟机 就不会被Themida检测到了

 

 

 如果还被检测可以再加入一行

 disable_acceleration = "TRUE"

 

 

 

 

 这样处理以后 有个后遗症 就是 VMTools 无法加载了

 有其他更好方法的请分享分享

 

 

 ![](/images/0_1292516063Q403.gif)

 

 

 ![](/images/0_12925162934Pp9.gif)

 

   
 