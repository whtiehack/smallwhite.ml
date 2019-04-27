---
title: pm2 自定义log, pid 等日志文件位置
date: 2016-06-27 17:20:02
tags: CSDN迁移
---
  # 方法一:

 
--------
 直接引用 pm2官方的:   
 [http://pm2.keymetrics.io/docs/usage/log-management/](http://pm2.keymetrics.io/docs/usage/log-management/)

 
### Log configuration

 
--------
 
#### CLI

 Example:

 
```
$ pm2 start echo.js --merge-logs --log-date-format="YYYY-MM-DD HH:mm Z"
```
 Options:

 
```
--merge-logs                 do not postfix log file with process id
--log-date-format <format>   prefix logs with formated timestamp
-l --log [path]              specify entire log file (error and out are both included)
-o --output <path>           specify out log file
-e --error <path>            specify error log file

```
 
#### JSON way

 
```
 {
  "script"          : "echo.js",
  "error_file"      : "err.log",
  "out_file"        : "out.log",
  "merge_logs"      : true,
  "log_date_format" : "YYYY-MM-DD HH:mm Z"
}

```
 
#### Combine out and err logs

 To combine all logs into the same file set the same value for error_file, out_file or use an additional log_file.

 For example, this keeps out and err separated but adds a combined file:

 
```
{
  "log_file": "combined.outerr.log",
  "out_file": "out.log",
  "err_file": "err.log"
}
```
 Or if you want out and err combined without any other file, just use the same log file:

 
```
{
  "out_file": "combined.log",
  "err_file": "combined.log"
}
```
 Note that relatives logs paths will usually be written in the  `PM2_HOME (~/.pm2/logs)` .

 
# 方法二:

 
--------
 修改  `~/.pm2`  目录下的  `conf.js` 

 
```
//conf.js


/**
 * Overidde PM2 configuration
 */

var p    = require('path');

module.exports = function(DEFAULT_HOME) {

  if (!DEFAULT_HOME)
    return false;

  var PM2_HOME = DEFAULT_HOME;

  var pm2_conf = {
    PM2_HOME                 : PM2_HOME,

    PM2_LOG_FILE_PATH        : p.join(PM2_HOME, 'pm2.log'),
    PM2_PID_FILE_PATH        : p.join(PM2_HOME, 'pm2.pid'),

    DEFAULT_PID_PATH         : p.join(PM2_HOME, 'pids'),
    //例如修改默认的 pm2 logs的位置. 
    DEFAULT_LOG_PATH         : '/data/pm2logs',
    DUMP_FILE_PATH           : p.join(PM2_HOME, 'dump.pm2'),

    DAEMON_RPC_PORT          : p.join(PM2_HOME, 'rpc.sock'),
    DAEMON_PUB_PORT          : p.join(PM2_HOME, 'pub.sock'),
    INTERACTOR_RPC_PORT      : p.join(PM2_HOME, 'interactor.sock'),

    GRACEFUL_TIMEOUT         : parseInt(process.env.PM2_GRACEFUL_TIMEOUT) || 8000,
    GRACEFUL_LISTEN_TIMEOUT  : parseInt(process.env.PM2_GRACEFUL_LISTEN_TIMEOUT) || 3000,

    CONCURRENT_ACTIONS       : parseInt(process.env.PM2_CONCURRENT_ACTIONS) || 1,

    DEBUG                    : process.env.PM2_DEBUG || false,
    WEB_INTERFACE            : parseInt(process.env.PM2_API_PORT)  || 9615,
    MODIFY_REQUIRE           : process.env.PM2_MODIFY_REQUIRE || false,

    PM2_LOG_DATE_FORMAT      : process.env.PM2_LOG_DATE_FORMAT !== undefined ? process.env.PM2_LOG_DATE_FORMAT : 'YYYY-MM-DD HH:mm:ss',

    INTERACTOR_LOG_FILE_PATH : p.join(PM2_HOME, 'agent.log'),
    INTERACTOR_PID_PATH      : p.join(PM2_HOME, 'agent.pid'),
    INTERACTION_CONF         : p.join(PM2_HOME, 'agent.json5')
  };

  return pm2_conf || null;
};

```
 修改完之后还不是立即生效.   
 执行一下  `pm2 kill`  来 杀掉 pm2 然后 执行  `pm2 start 你的配置`  来使修改生效.

   
  