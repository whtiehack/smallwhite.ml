---
title: Visual C++ 6.0 便携特别版.by.cntrump 2011.02.12
date: 2011-05-09 20:14:00
tags: CSDN迁移
---
   原来的帖子在这里：  
[http://bbs.unpack.cn/thread-60359-1-1.html](http://bbs.unpack.cn/thread-60359-1-1.html)  
又不能更新了，只能再开新帖。如果方便的话，希望版主帮忙合并一下。  
  
[![](http://www.unpack.cn:88/month_1102/110212125078b4b328dab974df.jpg.thumb.jpg)](http://www.unpack.cn/viewthread.php?tid=62556&amp;extra=&amp;highlight=%B1%E3%D0%AF%CC%D8%B1%F0%B0%E6&amp;page=1)   
[![](http://www.unpack.cn:88/month_1102/11021212509481e007c4282f39.jpg.thumb.jpg)](http://www.unpack.cn/viewthread.php?tid=62556&amp;extra=&amp;highlight=%B1%E3%D0%AF%CC%D8%B1%F0%B0%E6&amp;page=1)   
  
更新记录：  
2011-02-11  
1. 增加 TinyXml SDK。  
2. 修正不能设置 Intel C++ 编译的问题。  
3. 添加环境变量的可选设置。  
  
文件名称: vc.60.plus.20110212.7z.001  
文件大小: 100000000 字节  
修改时间: 2011年2月12日星期六, 01:56:01  
MD5: 1FF19332D8512B66C058F8C1289C4F6B  
SHA1: 44DC2A83C23DA3947366E2810B32F4B06357994B  
CRC32: 68BD82B8  
[http://u.115.com/file/f416e1d1cd](http://u.115.com/file/f416e1d1cd)  
  
文件名称: vc.60.plus.20110212.7z.002  
文件大小: 49605278 字节  
修改时间: 2011年2月12日星期六, 01:56:01  
MD5: F068E7345A126B312A92C9F528437F59  
SHA1: 139A58B43E4EB86CDB19C4D49426201BE78CADD8  
CRC32: B1636619  
[http://u.115.com/file/f47b7e0fc1](http://u.115.com/file/f47b7e0fc1)  
  
默认情况下，如果在VC6中使用了 win2000 以上才有的API，就会提示找不到函数，比如下面的代码：  
 DWORD style = GetExStyle();  
   
 if (!(style & WS_EX_LAYERED))  
 SetWindowLong(*this, GWL_EXSTYLE, style|WS_EX_LAYERED);  
   
 SetLayeredWindowAttributes(*this, 0, 128, LWA_ALPHA);  
类似的API还有 TrackMouseEvent(&tms);   
我修改了向导模板里目标平台的定义值，这样就可以直接使用这些“新”的API函数了。  
  
默认MFC使用多字节字节和不支持系统主题，我对向导进行了添加，默认添加清单文件绑定6.0版本的comctl32.dll。和可选的unicode字符集。  
[![](http://www.unpack.cn:88/month_1102/1102151302c27b4a4e90f63928.jpg.thumb.jpg)](http://www.unpack.cn/viewthread.php?tid=62556&amp;extra=&amp;highlight=%B1%E3%D0%AF%CC%D8%B1%F0%B0%E6&amp;page=1)

 

 

 

 

 

 

 

 

 

 

 

 


--------

# 

**两个文件 7z.001 7z.002 **

 **下载完注意使用 hash软件对比下 md和 sha1 **

 **确定md5或者 sha1 是对的话 再使用 7zip解压即可**

 **  
**

 


--------
   
 