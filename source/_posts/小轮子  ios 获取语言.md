---
title: 小轮子  ios 获取语言
date: 2016-03-04 11:35:07
tags: CSDN迁移
---
  ```
//只有3种返回结果 zh-TW zh-CN  en-US
+(NSString *) getLanguage
{
    NSString* pkLan = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0];
    NSLog(@"ios取语言...函数调用  pkLan:%@",pkLan);
    if(![pkLan compare:@"zh-HK"]){
        return @"zh-TW";
    }
    else if(![pkLan compare:@"zh-TW"]){
        return @"zh-TW";
    }
    else if([pkLan length]>=7&&  ![pkLan compare:@"zh-Hans" options:NSAnchoredSearch range:NSMakeRange(0,7)])
    {
        return @"zh-CN";
    }
    else if([pkLan length]>=7&& ![pkLan compare:@"zh-Hant" options:NSAnchoredSearch range:NSMakeRange(0,7)])
    {
        return @"zh-TW";
    }
    else
    {
        return @"en-US";
    }
}
```
   
  