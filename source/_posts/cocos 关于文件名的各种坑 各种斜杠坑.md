---
title: cocos 关于文件名的各种坑 各种斜杠坑
date: 2015-07-18 01:45:05
tags: CSDN迁移
---
   cocos 所有文件路径 的斜杠 必须 用 / 而不可以用 \ 

 不然编译到安卓各种坑

 相对路径 第一个字符不可 带 /

 

 

 

 
```
/*例如
res/test.png
这种应该是标准的


/res/test.png
这种在pc上可以工作 到安卓上不工作
*/
//pc一切正常 ,android上回调函数都不带执行的
Director::getInstance()->getTextureCache()->addImageAsync("/res/test.png",[&](Texture2D* texture){ });
//正确写法
Director::getInstance()->getTextureCache()->addImageAsync("res/test.png",[&](Texture2D* texture){ });


auto animation = Animation::create();
//这种pc正常,android上直接闪退
animation->addSpriteFrameWithFile("res\\test.png");
//正确写法
animation->addSpriteFrameWithFile("res/test.png");

```
  
  


 

 希望对刚接触cocos的同学有用

 

 

 

   
 