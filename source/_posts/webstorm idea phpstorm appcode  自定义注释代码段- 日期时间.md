---
title: webstorm idea phpstorm appcode  自定义注释代码段- 日期时间
date: 2015-09-29 14:50:28
tags: CSDN迁移
---
  live template 即可实现.无需插件

 最终效果

 
```
/** 2015/09/20 01:33:34
 * end */
```
  
  2. 打开 settings(win) or preferences 
  4. 找到 editor下的 live template 
  6. 选中你的语言 
  8. 点右边的 + 号 
  10. Abbreviation 是自动完成的提示缩写(例如:nowtime) description 描述(例如:now time.comment)   
      template text 模板文件内容 例如:   
       ` 
  /** $nowtime$ 
<ul><li>$end$ */  
`  
  12. 然后点 edit variable 
  14. 在 nowtime 一行 输入  `date("yyyy-MM-dd HH:mm:ss")`  或者 data() 等你要的格式化效果 
  16. 勾选 skip if define 点 ok 
  18. 选中 reformat according to style (会根据你输入的位置智能缩进) 
  20. (No applicable contexts yet.) Define (点它.与相应的语言相关联) 
  22. 大功告成!  可以到 编辑器里 输入 你定义的 Abbreviation 试试了 .例如:nowtime +tab

 idea 太强大了

   
  