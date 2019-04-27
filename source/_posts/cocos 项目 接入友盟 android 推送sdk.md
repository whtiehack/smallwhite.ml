---
title: cocos 项目 接入友盟 android 推送sdk
date: 2016-03-06 21:07:25
tags: CSDN迁移
---
  ### 对于 cocos 项目,按照友盟的官网文档接入步骤. 是无法成功编译的.

 所以在这里做个记录.希望对和我一样是android菜鸟的同学有用   
 我用的SDK版本是最新的 2.7.0

 
### 1.先按照官网的步骤接入.

  
  * 把下载的SDK里面的PushSDK当做library引用导入自己的项目。  
    这一步对于不用 eclipse的我来说.就是在 `project.properties` 很简单的添加一行代码  `android.library.reference.1=../PushSDK`  ,然后把sdk copy到 `proj.android` 的同级目录 
  * 把AndroidManifest.xml里面的${applicationId}替换成为自己项目的包名。 
  * 把下载的eclipselibs目录下的okio-0.6.1.jar、wire-runtime-1.7.0.jar这两个文件拷贝到PushSDK的libs目录下。 
  * 在自己项目的目录下找到project.properties，在里面加入manifestmerger.enabled=true。 
  * 如果是android6.0以上的api编译，把SDK目录下的libs/里面的org.apache.http.legacy.jar拷贝到PushSDK的libs目录，然后加入buildpath里面( `这一步我暂时没有做,后面接入gg的广告可能要整一下` )
    
     
  * 然后是  `android-support-v4.jar`  .这个包应该是需要的. 直接baidu一个 放到  `proj.android`  的libs目录下即可   
     这是官网描述 `注意: 本SDK需要最新版本的 android-support-v4.jar 支持包。请在工程中添加 android-support-v4.jar 支持包。 关于v4 支持包说明， 请参考 http://developer.android.com/tools/support-library/features.html#v4。`    
       
    
    
      
#### 2.添加AppKey & Umeng Message Secret   
在项目工程的AndroidManifest.xml中的 `<Application>` 标签下添加:

 
```
<meta-data
    android:name="UMENG_APPKEY"
    android:value="xxxxxxxxxxxxxxxxxxxxxxxxxxxx" >
</meta-data>
<meta-data
    android:name="UMENG_MESSAGE_SECRET"
    android:value="xxxxxxxxxxxxxxxxxxxxxxxxxxxx" >
</meta-data>
```
 把上述的 `umeng_appkey` 和 `umengmessage_secret` 修改为和自己App对应的值

 

 
#### 3.添加Channel ID

 你可以用Channel ID来标识APP的推广渠道，作为推送消息时给用户分组的一个维度。设置方法如下：   
 在 `<application>` 标签下：

 
```
<meta-data
    android:name="UMENG_CHANNEL"
    android:value="Channel ID" >
</meta-data>
```
 
```
将"android:value"中的"Channel ID"替换为APP的推广渠道。

```
 

 
#### 4.添加代码

 
```

import com.umeng.message.PushAgent;
import com.umeng.message.IUmengRegisterCallback;


    protected void onCreate(Bundle savedInstanceState) {
        // TODO Auto-generated method stub
        super.onCreate(savedInstanceState);
        MobClickCppHelper.init(this);
        //这里是要添加的部分
        PushAgent mPushAgent = PushAgent.getInstance(this);
        mPushAgent.enable();
        mPushAgent.onAppStart();
        //要添加部分结束
        if(nativeIsLandScape()) {
            setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_SENSOR_LANDSCAPE);
        } else {
            setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_SENSOR_PORTRAIT);
        }
        if(nativeIsDebug()){
            getWindow().setFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON, WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
        }
        hostIPAdress = getHostIpAddress();
    }

```
 `mPushAgent.enable();` 可以换成下面这个版本. 来获取测试设备的 device_token 用于测试推送消息

 
```
mPushAgent.enable(new IUmengRegisterCallback() {
    @Override
    public void onRegistered(String registrationId) {
        //onRegistered方法的参数registrationId即是device_token
        Log.d("device_token", registrationId);
    }
});
```
 

 到此为止,官网的步骤已经结束了. 可是我用cocos studio编译是不通过的.而且完全看不到 `编译错误` 在哪. 你可以编译试试   
   
  


 
### 5.好了.下面才是针对cocos项目的重头戏

  
  2. 在下载的sdk包里 找到这个文件  `proguard-rules.txt`  copy到  `PushSDK`  目录下 
  4. 在 `PushSDK`  目录下创建一个 `src`  文件夹 
  6. 在 `src`  目录下创建一个 `com` 文件夹 
  8. 在 `com`  目录下创建一个 `whatulike`  文件夹 
  10. 在 `whatulike`  目录下创建一个 `whatulike2` 文件夹 
  12. 在 `whatulike2`  目录下创建一个 `whatulike.java` 文本文件  `whatulike.java` 内容 随你,可以复制下面的…

 
```
package com.whatulike.whatulike2;

import android.app.Activity;
import android.os.Bundle;

public class WhatULike extends Activity{
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }

    @Override
    protected void onDestroy() {
        // TODO Auto-generated method stub
        super.onDestroy();
    }
}
```
 目前为止,你应该可以正确的编译了.用eclipse或者 cocos studio 都可以编译

 然后就可以运行难是否成功接入以及查看测试设备的  `device_token`  

 对于用 nodejs 接入推送api的问题,   
 这里有个现成的轮子 [https://www.npmjs.com/package/umengpush-node](https://www.npmjs.com/package/umengpush-node)

 have fun day.

   
  