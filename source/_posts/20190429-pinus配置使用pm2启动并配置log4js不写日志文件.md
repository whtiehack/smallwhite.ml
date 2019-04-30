---
title: pinus配置使用pm2启动并配置log4js不写日志文件
comments: true
subtitle: pinus配置使用pm2启动并配置log4js不写日志文件
author:
  nick: smallwhite
  link: 'https://github.com/whtiehack'
date: 2019-04-29 11:58:12
tags: 
  - pinus
  - pomelo
  - nodejs
categories: pinus
permalink: pinus-use-pm2-start-and-setting-log4js-not-write-logfile
---



### 这里只是讲怎么使用 [pm2](https://github.com/Unitech/pm2) 来管理pinus进程与日志，可以做一个参考。


1. 因为pm2默认是自动写日志到文件的。而本人又不太了解log4js的配置，所以找 [@mybios](https://github.com/mybios) 要了一份不会写日志文件的 log4js的配置:

log4js.json
```json
{
    "appenders": {
        "displayConsole": {
            "type": "console"
        },
        // "other": {
        //     "type": "file",
        //     "filename": "${opts:base}/logs/${opts:serverId}.log",
        //     "maxLogSize": 1048576,
        //     "layout": {
        //         "type": "basic"
        //     },
        //     "backups": 5
        // }
    },
    "categories": {
        "default": {
            "appenders": [
                /*"other",*/"displayConsole"
            ],
            "level": "debug"
        }
    },
    "replaceConsole": true,
    "prefix": "${opts:serverId} ",
    "lineDebug": false,
    "errorStack": true
}
```

这个配置只是把日志打印到标准输出而不写日志文件，所以log文件夹就不需要了。


2. 下面配置pm2启动文件

pm2启动pinus进程配置文件示例：

<details>
<summary>展开查看 pm2启动配置文件示例.json</summary>

pm2启动配置文件示例.json

```json
{
    "apps": [
        {
            "name": "master",
            "cwd": "F:\\develop\\logicServer/game-server/dist/",
            "script": "app.js",
            "args": "mode=stand-alone",
            "node_args": "--harmony",
            "exec_mode": "fork_mode"
        },
        {
            "name": "connector-server-1",
            "cwd": "F:\\develop\\logicServer/game-server/dist/",
            "script": "app.js",
            "args": "env=development  id=connector-server-1  host=127.0.0.1  port=3150  clientHost=192.168.1.10  clientPort=3010  frontend=true  serverType=connector ",
            "node_args": "  --inspect=0.0.0.0:10001",
            "exec_mode": "fork_mode"
        },
        {
            "name": "main-server-1",
            "cwd": "F:\\develop\\logicServer/game-server/dist/",
            "script": "app.js",
            "args": "env=development  id=main-server-1  host=127.0.0.1  port=5100  serverType=main ",
            "node_args": "  --inspect=0.0.0.0:10003",
            "exec_mode": "fork_mode"
        },
        {
            "name": "admin-server",
            "cwd": "F:\\develop\\logicServer/game-server/dist/",
            "script": "app.js",
            "args": "env=development  id=admin-server  host=127.0.0.1  port=6100  serverType=admin ",
            "node_args": "  --inspect=0.0.0.0:10030",
            "exec_mode": "fork_mode"
        },
        {
            "name": "purchase-server",
            "cwd": "F:\\develop\\logicServer/game-server/dist/",
            "script": "app.js",
            "args": "env=development  id=purchase-server  host=127.0.0.1  port=7100  serverType=purchase ",
            "node_args": "  --inspect=0.0.0.0:10040",
            "exec_mode": "fork_mode"
        }
    ]
}
```

</details>

这样就可以直接用pm2控制定义好的进程   
> `pm2 start pm2启动配置文件示例.json`   

> `pm2 restart pm2启动配置文件示例.json`  

> `pm2 stop pm2启动配置文件示例.json`

这种pm2配置文件我是写了个脚本来生成的。每个人的项目不一样(我们的项目有一个额外参数 cfgenv)，下面的生成脚本代码可以参考一下：

<details>
<summary>展开查看生成脚本代码</summary>


```typescript
require('ts-node/register');

let parseArgs = function (args) {
    let argsMap = {};
    let mainPos = 1;

    while (args[mainPos].indexOf('--') > 0) {
        mainPos++;
    }
    argsMap.main = args[mainPos];

    for (let i = (mainPos + 1); i < args.length; i++) {
        let arg = args[i];
        let sep = arg.indexOf('=');
        let key = arg.slice(0, sep);
        let value = arg.slice(sep + 1);
        if (!isNaN(Number(value)) && (value.indexOf('.') < 0)) {
            value = Number(value);
        }
        argsMap[key] = value;
    }

    return argsMap;
};
const program = parseArgs(process.argv);


const util = require('util');
const path = require('path');
const fs = require('fs');
const root = path.resolve(__dirname, '../');
const argroot = program['argroot'] ? program['argroot'] : root;
const cfgenv = program['cfgenv'] ? program['cfgenv'] : 'dev110';
const dist = program['dist'] === 'true' ? 'dist/' : '';
process.argv.push('cfgenv=' + cfgenv);
const env = program['env'] ? program['env'] : 'development';


const masterApp = {
    "name": cfgenv + "-master",
    "cwd": argroot + '/logicServer/game-server/' + dist,
    "script": dist ? "app.js" : "index.js",
    "args": `cfgenv=${cfgenv} mode=stand-alone env=${env}`,
    "node_args": "--harmony",
    "exec_mode": "fork_mode"
};

let     apps = [
        masterApp,
    ]

let servers = require(root + '/logicServer/game-server/' + dist + 'config/' + cfgenv + '/servers');
servers = servers[env];
if (!servers) {
    throw new Error(' no servers env ' + env);
}

let serverMap = {}, slist, i, l, server;
for (let serverType in servers) {
    slist = servers[serverType];
    for (i = 0, l = slist.length; i < l; i++) {
        server = slist[i];
        server.serverType = serverType;
        serverMap[server.id] = server;
    }
}
for (const sKey in serverMap) {
    server = serverMap[sKey];
    let cmd = 'env=' + env + ' ';
    let args = '';
    for (const key in server) {
        if (key === 'args') {
            args = server[key];
            continue;
        }
        cmd += util.format(' %s=%s ', key, server[key]);
    }
    //  console.log('cmd',sKey,cmd);
    serverMap[sKey] = {
        name: cfgenv + "-" + sKey,
        cwd: argroot + '/logicServer/game-server/' + dist,
        script: dist ? "app.js" : 'index.js',
        args: cmd,
        node_args: " " + args,
        exec_mode: "fork_mode"
    };
    apps.push(serverMap[sKey]);
}
// console.log(serverMap);
let filename = '/pm2_' + generateType + '_' + cfgenv + '_' + env + '.json';
fs.writeFileSync(__dirname + filename, JSON.stringify({apps}, null, 4));
console.log('generate success', filename, apps.map(val => val.name));


let conns = apps.filter(v => v.name.indexOf('connector') >= 0)
filename = '/pm2_' + generateType + '_' + cfgenv + '_' + env + '_only_conn_process.json';
fs.writeFileSync(__dirname + filename, JSON.stringify({apps: conns}, null, 4));
console.log('generate _only_conn_master_process success', filename, conns.map(val => val.name));

filename = '/pm2_' + generateType + '_' + cfgenv + '_' + env + '_only_logic_process.json';
apps = apps.filter(v => v.name.indexOf('connector') === -1 && v.name.indexOf('master') === -1)
fs.writeFileSync(__dirname + filename, JSON.stringify({apps}, null, 4));
console.log('generate only_logic_process success', filename, apps.map(val => val.name));


```


</details>


3. 当然你也可以不用配置文件来启动，通过人肉或者其它的方式来启动进程：

比如要独立启动master 进程

`pm2 start -n master app.js -- mode=stand-alone`

pm2要给进程传参数需要放到  `--`  后面

独立启动 connector-server-1

`pm2 start -n connector-server-1 app.js -- env=development  id=connector-server-1  host=127.0.0.1  port=3150  clientHost=192.168.1.10  clientPort=3010  frontend=true  serverType=connector`






4. 每个人的项目都是不一样的，以上只是一个参考。




