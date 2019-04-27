---
title: redis lua  and nodejs
date: 2016-06-04 16:01:50
tags: CSDN迁移
---
  ## redis lua

 
```
--getAndUpdateRpcConfig.lua
local test = {
    aa=1,
    bb='bb'
}

-- redis.call('set','keykey','myval')
return cjson.encode(test);

```
 
## 使用

 
```
    var redisluasha = new RedisLuaSha(this.rpcredis);
    //redisluasha >自己封装的
    redisluasha.evalsha('getAndUpdateRpcConfig',0,function(err,res){
        console.log(err,res);
    });
```
 
```
//redis_lua.js
/**
 * Created by mac on 16/4/20.
 */



var fs = require('fs');
var path = require('path');


module.exports = function (redis) {
    return new RedisLuaSha(redis);
};
/**
 * luasha  map
 * @type {{}}
 */
var redisLuashaMap = {};
var luadir = path.join(__dirname,'redislua/');

/**
 * 传入redis client.   全局缓存 相同redis client的 sha map
 * @param redis
 * @constructor
 */
var RedisLuaSha = function(redis){
    this.redis = redis;
    if(!redisLuashaMap[redis]){
        redisLuashaMap[redis] = {};
    }

};


var prot = RedisLuaSha.prototype;





/**
 * 文件名后缀可有可无
 * @param fname
 * @param cb
 */
prot.getShaByFileName = function(fname,cb){
    var self = this;
    var ret = redisLuashaMap[self.redis][fname];
    if(!ret){
        console.log('begin load luafile:'+fname);
        if(!/\.lua$/.test(fname)){
            fname = fname+'.lua';
        }
        fs.readFile(path.join(luadir,fname),function(err,buf){
            if(err){
                throw err;
            }
            var str = buf.toString();
        //    console.log('load file end:'+fname,'\n',buf);
            self.redis.script('load',str,function(err,sha){
                if(err){
                    cb(err);
                    throw err;
                }
                redisLuashaMap[self.redis][fname] = sha;
                cb(null,sha);
            });
        });

    }else{
        cb(null,ret);
    }
};

/**
 * 语法糖  功能同 redis.evalsha   只是 第一个参数是 lua文件名.而不是 sha  文件名后缀可有可无
 */
prot.evalsha = function(luafilename){
    var argu = arguments;
    var fname = argu[0];
    var self= this;
    var cb = argu[argu.length-1];
    if(typeof(cb)=='function'){
        cb = null;
    }
    self.getShaByFileName(fname,function(err,sha){
        if(err){
            if(cb){
                cb(err);
            }
            console.error('get sha by filename err:',fname);
            return;
        }
        argu[0] = sha;
        self.redis.evalsha.apply(self.redis,argu);
    });
};


module.exports = RedisLuaSha;
```
 redis lua 介绍   
  `http://redis.io/commands/eval` 

   
  