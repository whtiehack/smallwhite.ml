---
title: Lua struct
date: 2012-01-03 18:03:56
tags: CSDN迁移
---
   [http://www.inf.puc-rio.br/~roberto/struct/](http://www.inf.puc-rio.br/~roberto/struct/)

 [teststruct](http://www.inf.puc-rio.br/~roberto/struct/teststruct) [http://www.inf.puc-rio.br/~roberto/struct/teststruct](http://www.inf.puc-rio.br/~roberto/struct/teststruct)  


 

 经过测试,可以直接编译进官方lua 与 luajit内

 

 

 

 
# Library for Converting Data to and from C Structs for Lua 5.1

 
#### ([download](http://www.inf.puc-rio.br/~roberto/struct/struct.c))

 

 This library offers basic facilities to convert Lua values to and from C structs. Its main functions are  `struct.pack` , which packs multiple Lua values into a struct-like string; and  `struct.unpack` , which unpacks multiple Lua values from a given struct-like string.

 The fist argument to both functions is a _format string_, which describes the layout of the structure. The format string is a sequence of conversion elements, which respect the current endianess and the current alignment requirements. Initially, the current endianess is the machine's native endianness and the current alignment requirement is 1 (meaning no alignment at all). We can change these settings with appropriate directives in the format string.

 The elements in the format string are as follows:

 
  * `"!n"`  flag to set the current alignment requirement to _n_ (necessarily a power of 2); an absent _n_ means the machine's native alignment.
  * `">"`  flag to set mode to big endian.
  * `"<"`  flag to set mode to little endian.
  * `" "`  (empty space) ignored.
  * `"x"`  a padding zero byte with no corresponding Lua value.
  * `"b"`  a signed  `char` .
  * `"B"`  an unsigned  `char` .
  * `"h"`  a signed  `short`  (native size).
  * `"H"`  an unsigned  `short`  (native size).
  * `"l"`  a signed  `long`  (native size).
  * `"L"`  an unsigned  `long`  (native size).
  * `"in"`  a signed integer with _n_ bytes (where _n_ must be a power of 2). An absent _n_ means the native size of an  `int` .
  * `"In"`  like  `"in"`  but unsigned.
  * `"f"`  a  `float`  (native size).
  * `"d"`  a  `double`  (native size).
  * `"s"`  a zero-terminated string.
  * `"cn"`  a sequence of exactly _n_ chars corresponding to a single Lua string. An absent _n_ means 1. When packing, the given string must have at least _n_ characters (extra characters are discarded).
  * `"c0"`  this is like  `"cn"` , except that the _n_ is given by other means: When packing, _n_ is the length of the given string; when unpacking, _n_ is the value of the previous unpacked value (which must be a number). In that case, this previous value is not returned.
## Lua API

 All functions are registered inside a table  `struct` . ul>[]()

 [ `struct.pack (fmt, d1, d2, ...)` ]() Returns a string containing the values  `d1` ,  `d2` , etc. packed according to the format string  `fmt` .

 []()[]()

 [ `struct.unpack (fmt, s, [i])` ]() Returns the values packed in string  `s`  according to the format string  `fmt` . An optional  `i`  marks where in  `s`  to start reading (default is 1). After the read values, this function also returns the index in  `s`  where it stopped reading, which is also where you should start to read the rest of the string.

 

 [ `struct.size (fmt)` ]() Returns the size of a string formatted according to the format string  `fmt` . For obvious reasons, the format string cannot contain neither the option  `s`  nor the option `c0` .

 
## Installing

 To install, simply compile the file  `struct.c`  as a dynamic library. In Linux you can use the following command:

 
```
> gcc -Wall -O2 -shared -o struct.so struct.c 
```
 In Mac, you should define the environment variable  `MACOSX_DEPLOYMENT_TARGET`  as  `10.3`  and then write 
```
> gcc -bundle -undefined dynamic_lookup -Wall -O2 -o struct.so struct.c 
```
 In Windows, you must generate a DLL exporting the single symbol  `luaopen_struct` .

 
## Examples

 
  * The code  `print(struct.size("i"))`  prints the size of a machine's native  `int` .
    
     
  * To pack and unpack the structure
    
     
    ```
    struct Str { char b; int i[4]; }; 
    ```
     in Linux/gcc/Pentium (little-endian, maximum alignment of 4), you can use the string  `"<!4biiii"` .
  * If you need to code a structure with a large array, you may use  `string.rep`  to automatically generate part of the string format. For instance, for the structure
    
     
    ```
    struct Str { double x; int i[400]; }; 
    ```
     you may build the format string with the code  `"d"..string.rep("i", 400)` .
  * To pack a string with its length coded in its first byte, use the following code:
    
     
    ```
    x = struct.pack("Bc0", string.len(s), s) 
    ```
     To unpack that string, do as follows: 
    ```
    s = struct.unpack("Bc0", x) 
    ```
     Notice that the length (read by the element  `"B"` ) is not returned.
  * Suppose we have to decode a string  `s`  with an unknown number of doubles; the end is marked by a zero value. We can use the following code:
    
     
    ```
    local a = {} local i = 1 -- index where to read while true do local d d, i = struct.unpack("d", s, i) if d == 0 then break end table.insert(a, d) end 
    ```
     
  * To pack a string in a fixed-width field with 10 characters padded with blanks, do as follows:
    
     
    ```
    x = struct.pack("c10", s .. string.rep(" ", 10)) 
    ```
     
## Tests

 [File ]()[teststruct](http://www.inf.puc-rio.br/~roberto/struct/teststruct) contains a full test script for this package. It is also a good source of examples.

 
## License

 This package is distributed under the MIT license. See copyright notice at the end of file  `struct.c` .

 $Id: struct.html,v 1.4 2008/04/18 20:10:24 roberto Exp $

   
   
 