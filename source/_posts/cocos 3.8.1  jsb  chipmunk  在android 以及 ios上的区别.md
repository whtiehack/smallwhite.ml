---
title: cocos 3.8.1  jsb  chipmunk  在android 以及 ios上的区别
date: 2015-11-30 17:17:09
tags: CSDN迁移
---
  不知为何,chipmunk的 native版本 在 ios及 android上的 表现会不一样.   
 我用的是 cocos3.8.1

 
#### 这个函数 在 mac与 ios 的 native平台,调用了以后 没有任何效果.

 
```
/// Set a collision handler to be used whenever the two shapes with the given collision types collide.
/// You can pass null for any function you don't want to implement.
Space.prototype.addCollisionHandler = function(a, b, begin, preSolve, postSolve, separate)
{
    assertSpaceUnlocked(this);

    // Remove any old function so the new one will get added.
    this.removeCollisionHandler(a, b);

    var handler = new CollisionHandler();
    handler.a = a;
    handler.b = b;
    if(begin) handler.begin = begin;
    if(preSolve) handler.preSolve = preSolve;
    if(postSolve) handler.postSolve = postSolve;
    if(separate) handler.separate = separate;

    this.collisionHandlers[hashPair(a, b)] = handler;
};
```
 以下是我的碰撞检测函数.在 android及其它平台上,效果都是正常的.并且表现形式也一样.

 
```
        space.addCollisionHandler(1,
    5,self._collisionWallBegin.bind(this),null,null,null);


    _collisionWallBegin = function(arbiter, space){
        //子弹与 墙碰撞
        var self = this;
        var shapes = arbiter.getShapes();

        var collTypeA = shapes[0].collision_type;
        var collTypeB = shapes[1].collision_type;


        var p = arbiter.getPoint(0);
        var notfire = false;
        if(p.x-22>=cc.winSize.width || p.y>=350){
            notfire = true;
        }
        if(!notfire){
            //检查是什么类型子弹.别和墙碰撞
            if(!shapes[0]._bulletsprite.isCollisionBottomWall()){
                return false;
            }
        }
        console.log( 'Collision Type A:' + collTypeA );
        console.log( 'Collision Type B:' + collTypeB  + ' nofire:'+notfire + '  x:'+ p.x);
        if(shapes[0]._bulletsprite.clearBulletPartial(notfire?0.1:0.03,notfire)){
            return false;
        }
        self.space.addPostStepCallback(function(){
            self._fightLogic.attackMiss(myconfig.controlconfig.collisiontype_wall);
        });
        return false;
    }
```
 这样的代码 在 mac 及 ios上 无法工作..视觉上的确已经发生了碰撞,但是这段碰撞检测代码根本就不调用

 于是就想办法解决.

 
##### 后来尝试添加了一下 默认的 碰撞检测

 
```
/// Set a default collision handler for this space.
/// The default collision handler is invoked for each colliding pair of shapes
/// that isn't explicitly handled by a specific collision handler.
/// You can pass null for any function you don't want to implement.
Space.prototype.setDefaultCollisionHandler = function(begin, preSolve, postSolve, separate)
{
    assertSpaceUnlocked(this);

    var handler = new CollisionHandler();
    if(begin) handler.begin = begin;
    if(preSolve) handler.preSolve = preSolve;
    if(postSolve) handler.postSolve = postSolve;
    if(separate) handler.separate = separate;

    this.defaultHandler = handler;
};
```
 也就是调用这个函数添加默认碰撞检测.

 
```
this.space.setDefaultCollisionHandler(function(arbiter, space){
             //   console.log('default collision begin');
                var self = this;
                var shapes = arbiter.getShapes();
                var collTypeA = shapes[0].collision_type;
                var collTypeB = shapes[1].collision_type;
},null,null,null);
```
 
### 结果很兴奋,这个检测函数可以工作了.(为什么兴奋?工作不是才是正常的么? :( 要是你也碰到这种奇葩问题 也会很兴奋的.)

 既然可以检测碰撞了.那么 就可以解决问题了.

 为了与 其它平台能用.就做了个以下的特殊处理.问题得以解决

 
```
        if(cc.sys.os == cc.sys.OS_OSX ||cc.sys.os == cc.sys.OS_IOS )
        {//特殊处理
            var collisions = {};
            this.space.addCollisionHandler = function(typea,typeb,fun){
                if(!collisions[typea]){
                    collisions[typea] = {};
                }
                collisions[typea][typeb] = fun;
            };
            this.space.setDefaultCollisionHandler(function(arbiter, space){
             //   console.log('default collision begin');
                var self = this;
                var shapes = arbiter.getShapes();
                var collTypeA = shapes[0].collision_type;
                var collTypeB = shapes[1].collision_type;
            //    console.log( 'Collision Type A:' + collTypeA );
            //    console.log( 'Collision Type B:' + collTypeB );
                var coll = collisions[collTypeA];
                if(coll && coll[collTypeB]){
                    return coll[collTypeB](arbiter,space);
                    //特殊处理
                }else if(collisions[collTypeB] && collisions[collTypeB][collTypeA]){
                    //颠倒的.```
                    var p = arbiter.getPoint(0);
                    var myarb = {
                        getShapes:function(){
                            return [shapes[1],shapes[0]];
                        },
                        getPoint:function(x){
                            return p;
                        }
                    };
                    return collisions[collTypeB][collTypeA](myarb,space);
                }
            },null,null,null);
        }

```
 
## 大功告成!

 我后来想想 也有可能 我使用  `addCollisionHandler`  这个函数的 姿势不对?..希望有大牛帮忙解惑.

   
  