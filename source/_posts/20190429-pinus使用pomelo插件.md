---
title: pinus使用pomelo插件
comments: true
subtitle: pinus 与 pomelo加载插件的机制有所不同
permalink: pinus-use-pomelo-plugin
author:
  nick: smallwhite
  link: 'https://github.com/whtiehack'
date: 2019-04-29 11:53:13
tags: 
  - pinus
  - pomelo
  - nodejs
categories: pinus
---


### pinus 与 pomelo加载插件的机制有所不同



***

pinus的 app.use 需要实现  IPlugin 接口

```typescript
/**
 * 一个pinus插件
 */
export interface IPlugin extends ILifeCycle {
    /**
     * 插件的名称
     */
    name: string;

    /**
     * 启动插件时需要自动加载的组件
     */
    components ?: ComponentContructor[];

    /**
     * 启动插件时需要侦听的应用程序事件
     */
    events ?: ApplicationEventContructor[];

    /**
     * 插件暴漏的handler所在的路径
     */
    handlerPath ?: string;

    /**
     * 插件暴漏的remoters所在的路径
     */
    remoterPath?: string;

    /**
     * 插件暴漏的crons所在的路径
     */
    cronPath ?: string;
}

```

***

pomelo的app.use ，插件需要 实现这样的结构：

```javascript
module.exports = {
	components: __dirname + '/lib/components/',
	events: __dirname + '/lib/events'
};
```


通过以上的对比可以看到插件的主要区别是 `components` 和 `events`两个结构的区别，pinus需要的是 数组，而pomelo只是需要一个文件路径，内部去加载路径内的文件。

所以pinus要使用pomelo的插件 需要做的就是 把 components 与 events字段转换一下就行了

***

下面以 [pomelo-status-plugin](https://github.com/NetEase/pomelo-status-plugin) 插件为例。 当然最后也可以写一个通用的转换工具函数。

```typescript

const pomeloStatusPlugin = require('pomelo-status-plugin')

const componentsPath = pomeloStatusPlugin.components
pomeloStatusPlugin.components = [require(componentsPath+'/status')]
const eventsPath = pomeloStatusPlugin.events
pomeloStatusPlugin.events = [require(eventsPath+'/event')]
pomeloStatusPlugin.name = 'pomelo-status-plugin'



let app = pinus.createApp();



// 使用
app.use(pomeloStatusPlugin)

```


** PS: 以上代码手写，未经过测试。理论上应该没问题。 **


