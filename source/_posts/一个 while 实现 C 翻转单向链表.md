---
title: 一个 while 实现 C 翻转单向链表
date: 2016-05-04 21:29:21
tags: CSDN迁移
---
  听说这是  `O(1) 空间复杂度 O(n) 时间复杂度`  ?有大神解释下下面这个算吗?

 
```

struct MyLink {
    MyLink* next;
    int nVal;
};


MyLink* genLink(MyLink* next,int nval){
    MyLink* tmp = new MyLink;
    tmp->nVal = nval;
    tmp->next = next;
    return tmp;
}


MyLink* reverseLink(MyLink* begin){
    MyLink* tmp = nullptr;
    while (begin){
        auto top = begin->next;
        begin->next = tmp;
        tmp = begin;
        begin = top;
    }
    return tmp;
}

void printLink(MyLink* begin,const char* prfix){
    while (begin){
        printf("%s val:%d\n", prfix, begin->nVal);
        begin = begin->next;
    }
}

int _tmain(int argc, _TCHAR* argv[])
{
    MyLink*head = nullptr;
    for (auto i = 0; i < 5; i++){
        head = genLink(head, i);
    }
    printLink(head,"orglink ");
    head = reverseLink(head);
    printLink(head,"reversed link ");

    while (head){
        auto tmp = head->next;
        delete head;
        head = tmp;
    }
    return 0;
}
```
   
  