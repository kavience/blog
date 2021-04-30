---
title: 前端面试题之js进阶(持续更新)
catalog: true
tags:
  - 前端面试题
categories:
  - front-end
translate_title: js-advanced-frontend-interview-questions-continuous-update
date: 2020-11-12 19:05:46
subtitle:
header_img:
---

## 数据类型

Number, String, Bool, Null, Undefined, Symbol, 引用数据类型( Object, Function, Array )。

Null 与 Undefined 的区别:

Null

- 作为函数的参数, 表示该函数的参数不是对象。

- 作为对象原型链的终点。

Undefined

- 变量被声明了, 但没有赋值时, 就等于 undefined。

- 调用函数时, 应该提供的参数没有提供, 该参数等于 undefined。

- 对象没有赋值的属性, 该属性的值为 undefined。

- 函数没有返回值时, 默认返回 undefined。

## var, const, let 的区别

- var 命令存在变量提升现象, 可在声明之前使用, let 与 const 则不存在
- let 与 const 存在暂时性死区的现象, 这个区块对这些命令声明的变量, 从一开始就形成了封闭作用域。凡是在声明之前就使用这些变量, 就会报错。
- let 与 const 不可以重复声明。
- const 声明的是只读的常量, 一旦声明, 就必须立即初始化, 声明之后值不能改变。
- let 与 const 是块级作用域。

| 声明方式 | 变量提升 | 暂时性死区 | 重复声明 | 初始值 | 作用域 |
| -------- | -------- | ---------- | -------- | ------ | ------ |
| var      | 允许     | 不存在     | 允许     | 不需要 | 除块级 |
| let      | 不允许   | 存在       | 不允许   | 不需要 | 块级   |
| const    | 不允许   | 存在       | 不允许   | 需要   | 块级   |

## new 的过程

```js
function Person(name) {
    this.name = name;
}
Person.prototype = {
    constructor: Person,
    sayName: function() {
         alert(this.name);
};
var jack = new Person("Jack");
```

首先, 必须保证 new 运算符后跟着的是一个有`[[Construct]]`内部方法的对象, 否则会抛出异常。

接下来就是创建对象的过程:

1. 先创建一个原生对象, 假定为 obj = {} 或 obj = new Object。

2. 获得构造函数 Person 的 prototype 对象, 并将其赋给 obj 的`[[Prototype]]`属性, 表现为`__proto__`。

3. call 构造函数的内部方法, 把其中的 this 赋值为新创建的对象 obj, 并传入所需参数。

4. 执行构造函数, 并返回创建的对象。

这里有一点需要说明: 正常来讲构造函数中是不用写 return 语句的, 因为它会默认返回新创建的对象。但是, 如果在构造函数中写了 return 语句, 如果 return 的是一个对象, 那么函数就会覆盖掉新创建的对象, 而返回此对象；如果 return 的是基本类型如字符串、数字、布尔值等, 那么函数会忽略掉 return 语句, 还是返回新创建的对象。

### 实现一个 new

```js
function myNew(Fn) {
  const obj = {};
  if (typeof Fn === "function") {
    obj.__proto__ = Fn.prototype;
    const args = Array.from(arguments).slice(1);
    Fn.call(obj, ...args);
  }
  return obj;
}

function Person(name) {
  this.name = name;
}

const person = myNew(Person, "张三");
console.log(person.name);
```

## this 的指向

在 js 中 this 一般会出现在如下情况:

1. 全局状态下
2. 一般函数内
3. this 和对象转换
4. 原型链中
5. 与 DOM 相关

详见另一篇文章 - [js-彻底了解 this 的指向](../js-彻底了解this的指向)

## apply, call, bind 的区别与实现

bind 与 call 或 apply 最大的区别就是 bind 不会被立即调用, 而是返回一个函数, 函数内部的 this 指向与 bind 执行时的第一个参数, 而传入 bind 的第二个及以后的参数作为原函数的参数来调用原函数。

call, apply 都是为了改变某个函数运行时的上下文而存在的, 简单点说就是为了改变某个运行时函数内部 this 指向, 区别在于 apply 第二参数需要是一个参数数组, call 的第二参数及其之后的参数需要是数组里面的元素。

### apply 的实现

