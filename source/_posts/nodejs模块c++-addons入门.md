---
title: nodejs模块c++addons入门
tags:
  - nodejs
  - JavaScript
categories:
  - front-end
translate_title: getting-started-with-nodejs-module-c++-addons
date: 2021-03-30 13:17:19
subtitle:
header-img:
---

## what

打算好好学习一下 nodejs，那就先从 nodejs 官方文档看起吧，这篇博客主要是记录一下 nodejs 下的 c++ addnos 模块，看 nodejs 为什么要引入 c++ ，以及如何引入 c++ 代码。

[c++ addons 官方文档](https://nodejs.org/docs/latest-v9.x/api/addons.html)

## why

> nodejs 采用事件驱动、异步编程，为网络服务而设计。其实 Javascript 的匿名函数和闭包特性非常适合事件驱动、异步编程。非阻塞模式的 IO 处理给 Node.js 带来在相对低系统资源耗用下的高性能与出众的负载能力，非常适合用作依赖其它 IO 资源的中间层服务。

Nodejs 虽然有着不错的异步能力，但是在密集型计算的时候却并不出众，简单来说所有的异步任务会维护在一个事件循环中(队列)，线程会不断的去事件循环中取任务来执行，当 CPU 密集型的任务造成执行时间过长，就会导致其他任务无法执行，这样整个程序的性能就不行了。这个时候就可以用 c++ 来编写一些 nodejs 模块，加快运算时间。

## how

以 fibonacci 函数为例，先看一下运行结果。

```js
var fibonacciC = require("./build/Release/fibonacci.node").fibonacci;
function fibonacciJS(n) {
  if (n <= 0) return 0;
  else if (n == 1) return 1;
  else return fibonacciJS(n - 1) + fibonacciJS(n - 2);
}

console.time("c++");
console.log(fibonacciC(40));
console.timeEnd("c++");

console.time("js");
console.log(fibonacciJS(40));
console.timeEnd("js");

// 输出
102334155
c++: 524.515ms
102334155
js: 1.335s
```

在 40 次的递归运算中，可以看到采用原生 js 实现的方式，时间是 c++ 方式实现的两倍多，如果计算时间更长的话，原生 js 实现的效率更低。

接下来看一下是如何把 c++ 的代码结合到 nodejs 中。

### 编写 c++ 代码

```c++
// fibonacci.cc
#include <node.h>

using namespace std;

namespace demo {

using v8::FunctionCallbackInfo;
using v8::Isolate;
using v8::Local;
using v8::Object;
using v8::Number;
using v8::Value;

int fib(int n) {
   if (n <= 0)
        return 0;
    else if (n == 1)
        return 1;
    else
        return fib(n - 1) + fib(n - 2);
}

/* 通过 FunctionCallbackInfo<Value>& args 可以设置返回值 */
void fibonacci(const FunctionCallbackInfo<Value>& args) {
  Isolate *isolate = args.GetIsolate();
  // node v10 版本之前是这样获取 number 参数的
  // args[0]->NumberValue()
  // v10 版本之后是这样获取的
  // args[0].As<Number>()->Value()
  Local<Number> num = Number::New(isolate, fib(args[0].As<Number>()->Value()));

  // 设置函数调用的返回值
  args.GetReturnValue().Set(num);
  return ;
}

void Initialize(Local<Object> exports) {
  // 指定 module 名字
  NODE_SET_METHOD(exports, "fibonacci", fibonacci);
}

// 加载 module
NODE_MODULE(NODE_GYP_MODULE_NAME, Initialize)

}
```

### 编译 c++ 代码

```bash
# 首先要安装 node-gyp
npm i -g node-gyp
```

在当前目录下添加 `binding.gyp` 文件，内容为:

```js
{
  "targets": [
    {
      "target_name": "fibonacci",
      "sources": [ "fibonacci.cc" ]
    }
  ]
}
```

运行打包编译命令

```bash
# 先打包
node-gyp  configure
# 会生成一个 build 目录，然后进入这个目录
cd build
# 编译文件
make
```

这个时候会生成一个 build 目录，以及 build 目录下的 Release 目录。

### 引入 c++ 模块

接下来就可以像这样引入该模块

```js
var fibonacciC = require("./build/Release/fibonacci.node").fibonacci;
console.log(fibonacciC(40));
```

## 总结

引入 c++ ，借助其高效的计算能力，可以让 nodejs 也进行一些密集型的计算，本文只是一个简单的实例，更多强大的功能还需要看官方文档以及熟悉 c++ 才行。
