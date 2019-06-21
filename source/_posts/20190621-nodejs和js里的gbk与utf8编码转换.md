---
title: nodejs和js里的gbk与utf8编码转换
comments: true
subtitle: nodejs和js里的gbk与utf8编码转换
permalink: nodejs-js-gbk-utf8-encode
author:
  nick: smallwhite
  link: 'https://github.com/whtiehack'
date: 2019-06-21 19:36:33
tags: 
  - javascript
  - nodejs
categories: nodejs
---


### nodejs和js里的gbk与utf8编码转换





##### js 与 nodejs 都有  `TextEncoder` `TextDecoder` ，可以进行编码之间的转换

> nodejs 版本需要 >=8.3.0 才支持    [util.TextEncoder,util.TextDecoder ](<https://nodejs.org/api/util.html#util_class_util_textdecoder>)

> gbk 转 utf8

```
new TextDecoder('gbk').decode(new Uint8Array([ 47, 63, 214, 208, 206, 196, 61, 56, 56 ]).buffer)
// out:  "/?中文=88"
```





##### nodejs 建议通过 [iconv](https://www.npmjs.com/package/iconv)  or [iconv-lite](https://www.npmjs.com/package/iconv-lite)第三方库进行编码之间的转换。因为使用原生 TextEncoder需要完整的 ICU Data 具体看这里  [util_class_util_textdecoder](<https://nodejs.org/dist/latest-v10.x/docs/api/util.html#util_class_util_textdecoder>)



> utf8   gbk 互转

```
let iconv = require('iconv-lite');
// 这里是utf8
let str = '/?中文=88';
// 转换成gbk
let encoded = iconv.encode(str, 'gbk');
console.log(encoded,encoded.toJSON())

str = iconv.decode(Buffer.from([ 47, 63, 214, 208, 206, 196, 61, 56, 56 ]), 'gbk');
console.log('utf8 str:',str)

// out: Buffer <2F, 3F, D6, D0, CE, C4, 3D, 38, 38>
// Object {data: [47, 63, 214, 208, 206, 196, 61, 56, 56], type: "Buffer"}
// utf8 str: "/?中文=88"
```