```js
Function.prototype.apply = function (context, arr) {
  // 基础类型转包装对象
  if (context === undefined || context === null) {
    context = window;
  } else if (typeof context === "string") {
    context = new String(context);
  } else if (typeof context === "number") {
    context = new Number(context);
  } else if (typeof context === "boolean") {
    context = new Boolean(context);
  }
  // 非对象, 非undefined, 非null的值才会抛错
  if (
    typeof arr !== "object" &&
    typeof arr !== "undefined" &&
    typeof arr !== "null"
  )
    throw new TypeError("CreateListFromArrayLike called on non-object");
  arr = (Array.isArray(arr) && arr) || []; // 非数组就赋值空数组
  // 保存原函数至指定对象的fn属性上
  context.fn = this;
  // 通过指定对象的fn属性执行原函数并出入参数
  const fnValue = context.fn(...arr);
  delete context.fn; // 从context中删除fn原函数
  return fnValue;
};
```

### call 的实现

```js
Function.prototype.call = function (context) {
  // 基础类型转包装对象
  if (context === undefined || context === null) {
    context = window;
  } else if (typeof context === "string") {
    context = new String(context);
  } else if (typeof context === "number") {
    context = new Number(context);
  } else if (typeof context === "boolean") {
    context = new Boolean(context);
  }
  // 保存原函数至指定对象的fn属性上
  context.fn = this;
  // 获取除第一个参数之后的所有参数
  const args = Array.from(arguments).slice(1);
  // 通过指定对象的fn属性执行原函数并出入参数
  const fnValue = context.fn(...args);
  delete context.fn; // 从context中删除fn原函数
  return fnValue;
};
```

### bind 的实现

```js
Function.prototype.bind = function (context) {
  // 保存原函数
  const ofn = this;
  // 获取除第一个参数之后的所有参数
  const args = Array.from(arguments).slice(1);
  function O() {}
  function fn() {
    // 第一个参数的判断是为了忽略使用new实例化函数时让this指向它自己, 否则就指向这个context指定对象
    // 第二个参数的处理做了参数合并,  就是 bind & fn 两个函数的参数合并
    ofn.apply(
      this instanceof O ? this : context,
      args.concat(Array.from(arguments))
    );
  }
  O.prototype = this.prototype;
  fn.prototype = new O();
  return fn;
};
```

## 闭包

## 时间循环

## 类型判断

## 手写 promise

## 垃圾回收机制

## 原型链

> 概要: 每个构造函数( construct ) 都有一个原型对象, 原型对象( prototype )都包含一个指向构造函数的内部指针, 而实例( instance ) 都包含指向原型对象的内部指针。实例与原型的链条称作`原型链`。

网上看到一张图, 感觉很全面的描述了原型链之间的关系:

![prototype](/img/blog_img/prototype.png)

注意: `prototype` 是函数(ES6 中箭头函数除外)特有的属性, 实例对象不存在该属性, `__proto__` 则在两者内都存在, 因为函数也是对象。

## 继承的实现

七种 JS 继承方式分别是:

- 原型链继承
- 构造函数式继承
- 组合式继承
- 原型式继承
- 寄生式继承
- 寄生组合式继承
- ES6 关键字 extends 继承

### 原型链继承

基本思想: 通过直接改变子类的 prototype 实现。

优点: 实例可继承的属性有: 实例的构造函数的属性, 父类构造函数的属性, 父类原型上的属性（新实例不会继承父类实例的属性）。

缺点: 新实例无法向父类构造函数传参, 继承单一, 所有新实例都会共享父类实例的属性。

```js
function Person(name) {
  this.name = name;
}
Person.prototype.job = "frontend";
function Child() {
  this.name = "child";
}
Child.prototype = new Person();
var child = new Child();
console.log(child.job); // frontend
console.log(child instanceof Person); // true
```

### 构造函数式继承

基本思想: 在子类型构造函数的内部调用超类型构造函数.

优点: 保证了原型链中引用类型值的独立, 不再被所有实例共享, 子类型创建时也能够向父类型传递参数。

缺点: 方法都在构造函数中定义, 函数难以复用, 而且父类中定义的方法, 对子类而言也是不可见的。

