---
title: js-彻底了解this的指向
catalog: true
tags:
  - JavaScript
categories:
  - front-end
translate_title: js-thoroughly-understand-the-point-of-this
date: 2020-09-07 17:37:16
subtitle:
header_img:
---

## 起因

对 js 的 this 指向问题还是会有点模糊，我决定下点功夫，写下这篇文章，彻底把 this 搞明白。

## 什么是 this ？

这也是我发出的第一个问题，究竟什么是 this ？在 js 中 this 代表的到底是什么？根据 [w3c](https://www.w3schools.com/js/js_this.asp) 的描述：

> The JavaScript this keyword refers to the object it belongs to.

> 在 js 中 this 关键字代表它所属对象的引用。

再根据 [MDN](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Operators/this) 的描述，

> In the global execution context (outside of any function), this refers to the global object whether in strict mode or not.

> this 表示当前执行上下文( global、function 或 eval )的一个属性，在非严格模式下，总是指向一个对象，在严格模式下可以是任意值。

由此可见 this 的指向是不确定的，是在运行时确定的，而且 this 在不同的情况下，其代表的含义也不一样。

下面我将通过本文，彻底分析 this 的所有形式。

> 注：全局对象，在浏览器端代表 window 对象，在 nodejs 环境下代表 global 对象，以下不再区分，简称全局对象。

## this 存在的情形

首先要考虑 this 一般会出现在哪些情况呢？

1. 全局状态下
2. 一般函数内
3. this 和对象转换
4. 原型链中
5. 与 DOM 相关

其实 this 一般都是出现在函数内，所以在第六点单独称之为 「一般函数」，下面分别分析。

### 全局状态下

无论是否在严格模式下，在全局执行环境中(在任何函数体外部) this 都指向`全局对象`。如:

```js
console.log(this); // 全局对象
```

### 一般函数内

在全局状态下、对象内、class 内等的函数，我称之为一般函数，也是使用最多的情况。

#### 函数在全局状态下

`在普通函数内部，this 的值取决于函数被调用的方式。`在严格模式下，如果进入执行环境时没有设置 this 的值，this 会保持为 undefined，非严格模式下指向全局对象。

`在箭头函数中，this 取决于函数被创建时的环境。`因此在全局情况下，无论是否为严格模式，this 指向都是全局对象。

请务必记住以上重点标记的两句话，在很多地方也都用到。

```js
function f2() {
  "use strict";
  console.log(this);
}
function f3() {
  console.log(this);
}
const f4 = () => {
  console.log(this);
};
const f5 = () => {
  "use strict";
  console.log(this);
};
f2(); // undefined
f3(); // 全局对象
f4(); // 全局对象
f5(); // 全局对象
```

#### 函数在对象内部

```js
const obj = {
  type: 1,
  func1: function () {
    console.log(this);
  },
  func2: () => {
    console.log(this);
  },
};
obj.func1(); // obj
obj.func2(); // 全局对象
// 把 func1，func2 单独拿出来调用，在当前情况下等同于全局状态下的调用
const { func1, func2 } = obj;
func1(); // 全局对象
func2(); // 全局对象
```

在严格模式下再运行一遍

```js
"use strict";
const obj = {
  type: 1,
  func1: function () {
    console.log(this);
  },
  func2: () => {
    console.log(this);
  },
};
obj.func1(); // obj
obj.func2(); // 全局对象
// 把 func1，func2 单独拿出来调用，在当前情况下等同于全局状态下的调用
const { func1, func2 } = obj;
func1(); // undefined
func2(); // 全局对象
```

当作为对象的函数时，this 的绑定只受最接近的成员引用的影响。

```js
function independent() {
  return this.prop;
}
const independent2 = () => {
  return this.prop;
};
var obj = {
  prop: 37,
  func1: function () {
    return this.prop;
  },
  func2: () => {
    return this.prop;
  },
};
obj.func3 = independent;
obj.func4 = independent2;
obj.child = { func5: independent, func6: independent2, prop: 42 };
console.log(obj.func1()); // 37
console.log(obj.func2()); // undefined
console.log(obj.func3()); // 37
console.log(obj.func4()); // undefined
console.log(obj.child.func5()); // 42
console.log(obj.child.func6()); // undefined
```

#### 函数在 class 内

this 在类中的表现与在函数中类似，因为类本质上也是函数，但也有一些区别和注意事项。在类的构造函数中，this 是一个常规对象。`类中所有非静态的方法都会被添加到 this 的原型中`。

和其他普通函数一样，类方法中的 this 值取决于它们如何被调用。需要注意的是类内部`总是严格模式`。类的方法内部如果含有 this，它默认指向类的实例。但是，必须非常小心，一旦单独使用该方法，很可能报错。

```js
class TestClass {
  normalFunction() {
    console.log("normal function:", this);
  }

  arrowFunction = () => {
    console.log("arrow function:", this);
  };
}

const t = new TestClass();
const { normalFunction, arrowFunction } = t;
normalFunction(); // normal function: undefined
arrowFunction(); // arrow function: TestClass {arrowFunction: ƒ}
```

在上面代码中

```js
const { normalFunction, arrowFunction } = t;
```

其实相当于如下代码

```js
function normalFunction2() {
  "use strict";
  console.log("normal function:", this);
}
```

因为普通函数的 this 是由调用者确定的，如果在非严格模式下，直接调用，则 this 指向全局对象，如果是严格模式下，this 则为 undefined。而箭头函数是由创建时就确定了，所以 arrowFunction 实际指向的仍是 TestClass 实例。

有时，也可以通过 bind 方法使类中的 this 值总是指向这个类实例。为了做到这一点，可在构造函数中绑定类方法：

```js
class Car {
  constructor() {
    // 注意 bind 和无 bind 的区别
    this.sayBye = this.sayBye.bind(this);
  }
  sayHi() {
    console.log(`Hello from ${this.name}`);
  }
  sayBye() {
    console.log(`Bye from ${this.name}`);
  }
  get name() {
    return "Ferrari";
  }
}

class Bird {
  get name() {
    return "Tweety";
  }
}

const car = new Car();
const bird = new Bird();

// class 中方法的调用取决于调用者
car.sayHi(); // Hello from Ferrari
bird.sayHi = car.sayHi;
bird.sayHi(); // Hello from Tweety

// 对于已绑定的函数，this 就不在依赖调用者
bird.sayBye = car.sayBye;
bird.sayBye(); // Bye from Ferrari
```

在派生类中的构造函数没有初始的 this 绑定。在构造函数中调用 `super()` 会生成一个 this 绑定。所以在子类的构造函数中，如果要使用 this 的话必须要调用 `super()` ，相当于 `this = new Base();`。派生类不能在调用 super() 之前返回，除非其构造函数返回的是一个对象，或者根本没有构造函数。

```js
class Base {}
class Good extends Base {}
class AlsoGood extends Base {
  constructor() {
    return { a: 5 };
  }
}
class Bad extends Base {
  constructor() {}
}

new Good();
new AlsoGood();
new Bad(); // ReferenceError
```

更多关于 class 的内容可以查看阮一峰老师[关于 class 的说明](https://es6.ruanyifeng.com/#docs/class)

#### 改变 this 指向

通过函数的 call, apply, bind 方法是可以改变 this 的指向的，例如：

```js
var obj = { a: "Custom" };
var a = "Global";
function func1() {
  return this.a;
}

// ECMAScript 5 引入了 Function.prototype.bind()。调用 f.bind(someObject)会创建一个与 f 具有相同函数体和作用域的函数，但是在这个新函数中，this 将永久地被绑定到了 bind 的第一个参数，无论这个函数是如何被调用的。

const func2 = func1.bind(obj);
func1(obj);
func1.call(obj);
func1.apply(obj);
func2(obj);

// 注意：如果将this传递给call、bind、或者apply来调用箭头函数，它将被忽略。不过你仍然可以为调用添加参数，不过第一个参数(thisArg)应该设置为null。
```

### this 和对象转换

在非严格模式下使用 call 和 apply 时，如果用作 this 的值不是对象，则会被尝试转换为对象。null 和 undefined 被转换为全局对象。原始值如 7 或 'foo' 会使用相应构造函数转换为对象。因此 7 会被转换为 new Number(7) 生成的对象，字符串 'foo' 会转换为 new String('foo') 生成的对象。

```js
// 非严格模式下
function bar() {
  // 此处也属于函数内的 this ，下面会继续分析
  console.log(this);
}

bar.call(7); // Number {7}
bar.call("foo"); // String {"foo"}
bar.call(undefined); // 全局对象
```

```js
// 严格模式下
"use strict";
function bar() {
  console.log(this);
}

bar.call(7); // 7
bar.call("foo"); // foo
bar.call(undefined); // undefined
```

ECMAScript 5 引入了 `Function.prototype.bind()` 。调用 f.bind(someObject)会创建一个与 f 具有相同函数体和作用域的函数，但是在这个新函数中，this 将永久地被绑定到了 bind 的第一个参数，无论这个函数是如何被调用的。

```js
function f() {
  return this.a;
}

var g = f.bind({ a: "azerty" });
console.log(g()); // azerty

var h = g.bind({ a: "yoo" }); // bind只生效一次！
console.log(h()); // azerty

var o = { a: 37, f: f, g: g, h: h };
console.log(o.a, o.f(), o.g(), o.h()); // 37, 37, azerty, azerty
```

### 原型链中

对于在对象原型链上某处定义的方法，同样的概念也适用。如果该方法存在于一个对象的原型链上，那么 this 指向的是调用这个方法的对象，就像该方法就在这个对象上一样。

```js
// 对象 p 没有属于它自己的 f 属性，它的 f 属性继承自它的原型。虽然最终是在 o 中找到 f 属性的，这并没有关系；查找过程首先从 p.f 的引用开始，所以函数中的 this 指向 p 。也就是说，因为 f 是作为 p 的方法调用的，所以它的 this 指向了 p 。
var o = {
  f: function () {
    return this.a + this.b;
  },
};
var p = Object.create(o);
p.a = 1;
p.b = 4;

console.log(p.f()); // 5
```

相同的概念也适用于当函数在一个 getter 或者 setter 中被调用。用作 getter 或 setter 的函数都会把 this 绑定到设置或获取属性的对象。

```js
function sum() {
  return this.a + this.b + this.c;
}

var o = {
  a: 1,
  b: 2,
  c: 3,
  get average() {
    return (this.a + this.b + this.c) / 3;
  },
};

Object.defineProperty(o, "sum", {
  get: sum,
  enumerable: true,
  configurable: true,
});

console.log(o.average, o.sum); // 2, 6
```

### 与 DOM 相关

当函数被用作事件处理函数时，它的 this 指向触发事件的元素(一些浏览器在使用非 addEventListener 的函数动态地添加监听函数时不遵守这个约定)。

```js
// 被调用时，将关联的元素变成蓝色
function bluify(e) {
  console.log(this === e.currentTarget); // 总是 true

  // 当 currentTarget 和 target 是同一个对象时为 true
  console.log(this === e.target);
  this.style.backgroundColor = "#A5D9F3";
}

// 获取文档中的所有元素的列表
var elements = document.getElementsByTagName("*");

// 将bluify作为元素的点击监听函数，当元素被点击时，就会变成蓝色
for (var i = 0; i < elements.length; i++) {
  elements[i].addEventListener("click", bluify, false);
}
```

当代码被内联 on-event 处理函数 调用时，它的 this 指向监听器所在的 DOM 元素：

```html
<button onclick="alert(this.tagName.toLowerCase());">Show this</button>

<!-- 在下面这种情况下，没有设置内部函数的 this，所以它指向 global/window 对象(即非严格模式下调用的函数未设置 this 时指向的默认对象)。 -->

<button onclick="alert((function(){return this})());">Show inner this</button>
```

## 最后

分析一道题

```js
class Test {
  prop = {
    func1: function () {
      console.log(this);
    },
    func2: () => {
      console.log(this);
    },
  };
}

const t = new Test();
t.prop.func1(); // object prop
t.prop.func2(); // object t
const { prop } = t;
prop.func1(); // object prop
prop.func2(); // t
const { func1, func2 } = prop;
func1(); // undefined
func2(); // t
```

答案已经公布，想想为什么呢？
