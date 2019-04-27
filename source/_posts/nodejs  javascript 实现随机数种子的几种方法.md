---
title: nodejs  javascript 实现随机数种子的几种方法
date: 2016-07-13 20:25:55
tags: CSDN迁移
---
  ## 最简单的方法

 [http://stackoverflow.com/questions/521295/javascript-random-seeds](http://stackoverflow.com/questions/521295/javascript-random-seeds)

  
  2. 用 Math.sin  
```
var seed = 1;
function random() {
    var x = Math.sin(seed++) * 10000;
    return x - Math.floor(x);
}
```
 
##### 简单封装下

 
```
Math.seed = function(s) {
    return function() {
        s = Math.sin(s) * 10000; return s - Math.floor(s);
    };
};

// usage:
var random1 = Math.seed(42);
var random2 = Math.seed(random1());
Math.random = Math.seed(random2());

```
 2.这个稍复杂.不过随机性比sin更好.

 
```
var m_w = 123456789;
var m_z = 987654321;
var mask = 0xffffffff;

// Takes any integer
function seed(i) {
    m_w = i;
}

// Returns number between 0 (inclusive) and 1.0 (exclusive),
// just like Math.random().
function random()
{
    m_z = (36969 * (m_z & 65535) + (m_z >> 16)) & mask;
    m_w = (18000 * (m_w & 65535) + (m_w >> 16)) & mask;
    var result = ((m_z << 16) + m_w) & mask;
    result /= 4294967296;
    return result + 0.5;
}

```
 
##### 封装下

 
```
Math.seed = function(s) {
    var m_w  = s;
    var m_z  = 987654321;
    var mask = 0xffffffff;

    return function() {
      m_z = (36969 * (m_z & 65535) + (m_z >> 16)) & mask;
      m_w = (18000 * (m_w & 65535) + (m_w >> 16)) & mask;

      var result = ((m_z << 16) + m_w) & mask;
      result /= 4294967296;

      return result + 0.5;
    }
}
//usage
var myRandomFunction = Math.seed(1234);
var randomNumber = myRandomFunction();

```
 
## 正统的实现

 [https://github.com/davidbau/seedrandom](https://github.com/davidbau/seedrandom)

 `https://github.com/davidbau/seedrandom/blob/released/seedrandom.js` 

 
##### Script tag usage

 `<script src="//cdnjs.cloudflare.com/ajax/libs/seedrandom/2.4.0/seedrandom.min.js"> 
</script>` 

 
```
// Sets Math.random to a PRNG initialized using the given explicit seed.
Math.seedrandom('hello.');
console.log(Math.random());          // Always 0.9282578795792454
console.log(Math.random());          // Always 0.3752569768646784

// Sets Math.random to an ARC4-based PRNG that is autoseeded using the
// current time, dom state, and other accumulated local entropy.
// The generated seed string is returned.
Math.seedrandom();
console.log(Math.random());          // Reasonably unpredictable.

// Seeds using the given explicit seed mixed with accumulated entropy.
Math.seedrandom('added entropy.', { entropy: true });
console.log(Math.random());          // As unpredictable as added entropy.

// Use "new" to create a local prng without altering Math.random.
var myrng = new Math.seedrandom('hello.');
console.log(myrng());                // Always 0.9282578795792454

// Use "quick" to get only 32 bits of randomness in a float.
console.log(myrng.quick());          // Always 0.3752569768112153

// Use "int32" to get a 32 bit (signed) integer
console.log(myrng.int32());          // Always 986220731
```
 
##### Node.js usage

 `npm install seedrandom` 

 
```
// Local PRNG: does not affect Math.random.
var seedrandom = require('seedrandom');
var rng = seedrandom('hello.');
console.log(rng());                  // Always 0.9282578795792454

// Global PRNG: set Math.random.
seedrandom('hello.', { global: true });
console.log(Math.random());          // Always 0.9282578795792454

// Autoseeded ARC4-based PRNG.
rng = seedrandom();
console.log(rng());                  // Reasonably unpredictable.

// Mixing accumulated entropy.
rng = seedrandom('added entropy.', { entropy: true });
console.log(rng());                  // As unpredictable as added entropy.

// Using alternate algorithms, as listed above.
var rng2 = seedrandom.xor4096('hello.')
console.log(rng2());

```
   
  