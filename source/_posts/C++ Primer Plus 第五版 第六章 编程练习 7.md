---
title: C++ Primer Plus 第五版 第六章 编程练习 7
date: 2008-11-14 20:42:00
tags: CSDN迁移
---

```c++
/* 第六章 编程练习 7
编写一个程序,它每次读取一个单词,直到用户只输入q.然后,该程序指出有多少个单词以元音打头,有多少个
单词以辅音打头,还有多少格单词不属于这类. 为此,方法之一是,使用isalpha()来区分以字母和其他字符打头的
单词,然后对于通过了isalpha()测试的单词,使用if或switch语句来确定哪些以元音打头.
该程序的运行情况如下:
Enter words (q to exit):
The 12 awesome oxen ambled
quietly across 15 meters of lawn. q
5 words beginning with vowels
4 words beginning with consonants
2 others
a,o,e,i.u是元音，其余的都是辅音
*/
#include#include using namespace std;
int main() {
    int YuanYin = 0;
    int FuYin = 0;
    int Others = 0;
    char str[80]; //还是不会怎么用 STRING………..
    bool end = false; //..放一个BOOL变量控制循环…
    cout << ”Enter words(q to exit) : /n”;
while (cin>>str && false == end ) / / {
        // cout <<str<<endl;
        if (isalpha(str[0]) > 0) {
            switch (str[0]) {
            case‘a’:
            case‘o’:
            case‘e’:
            case‘i’:
            case‘u’:
            case‘A’:
            case‘O’:
            case‘E’:
            case‘I’:
            case‘U’:
                ++YuanYin;
                break;
            case‘q’:
                if (strlen(str) == 1) {
                    end = true; //读取到单独的Q
                    break;
                }
            default:
                ++FuYin;
            }
            if (end) break; //读取到 单独的 Q 跳出循环
            continue; //否着继续下一次循环
        }++Others; //非字母
    }
    cout << YuanYin << ”words beginning with vowel / n”;
    cout << FuYin << ”words beginning with consonants / n”;
    cout << Others << ”others / n”;
    return 0;
}
```
 