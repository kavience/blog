---
title: typescript常见知识总结
catalog: true
tags:
  - typescript
categories:
  - front-end
translate_title: typescript-common-knowledge-summary
date: 2020-12-25 14:11:17
subtitle:
header-img:
---

## never, unknown, any 三者之间的区别

三者都是 TypeScript 的类型, never 是最具体的类型，因为没有哪个集合比空集合更小了；而 unknown 是最弱的类型，因为它包含了全部可能的值。 any 则不为集合，它破坏了类型检查，因此请尽量不要使用 any。在 TypeScript 中， nerver 可以赋值为 unknown 和 any ，但是 unknown 和 any 不可以赋值给 never，never 只能赋值 never。

那 nerver 的作用是什么呢？举个尤雨溪提到的[例子](https://www.zhihu.com/question/354601204/answer/888551021)：

```ts
interface Foo {
  type: "foo";
}

interface Bar {
  type: "bar";
}

type All = Foo | Bar;

function handleValue(val: All) {
  switch (val.type) {
    case "foo":
      // 这里 val 被收窄为 Foo
      break;
    case "bar":
      // val 在这里是 Bar
      break;
    default:
      // val 在这里是 never
      const exhaustiveCheck: never = val;
      break;
  }
}
```

注意在 default 里面我们把被收窄为 never 的 val 赋值给一个显式声明为 never 的变量。如果一切逻辑正确，那么这里应该能够编译通过。但是假如后来有一天你的同事改了 All 的类型：

```ts
type All = Foo | Bar | Baz;
```

然而他忘记了在 handleValue 里面加上针对 Baz 的处理逻辑，这个时候在 default branch 里面 val 会被收窄为 Baz，导致无法赋值给 never，产生一个编译错误。所以通过这个办法，你可以确保 handleValue 总是穷尽 (exhaust) 了所有 All 的可能类型。

## interface 与 type 的区别

### 相同点：

#### 都可以描述一个对象或者函数

```ts
// 使用 interface
interface User {
  name: string;
  age: number;
}

interface SetUser {
  (name: string, age: number): void;
}
```

```ts
// 使用 type
type User = {
  name: string;
  age: number;
};

type SetUser = (name: string, age: number) => void;
```

#### 都允许扩展

```ts
interface Name {
  name: string;
}
interface User extends Name {
  age: number;
}
```

```ts
type Name = {
  name: string;
};
type User = Name & { age: number };
```

### 不同点

#### type 可以而 interface 不行

type 可以声明基本类型别名，联合类型，元组等类型

```ts
// 基本类型别名
type Name = string;

// 联合类型
interface Dog {
  wong();
}
interface Cat {
  miao();
}

type Pet = Dog | Cat;

// 具体定义数组每个位置的类型
type PetList = [Dog, Pet];
```

type 语句中还可以使用 typeof 获取实例的 类型进行赋值

```ts
// 当你想获取一个变量的类型时，使用 typeof
let div = document.createElement("div");
type B = typeof div;
```

其它用法

```ts
type StringOrNumber = string | number;
type Text = string | { text: string };
type NameLookup = Dictionary<string, Person>;
type Callback<T> = (data: T) => void;
type Pair<T> = [T, T];
type Coordinates = Pair<number>;
type Tree<T> = T | { left: Tree<T>; right: Tree<T> };
```

#### interface 可以而 type 不行

interface 能够声明合并

```ts
interface User {
  name: string;
  age: number;
}

interface User {
  sex: string;
}

/*
User 接口为 {
  name: string
  age: number
  sex: string 
}
*/
```
