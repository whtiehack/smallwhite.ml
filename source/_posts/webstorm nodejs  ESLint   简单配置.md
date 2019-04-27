---
title: webstorm nodejs  ESLint   简单配置
date: 2016-09-03 13:54:38
tags: CSDN迁移
---
  ## ESLint 简介 官网 [http://eslint.org/](http://eslint.org/)

 在团队协作中，为避免低级 Bug、产出风格统一的代码，会预先制定编码规范。使用 Lint 工具和代码风格检测工具，则可以辅助编码规范执行，有效控制代码质量。

 在以前的项目中，我们选择 JSHint 和 JSCS 结合使用，WebStorm 等开发环境已经支持这些工具，使用起来很顺手。然而，最近使用 React JSX 语法时，却遇到了问题：JSHint 不支持 JSX 语法。虽然有 [JSXHint](https://github.com/STRML/JSXHint) 这样的 JSHint 衍生工具，但个人并不喜欢这样的实现方式：不是以插件的形式实现，而是重新重新包装了一个工具。[Nicholas C. Zakas](http://www.nczonline.net/) 也不喜欢，所以有了 [ESLint](http://eslint.org/)。

 原来选择 JSHint 的时候，也对比过 ESLint，基于 ESLint 在速度上比 JSHint 要[慢一些](https://github.com/eslint/eslint#how-does-eslint-performance-compare-to-jshint)，最终使用了 JSHint。现在需要 JSX 支持了，才发现 ESLint 的设计理念更符合实际需求。

 
--------
 ESLint 由 [JavaScript 红宝书](http://www.amazon.com/Professional-JavaScript-Developers-Nicholas-Zakas/dp/1118026691/ref=sr_1_13?tag=nczonline-20) 作者 Nicholas C. Zakas 编写， 2013 年发布第一个版本。 NCZ 的初衷不是重复造一个轮子，而是在实际需求得不到 [JSHint 团队响应](https://github.com/eslint/eslint#why-dont-you-like-jshint) 的情况下做出的选择：以可扩展、每条规则独立、不内置编码风格为理念编写一个 lint 工具。

 ESLint 主要有以下特点：

  
  * 默认规则包含所有 JSLint、JSHint 中存在的规则，易迁移； 
  * 规则可配置性高：可设置「警告」、「错误」两个 error 等级，或者直接禁用； 
  * 包含代码风格检测的规则（可以丢掉 JSCS 了）； 
  * 支持插件扩展、自定义规则。  ESLint 已经[宣布支持 JSX](http://eslint.org/blog/2014/11/es6-jsx-support/)，不过目前为 alpha 版本，正式版发布之前可以先使用 [eslint-plugin-react](https://www.npmjs.com/package/eslint-plugin-react) 替代。

 
--------
 
#### 更详细请移步 [https://github.com/Jocs/ESLint_docs](https://github.com/Jocs/ESLint_docs)

 
--------
 
## webstorm 的 nodejs ESLint 环境配置

  
  * 首先安装ESLint   
      `npm install eslint -g`    
     webstrom 要启用 eslint自动检测,需要 eslint全局安装 
  * 配置一下  `.eslintrc`  文件 放在项目根目录  
```
    {
        "extends": "eslint:recommended",
        "env":{
          "node":true,
          "es6":true
        },
        "rules": {
            "semi": ["error", "always"],
            "quotes": "off",
            "no-console":"off",
            "no-unused-vars":"off",
            "no-unreachable":"off",
            "no-redeclare":"warn"
        }
    }
```
  
  * 可选配置,让eslint忽略检测的文件  `.eslintignore`  配置规则与  `.gitignore`  一样  
```
#井号是注释  根据自己的项目需要进行忽略
# 如果 .eslintrc 开启了 env  nodejs 那么 默认 node_modules是自动忽略的
node_modules
/node_modules/**
*.sh
game-server/web-server
game-server/web-server/**
tools
tools/**
test
test/**
game-server/purchase-server/lib/seedrandom.js
game-server/app/staticData/data/temp/*.js
```
  
  * 打开webstorm   
     选择 `File | Settings | Languages & Frameworks | JavaScript | Code Quality Tools | ESLint`  勾选 Enable .
    
     
  * 至此,在 webstorm内, eslint已经可以工作了. webstorm可以自动提示 eslint指出的代码问题.
    
      
--------
 
#### 如需要手动检查所有代码的问题 ,可以打开 webstorm的 terminal,

 输入  `eslint .` 

 
#### 如需要自动修复一些不规范的代码问题 ,例如 没有分号的问题,可以

 输入  `eslint . --fix`    
 [http://eslint.org/docs/rules/](http://eslint.org/docs/rules/) 带小扳手的规则都可以自动修复.

   
  