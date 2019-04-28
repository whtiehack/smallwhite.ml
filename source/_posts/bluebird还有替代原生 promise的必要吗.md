---
title: bluebird还有替代原生 promise的必要吗
date: 2018/01/10 14:52:55
tags: CSDN迁移
---
  #### []()测试代码

 
```


// global.Promise = require('bluebird').Promise;

console.log('node version:',process.version);
const co = require('co');
function* testfun_co(){
    let total = 0;
    for(let i = 0;i<10000;i++){
        total += yield done=>done(null,i);
    }
    console.log('total:',total);
}

co(function*(){

    console.time('bench origin');
    yield *testfun_co();
    yield *testfun_co();
    console.timeEnd('bench origin');


}).then(ret=>console.log('all test end'));




```
 
### []()两个版本的node 测试结果

 
#### []()v8.9.4

 
```

//  8.9.4 原生的Promise
➜  bin node "/Users/mac/Documents/testnodejs/pathtest2.js"
node version: v8.9.4
total: 49995000
total: 49995000
bench origin: 23.947ms
all test end
➜  bin node "/Users/mac/Documents/testnodejs/pathtest2.js"
node version: v8.9.4
total: 49995000
total: 49995000
bench origin: 24.263ms
all test end


// 8.9.4 bluebird
➜  bin node "/Users/mac/Documents/testnodejs/pathtest2.js"
node version: v8.9.4
total: 49995000
total: 49995000
bench origin: 43.253ms
all test end
➜  bin node "/Users/mac/Documents/testnodejs/pathtest2.js"
node version: v8.9.4
total: 49995000
total: 49995000
bench origin: 42.724ms
all test end



```
 
#### []()v6.12.3

 
```
// 原生 Promise
➜  bin ./node /Users/mac/Documents/testnodejs/pathtest2.js
node version: v6.12.3
total: 49995000
total: 49995000
bench origin: 56.907ms
all test end
➜  bin ./node /Users/mac/Documents/testnodejs/pathtest2.js
node version: v6.12.3
total: 49995000
total: 49995000
bench origin: 53.840ms
all test end


// blubird
➜  bin ./node /Users/mac/Documents/testnodejs/pathtest2.js
node version: v6.12.3
total: 49995000
total: 49995000
bench origin: 39.129ms
all test end
➜  bin ./node /Users/mac/Documents/testnodejs/pathtest2.js
node version: v6.12.3
total: 49995000
total: 49995000
bench origin: 38.773ms
all test end


```
  
  * 对于8.x版本的node,可能只有  `promisify`  还有用? 
  * 不过 node8.0加入了一个新API  `util.promisify`  … 
  * 还在使用老版本node的同学可以继续用bluebird以提升性能    
  