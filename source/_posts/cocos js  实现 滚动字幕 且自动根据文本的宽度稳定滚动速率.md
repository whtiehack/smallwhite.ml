---
title: cocos js  实现 滚动字幕 且自动根据文本的宽度稳定滚动速率
date: 2016-02-26 13:03:14
tags: CSDN迁移
---
  如果文本的宽度 小于 给出的限定宽度,则不滚动直接返回Label   
 否则使用ClippingNode 实现在指定宽度与高度的矩形内滚动Label.   
 返回值是Node 直接 addChild使用即可 

 
```
// 自动根据文本的宽度稳定滚动速率
text.width/width*5
```
 
```
/**
 *  创建滚动字幕
 * @param txt
 * @param fontsize
 * @param {cc.Color|null} color
 * @param width
 * @param height
 * @returns {cc.Node|*}
 */
createClipRoundText = function(txt,fontsize,color,width,height){
    var text = new cc.LabelTTF(txt,"Arial",fontsize);
    console.log('text width:'+text.width);
    text.setColor(color?color:cc.color.BLUE);
    text.anchorX = 0;
    if(text.width<=width){
        text.anchorY = 0;
        return text;
    }
    var cliper = new cc.ClippingNode();
    var drawNode = new cc.DrawNode();
    drawNode.drawRect(cc.p(0,0),cc.p(width,height),cc.color.WHITE);
    cliper.setStencil(drawNode);
    cliper.anchorX = 0.5;
    cliper.anchorY = 0.5;
    text.y = height/2;
    cliper.addChild(text);
    text.x = width+fontsize;
    text.runAction(cc.repeatForever(cc.sequence(
        cc.moveTo(text.width/width*5,cc.p(-text.width,text.y)),
        cc.callFunc(function(){
            text.x = width+fontsize;
        }))));
    return cliper;
};
```
   
  