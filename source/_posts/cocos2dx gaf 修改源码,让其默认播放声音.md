---
title: cocos2dx gaf 修改源码,让其默认播放声音
date: 2015-11-12 00:24:04
tags: CSDN迁移
---
  ### flash 有播放声音时,需要手动设置一个delgate.

 
#### 可是我的客户端用的cocos js,为了图省事,直接修改源码

 
##### mark一下

 
#### 以下补丁..

 
```

------------ frameworks/runtime-src/Classes/gafplayer/GAFAsset.cpp ------------
index e6c8ddf..0c75313 100644
@@ -11,7 +11,7 @@
 #include "GAFLoader.h"

 #include "json/document.h"
-
+#include "AudioEngine.h"
 NS_GAF_BEGIN

 //static float  _desiredCsf = 1.f;
@@ -97,6 +97,15 @@ GAFAsset* GAFAsset::create(const std::string& gafFilePath, GAFTextureLoadDelegat
     if (ret && ret->initWithGAFFile(gafFilePath, delegate, customLoader))
     {
         ret->autorelease();
+       //delgate sound
+       ret->setSoundDelegate([ret](GAFSoundInfo* sound, int32_t repeat, GAFSoundInfo::SyncEvent syncEvent){
+           std::string path = ret->getGAFFileName();
+           int slashPos = path.find_last_of("/");
+           path = path.substr(0, slashPos + 1);
+           path.append(sound->source);
+
+           cocos2d::experimental::AudioEngine::play2d(path, repeat == -1);
+       });
         return ret;
     }
     CC_SAFE_RELEASE(ret);


```
   
  