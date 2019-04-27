---
title: nodejs 捕获 promise 未处理的  reject
date: 2016-09-23 11:58:14
tags: CSDN迁移
---
  #### 正常情况下,对于没有捕获的 promise的reject 会直接静默的吃掉.而这不是我们想要的.

 
##### 复现一下看看

 
```
function cb(){
    console.log('444');
    fdsaf.fdafdas = 777;
}

new Promise((resolve,reject)=>{
    cb(1)
})
```
 
### 解决:

 
#### 文档

 [https://nodejs.org/dist/latest-v4.x/docs/api/process.html#process_event_unhandledrejection](https://nodejs.org/dist/latest-v4.x/docs/api/process.html#process_event_unhandledrejection)

 
```
process.on('unhandledRejection', (reason, p) => {
    console.log("Unhandled Rejection at: Promise ", p, " reason: ", reason);
    // application specific logging, throwing an error, or other logic here
});
```
 
### toy code

 
```
process.on('unhandledRejection', (reason, p) => {
    console.log("Unhandled Rejection at: Promise ", p, " reason: ", reason);
    // application specific logging, throwing an error, or other logic here
});
function cb(){
    console.log('444');
    fdsaf.fdafdas = 777;
}

new Promise((resolve,reject)=>{
    cb(1)
})
```
 
### toy code2 co

 
```
process.on('unhandledRejection', (reason, p) => {
    console.log("Unhandled Rejection at: Promise ", p, " reason: ", reason.stack);
    // application specific logging, throwing an error, or other logic here
});
var co = require('co');

function cb(){
    console.log('444');
    fdsaf.fdafdas = 777;
}

co(function*(){
    console.log('1111');
    throw 'myerror```';
}).then(function(value) {
    console.log(value); // Success!
}).catch(err=>{
    console.log('222');
    console.log(err); // Error!
    cb();
    console.log('!!!!');
}).catch(err=>{
    console.log('aaa :',err);
})
```
 nodejs 6.6以后.对没有捕获的 reject 会发出一个警告.

 
> promises: Unhandled rejections now emit a [process warning](https://nodejs.org/dist/latest-v6.x/docs/api/process.html#process_event_warning) after the first tick. (Benjamin Gruenbaum) [#8223](https://github.com/nodejs/node/pull/8223)
> 
>  
   
  