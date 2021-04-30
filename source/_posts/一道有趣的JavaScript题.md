---
title: 一道有趣的JavaScript题
catalog: true
tags:
  - JavaScript
categories:
  - front-end
translate_title: an-interesting-javascript-question
date: 2020-08-10 12:03:47
subtitle:
header_img:
---

## 题目

如下为一段代码, 请完善 sum 函数, 使得 sum(1, 2, 3, 4, 5, 6) 函数返回值为 21 , 需要在 sum 函数中调用 asyncAdd 函数, 且不能修改 asyncAdd 函数:

```js
/**
 * 请在 sum函数中调用此函数, 完成数值计算
 * @param {*} a 要相加的第一个值
 * @param {*} b 要相加的第二个值
 * @param {*} callback 相加之后的回调函数
 */
function asyncAdd(a, b, callback) {
  setTimeout(function () {
    callback(null, a + b);
  }, 100);
}

/**
 * 请在此方法中调用asyncAdd方法, 完成数值计算
 * @param  {...any} rest 传入的参数
 */
async function sum(...rest) {
  // 请在此处完善代码
}

let start = window.performance.now();
sum(1, 2, 3, 4, 5, 6).then((res) => {
  // 请保证在调用sum方法之后, 返回结果21
  console.log(res);
  console.log(`程序执行共耗时: ${window.performance.now() - start}`);
});
```

## 自己的解决方法

题目是在掘金上看到的, 立马开始动手做题, 第一时间想到的就是使用剩余参数, 然后配合 promise 做递归, 下面是我的实现方式:

```js
async function sum(...rest) {
  const [a = 0, b = 0, ...others] = rest;
  return new Promise(function (resolve, reject) {
    asyncAdd(a, b, function (arg1, callBackResult) {
      if (others.length !== 0) {
        sum(callBackResult, ...others).then((res) => {
          resolve(res);
        });
      } else {
        resolve(callBackResult);
      }
    });
  });
}
```

思路很简单, 在 sum 函数中, 返回一个 promise , 如果剩余参数的长度为 0 , 则直接 resolve asyncAdd 函数执行的回调的结果, 否则递归调用 sum, 把结果作为第一个 sum 的第一个参数, 剩余参数直接展开, 然后在递归调用的回调中, 再 resolve 结果, 最终达到题目要求。

## 标准答案

比较满意的看了看自己的代码, 觉得不错, 然后看了一下标准答案, 发现, 自己的代码执行速度还是太慢, 看一下别人的实现：

```js
// 方法一, 和我的差不多, 但是比我的更简洁。。。
async function sum1(...rest) {
  let result = rest.shift();
  for (let num of rest) {
    result = await new Promise((resolve) => {
      asyncAdd(result, num, (_, res) => {
        resolve(res);
      });
    });
  }
  return result;
}

// 方法二, 重点在于把参数两两分开, 使用 Promise.all 一次执行多个 promise
async function sum2(...rest) {
  if (rest.length <= 1) {
    return rest[0] || 0;
  }
  const promises = [];
  for (let i = 0; i < rest.length; i += 2) {
    promises.push(
      new Promise((resolve) => {
        if (rest[i + 1] === undefined) {
          resolve(rest[i]);
        } else {
          asyncAdd(rest[i], rest[i + 1], (_, result) => {
            resolve(result);
          });
        }
      })
    );
  }
  const result = await Promise.all(promises);
  return await sum(...result);
}

// 方法三, 隐氏类型转换 和 promise.all 结合使用
async function sum(...rest) {
  let result = 0;
  // 隐氏类型转换, 对象 + 数字, 会先调用对象的toString 方法
  const obj = {};
  obj.toString = function () {
    return result;
  };
  const promises = [];
  for (let num of rest) {
    promises.push(
      new Promise((resolve) => {
        asyncAdd(obj, num, (_, res) => {
          resolve(res);
        });
      }).then((res) => {
        // 把回调的结果直接给 result, obj下次计算的时候, 会自动调用 toString 方法拿到最新的 result
        result = res;
      })
    );
  }
  await Promise.all(promises);
  return result;
}
```

以上几种结果, 方法三是最快的, 本想给我的方法也做做优化, 发现我的方法确实没办法优化, 因为我是直接在 sum 里面返回 promise , 没有办法使用 promise.all 。 究其原因, 是因为我第一时间就想到用递归, 而不是 for 循环, 我发现在敲代码的过程中, 类似循环的问题, 能用递归的地方, 我第一想到的方案都是采用递归, 很少很少采用 for 循环去做某件事, 这是为什么呢？看来以后还是得转变一下思路, 递归的效率有的时候不一定是最高的。
