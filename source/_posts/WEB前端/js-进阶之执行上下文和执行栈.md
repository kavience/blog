---
title: js 进阶之执行上下文和执行栈
catalog: true
date: 2019-10-19 10:50:06
subtitle:
header-img:
tags:
  - JavaScript
catagories:
  - 前端开发
---

## 什么是 JavaScript 执行上下文？

> 执行上下文是评估和执行 JavaScript 代码的环境的抽象概念，Javascript 代码都是在执行上下文中运行。

## 什么是 JavaScript 执行栈？

> 执行栈，也叫调用栈，具有 LIFO（后进先出）结构，用于存储在代码执行期间创建的所有执行上下文。
> 首次运行 JS 代码时，会创建一个全局执行上下文并 Push 到当前的执行栈中。每当发生函数调用，引擎都会为该函数创建一个新的函数执行上下文并 Push 到当前执行栈的栈顶。
> 根据执行栈 LIFO 规则，当栈顶函数运行完成后，其对应的函数执行上下文将会从执行栈中 Pop 出，上下文控制权将移到当前执行栈的下一个执行上下文。

## 执行上下文的类型

执行上下文总共有三种类型

- 全局执行上下文：只有一个，浏览器中的全局对象就是 window 对象，nodejs 中的全局对象就是 module 对象, this 指向这个全局对象。
- 函数执行上下文：存在无数个，只有在函数被调用的时候才会被创建，每次调用函数都会创建一个新的执行上下文。
- Eval 函数执行上下文： 指的是运行在 eval 函数中的代码，很少用而且不建议使用。

## 执行上下文的创建

执行上下文分两个阶段创建：

1. 创建阶段
2. 执行阶段

### 创建阶段

1、确定 this 的值，也被称为 This Binding。
2、LexicalEnvironment（词法环境） 组件被创建。
3、VariableEnvironment（变量环境） 组件被创建。

#### This Binding

- 全局执行上下文中， this 的值指向全局对象，在浏览器中 this 的值指向 window 对象，而在 nodejs 中指向这个文件的 module 对象。
- 函数执行上下文中， this 的值取决于函数的调用方式。具体有：默认绑定、隐式绑定、显式绑定（硬绑定）、new 绑定、箭头函数等，详情请看[函数执行上下文](#函数执行上下文)

#### 词法环境（Lexical Environment）

词法环境有两个组成部分

1. 环境记录：存储变量和函数声明的实际位置

2. 对外部环境的引用：可以访问其外部词法环境

词法环境有两种类型

1. 全局环境：是一个没有外部环境的词法环境，其外部环境引用为 null 。拥有一个全局对象（ window 对象）及其关联的方法和属性（例如数组方法）以及任何用户自定义的全局变量， this 的值指向这个全局对象。

2. 函数环境：用户在函数中定义的变量被存储在环境记录中，包含了 arguments 对象。对外部环境的引用可以是全局环境，也可以是包含内部函数的外部函数环境。

#### 变量环境

变量环境也是一个词法环境，因此它具有上面定义的词法环境的所有属性。

在 ES6 中，词法环境和变量环境的区别在于前者用于存储 **函数声明和变量（ let 和 const ）绑定，而后者仅用于存储变量（ var ）** 绑定。

> **变量提升**的原因：在创建阶段，函数声明存储在环境中，而变量会被设置为 undefined（在 var 的情况下）或保持未初始化（在 let 和 const 的情况下）。所以这就是为什么可以在声明之前访问 var 定义的变量（尽管是 undefined ），但如果在声明之前访问 let 和 const 定义的变量就会提示引用错误的原因。这就是所谓的变量提升。

```javascript
foo(); // foo2
var foo = function () {
  console.log("foo1");
};

foo(); // foo1，foo重新赋值

function foo() {
  console.log("foo2");
}

foo(); // foo1
```

**注意：** 函数声明优先级高于变量声明，同一作用域下存在多个同名函数声明，后面的会替换前面的函数声明。

### 执行阶段

此阶段，完成对所有变量的分配，最后执行代码。

如果 Javascript 引擎在源代码中声明的实际位置找不到 let 变量的值，那么将为其分配 undefined 值。

## 执行上下文栈

因为 JS 引擎创建了很多的执行上下文，所以 JS 引擎创建了执行上下文栈（Execution context stack，ECS）来管理执行上下文。

当 JavaScript 初始化的时候会向执行上下文栈压入一个全局执行上下文，我们用 globalContext 表示它，并且只有当整个应用程序结束的时候，执行栈才会被清空，所以程序结束之前， 执行栈最底部永远有个 globalContext 。

观察以下两段代码：

```javascript
var scope = "global scope";
function checkscope() {
  var scope = "local scope";
  function f() {
    return scope;
  }
  return f();
}
checkscope();
```

```javascript
var scope = "global scope";
function checkscope() {
  var scope = "local scope";
  function f() {
    return scope;
  }
  return f;
}
checkscope()();
```

它们的运行结果是一样的，但执行上下文栈的变化不一样。
第一段代码：

```javascript
ECStack.push(<checkscope> functionContext);
ECStack.push(<f> functionContext);
ECStack.pop();
ECStack.pop();
```

第二段代码：

```javascript
ECStack.push(<checkscope> functionContext);
ECStack.pop();
ECStack.push(<f> functionContext);
ECStack.pop();
```

## 函数执行上下文

上面提到过[执行上下文的类型](#执行上下文的类型)有全局执行上下文和函数执行上下文。

在函数上下文中，用活动对象( activation object, AO )来表示变量对象。

活动对象和变量对象的区别在于

1、变量对象（ VO ）是规范上或者是 JS 引擎上实现的，并不能在 JS 环境中直接访问。
2、当进入到一个执行上下文后，这个变量对象才会被激活，所以叫活动对象（ AO ），这时候活动对象上的各种属性才能被访问。
调用函数时，会为其创建一个 Arguments 对象，并自动初始化局部变量 arguments ，指代该 Arguments 对象。所有作为参数传入的值都会成为 Arguments 对象的数组元素。

### 执行过程

执行上下文的代码会分成两个阶段进行处理

1. 进入执行上下文
2. 代码执行

#### 进入执行上下文

很明显，这个时候还没有执行代码，此时的变量对象会包括（如下顺序初始化）：

1. **函数的所有形参 ( only 函数上下文)**：没有实参，属性值设为 undefined 。
2. **函数声明**：如果变量对象已经存在相同名称的属性，则完全替换这个属性。
3. **变量声明**：如果变量名称跟已经声明的形参或函数相同，则变量声明不会干扰已经存在的这类属性。

#### 代码执行

这个阶段会顺序执行代码，修改变量对象的值，执行完成后 AO 如下

### 总结如下：

1. 全局上下文的变量对象初始化是全局对象
2. 函数上下文的变量对象初始化只包括 Arguments 对象
3. 在进入执行上下文时会给变量对象添加形参、函数声明、变量声明等初始的属性值
4. 在代码执行阶段，会再次修改变量对象的属性值

(done)
