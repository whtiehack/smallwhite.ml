---
title: tj大神的 co库.优雅的解决 nodejs callback无限嵌套(回调地狱)问题
date: 2016-08-05 22:05:13
tags: CSDN迁移
---
  ### github co 项目传送门

 [https://github.com/tj/co](https://github.com/tj/co)

 
### 个人比较喜欢的,用co库的姿势

 
#### 测试用函数

 
```
function fun1(arg1,arg2,cb){
    //dosomthing
    cb(null,arg1+'retval'+arg2);
}

function fun2(arg1,cb){
    //dosomthing
    cb(null,arg1+'retval2');
}

function fun3(arg1,arg2,cb){
    //dosomthing
    cb(null,arg1+'retval3'+arg2);
}


```
 
#### 正常的nodejs

 
```
function testFunNormal(targ1,cb){
    fun1(targ1+1,targ1+5,function(err,ret){
        if(err){
            cb(err);
            return;
        }
        fun2(ret+10,function(err,ret){
            if(err){
                cb(err);
                return;
            }
            fun3(ret+10,ret+5,function(err,ret){
                if(err){
                    cb(err);
                    return;
                }
                cb(null,ret+20);
            })
        })
    })
}

//test normal
testFunNormal(666,function(err,ret){
    console.log('err:',err,'ret:',ret);
});
//err: null ret: 667retval67110retval210retval3667retval67110retval2520
```
 
### 使用 tj大神的co库后

 
```
var co = require('co');

function testCo(targ1,cb){
    co(function*(){
        let ret = yield (done)=>{fun1(targ1+1,targ1+5,done)};
        ret = yield (done)=>{fun2(ret+10,done)};
        ret = yield (done)=>{fun3(ret+10,ret+5,done)};
        cb(null,ret+20);
    }).catch(cb)
}

testCo(666,function(err,ret){
    console.log('err:',err,'ret:',ret);
});
//err: null ret: 667retval67110retval210retval3667retval67110retval2520

```
 
#### 是不是感觉天空突然开阔了 ^ ^

 
##### 附上一些 toy code

 
```

'use strict';

const co = require('co');


function sleep(ms) {
    return function(done){
        setTimeout(function(){
            done(0,1111,22222)
        }, ms);
    }
}

function *work() {
    var [rr1,rr2] = yield sleep(60);
    console.log('rrr',rr1,rr2);
    return 'yay';
}



function testCo1(){
    co(function *(){
        var a = yield work;
        var b = yield work;
        var c = yield work;

        console.log('yay', a);
        console.log('yay', b);
        console.log('yay' , c);

        var res = yield [work, work, work];
        console.log(['yay', 'yay', 'yay'], res);
        return 'wwwhat'
    }).then(function(val){
        console.log('aaaa val:',val);
    },function(err){
        console.log('aaa err:',err);
    });

}


function testco2(){
    co(function *(){
        let ggg = yield function(done){
            setTimeout(function(){
                done(0,'hahfda');
            },1000);
        };
        console.log('ggg',ggg);
        let aaa = yield (done)=>{
            setTimeout(()=>{
                console.log('aafun ggg:',ggg);
                done(null,'ggret');
            },1000)
        };
        console.log('aaaa:',aaa);
        return 'ret val';
    }).then(function(val){
        console.log('aaaa val:',val);
    },function(err){
        console.log('bbbb err:',err);
    }).catch(function(err){
        console.log('err err:',err);
    });
}


function testco3(){

    var aa = co(function*(){
        console.time('cot');
        console.time('111cot');
        let ggg = yield function(done){
            done(0,'hahfda');
        };
        console.timeEnd('111cot');
        console.log('ggg',ggg);
        let aaa = yield (done)=>{
            done(null,'ggret');
        };
        console.log('aaaa:',aaa);
        console.timeEnd('cot');
    });



    console.time('nocot');


    function getggg(done){
        done(0,'hahfda');
    }

    getggg(function(err,ggg){
        console.log('ggg',ggg);
        function getaaa(done){
            done(null,'ggret');
        }
        getaaa(function(err,aaa){
            console.log('aaaa:',aaa);
        })

        return 'ret val';
    });
    console.timeEnd('nocot');

}


function isObj1(val){
    return Object == val.constructor;
}
function isObj2(val){
    return 'object' == typeof val;
}
var obj = {};
console.time('isObj1');
for (let i =0;i<500000;i++){
    isObj1(obj);
}
console.timeEnd('isObj1');

console.time('isObj2');
for (let i =0;i<500000;i++){
    isObj2(obj);
}
console.timeEnd('isObj2');
```
   
  