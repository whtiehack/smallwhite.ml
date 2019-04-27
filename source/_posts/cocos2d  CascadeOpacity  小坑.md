---
title: cocos2d  CascadeOpacity  小坑
date: 2015-10-09 18:09:49
tags: CSDN迁移
---
   layer FadeOut action 貌似 默认 CascadeOpacity 都是关闭的

 

 

 如果是关闭状态,子节点的 透明度就不受父节点的影响.

 

 开启方法 

 

 
```
layer->setCascadeOpacityEnabled(true)
```
 
```
layer->isCascadeOpacityEnabled()   //可获取开启状态

```
   


 

 

 

 

 

 

 

   
 