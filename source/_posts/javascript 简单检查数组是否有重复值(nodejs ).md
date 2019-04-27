---
title: javascript 简单检查数组是否有重复值(nodejs )
date: 2018-08-02 10:10:11
tags: CSDN迁移
---
  * TS 版  
```
// 有重复返回true
export function checkDuplicationNormal<T>(arr: T[]) {
    return arr.some((val, idx) => {
        return arr.includes(val, idx + 1);
    });
}
```
  
  * js 版  
```
function checkDuplicationNormal(arr) {
    return arr.some((val, idx) => {
        return arr.includes(val, idx + 1);
    });
}
```
 PS:  `arr.includes(val, idx + 1);`  可以使用  `arr.indexOf(val, idx + 1)>=0`  替代。

  
  * jest 测试  
```
import {checkDuplicationNormal} from "./beanUtil";

describe('test beanUtil', () => {
    it('should checkDuplicationString correct', async () => {
        let arr = [1, 2, 3, 4];
        let ret = checkDuplicationNormal(arr);
        expect(ret).toBeFalsy();

        arr = [1, 1, 2, 3, 4];
        ret = checkDuplicationNormal(arr);
        expect(ret).toBeTruthy();

        arr = [1, 2, 3, 4, 1];
        ret = checkDuplicationNormal(arr);
        expect(ret).toBeTruthy();


        let strArr = ['3213', 'aa', 'aaa', 'a'];
        ret = checkDuplicationNormal(strArr);
        expect(ret).toBeFalsy();

        strArr = ['3213', 'a', 'aa', 'aaa', 'a'];
        ret = checkDuplicationNormal(strArr);
        expect(ret).toBeTruthy();

        let other = ['3213', 3213, 'aa', 'aaa', 'a'];
        ret = checkDuplicationNormal(other);
        expect(ret).toBeFalsy();
    });
});
```
 记录一下。

   
  