```js
function Father() {
  this.colors = ["red", "blue", "green"];
}
function Son() {
  Father.call(this); //继承了Father,且向父类型传递参数
}
var instance1 = new Son();
instance1.colors.push("black");
console.log(instance1.colors); //"red,blue,green,black"

var instance2 = new Son();
console.log(instance2.colors); //"red,blue,green" 可见引用类型值是独立的
```

### 组合式继承

基本思路: 使用原型链实现对原型属性和方法的继承, 通过借用构造函数来实现对实例属性的继承。

优点: 通过在原型上定义方法实现了函数复用, 又能保证每个实例都有它自己的属性。

缺点: 调用了两次父类构造函数, 造成了不必要的消耗。

```js
function Father(name) {
  this.name = name;
  this.colors = ["red", "blue", "green"];
}
Father.prototype.sayName = function () {
  alert(this.name);
};
function Son(name, age) {
  Father.call(this, name); //继承实例属性, 第一次调用Father()
  this.age = age;
}
Son.prototype = new Father(); //继承父类方法,第二次调用Father()
Son.prototype.sayAge = function () {
  alert(this.age);
};
var instance1 = new Son("louis", 5);
instance1.colors.push("black");
console.log(instance1.colors); //"red,blue,green,black"
instance1.sayName(); //louis
instance1.sayAge(); //5

var instance1 = new Son("zhai", 10);
console.log(instance1.colors); //"red,blue,green"
instance1.sayName(); //zhai
instance1.sayAge(); //10
```

### 原型式继承

基本思想: 也是通过 prototype 完成继承, 只不过在多了一层函数调用。

优点: 用一个函数包装一个对象, 然后返回这个函数的调用, 这个函数就变成了可以随意增添属性的实例或对象。`Object.create()` 就是这个原理。

缺点: 所有的实例都会继承原型上的属性, 无法实现复用。

```js
// 先封装一个函数容器, 用来承载继承的原型和输出对象
function object(obj) {
  function F() {}
  F.prototype = obj;
  return new F();
}
function Person(name) {
  this.name = name;
}
var super0 = new Person();
var super1 = object(super0);
console.log(super1 instanceof Person); // true
```

### 寄生式继承

基本思想: 寄生式继承的思路与(寄生)构造函数和工厂模式类似, 即创建一个仅用于封装继承过程的函数, 该函数在内部以某种方式来增强对象, 最后再像真的是它做了所有工作一样返回对象。

优点: 借助原型可以基于已有的对象创建新对象, 同时还不必因此创建自定义类型。

缺点: 使用寄生式继承来为对象添加函数, 会由于不能做到函数复用而降低效率, 这一点与构造函数模式类似。

```js
function object(obj) {
  // 通过 prototype 继承
  function F() {}
  F.prototype = obj;
  return new F();
}
function Person(name) {
  this.name = name;
}
var sup = new Person();
function subobject(obj) {
  var sub = object(obj);
  sub.name = "ming";
  return sub;
}
var sup2 = subobject(sup);
// 这个函数经过声明后就成了可增添属性的对象
console.log(sup2.name); // 'ming'
console.log(sup2 instanceof Person); // true
```

### 寄生组合式继承

基本思想: 不必为了指定子类型的原型而调用超类型的构造函数。

优点: 集寄生式继承和组合继承的优点于一身, 是实现基于类型继承的最有效方法。

```js
function Person(name) {
  this.name = name;
}
// 寄生
function object(obj) {
  function F() {}
  F.prototype = obj;
  return new F();
}
// object是F实例的另一种表示方法
var obj = object(Person.prototype);
// obj实例（F实例）的原型继承了父类函数的原型
// 上述更像是原型链继承, 只不过只继承了原型属性

// 组合
function Sub() {
  this.age = 100;
  Person.call(this); // 这个继承了父类构造函数的属性
} // 解决了组合式两次调用构造函数属性的特点

Sub.prototype = obj;
console.log(Sub.prototype.constructor); // Person
obj.constructor = Sub; // 重点, 一定要修复实例
console.log(Sub.prototype.constructor); // Sub
var sub1 = new Sub();
// Sub实例就继承了构造函数属性, 父类实例, object的函数属性
console.log(sub1.job); // frontend
console.log(sub1 instanceof Person); // true
```

### ES6 关键字 extends 继承

ES6 关键字 extends 继承本质也是组合式继承。
