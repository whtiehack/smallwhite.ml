---
title: cocos2d html5 3.8.1 .修复Cocos2d Particle Builder  plist 粒子文件 base64 图片 解压错误
date: 2015-11-12 00:05:07
tags: CSDN迁移
---
   plist 粒子是 Cocos2d Particle Builder 生成的 

 cocos2dx 版本 3.8.1

 

 路径  
 frameworks\cocos2d-html5\cocos2d\compression\ZipUtils.js

 文件名称   


 ZipUtils.js.js

 已修改  13 

 删除 1  


 

 以下是补丁.

 

 

 
```
diff --git a/frameworks/cocos2d-html5/cocos2d/compression/ZipUtils.js b/frameworks/cocos2d-html5/cocos2d/compression/ZipUtils.js
index ccecd63..8288b98 100644
--- a/frameworks/cocos2d-html5/cocos2d/compression/ZipUtils.js
+++ b/frameworks/cocos2d-html5/cocos2d/compression/ZipUtils.js
@@ -25,7 +25,19 @@ cc.unzip = function () {
  */
 cc.unzipBase64 = function () {
     var tmpInput = cc.Codec.Base64.decode.apply(cc.Codec.Base64, arguments);
-    return   cc.Codec.GZip.gunzip.apply(cc.Codec.GZip, [tmpInput]);
+    var ret;
+    try{
+        ret = cc.Codec.GZip.gunzip.apply(cc.Codec.GZip, [tmpInput]);
+    }
+    catch(e){
+        console.log('unzip base64 error  try again');
+        if(tmpInput.length>8){
+            tmpInput = tmpInput.slice(7,tmpInput.length);
+            ret = tmpInput;
+        }
+    }
+
+    return ret;
 };
 
 /**

```
  
  


 

 希望有帮助

 

 

   
 