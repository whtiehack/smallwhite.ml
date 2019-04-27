---
title: C数据搜索函数 仿照E的 寻找字节集
date: 2010-10-18 05:04:00
tags: CSDN迁移
---
   int SearchByteShuZu(byte * bForSearch,int ifLen, byte* bWaitSearch, int iwLen,int iFirstSearchPos) {//int SearchByteShuZu(byte * bForSearch,int ifLen, byte* bWaitSearch, int iwLen,int iFirstSearchPos);//寻找字节集数组(待寻找的,待寻找的最大长度,要寻找的,要寻找的长度,起始寻找位置) 返回-1 为未找到 位置从0开始 int iCurrentPos=0;//待搜索位置 if (iFirstSearchPos>ifLen)//超过待搜索的长度 { return -1; } if (iwLen>ifLen)//要搜索的长度比 待搜索的长度大 返回 { return -1; } if (iwLen==0||ifLen==0) { return -1;//0 返回 } // bForSearch+=iFirstSearchPos;//设置起始搜索位置 iCurrentPos+=iFirstSearchPos;//设置起始搜索位置 bForSearch+=iCurrentPos;//设置指针 对应 while(1) { while(*bForSearch!=*bWaitSearch)//找到第一个相同的 { iCurrentPos+=1;//当前搜索位置前进1 bForSearch+=1;//当前指针前进1 if (iCurrentPos>ifLen) //长度超过待搜索的整体长度返回 { return -1; } } for (int i=0;i<iwLen;++i)//开始对比 { if (*(bForSearch+i)!=*(bWaitSearch+i)) { iCurrentPos+=1;//当前搜索位置前进1 bForSearch+=1;//当前指针前进1 //设置下指针前进1 break;//找到一个不同的 跳出 } if (i+1==iwLen) { return iCurrentPos;//找到列 } } } } 

   
 