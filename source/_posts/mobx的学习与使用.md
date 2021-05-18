---
title: mobx的学习与使用
catalog: true
tags:
  - mobx
  - mobx-react
categories:
  - frontend
translate_title: study-and-use-of-mobx
date: 2021-03-24 13:20:39
subtitle:
header_img:
---

## mobx 简介

> 简单、可扩展的状态管理，相比于 redux，更轻巧，更简单，更灵活，在某些时候性能甚至更优越。

在这里简单的记录和介绍一下 mobx 的使用。

## 简单例子

```js
import { observable } from "mobx";
import { observer } from "mobx-react";

var numStore = observable({
  num: 1,
  addNum: function () {
    this.num++;
  },
});

@observer
class TimerView extends React.Component {
  handleAdd = () => {
    this.props.numStore.addNum();
  };

  render() {
    return (
      <div>
        <span> num: {this.props.numStore.num} </span>
        <button onClick={this.handleAdd}></button>
      </div>
    );
  }
}

ReactDOM.render(<TimerView numStore={numStore} />, document.body);
```

## 主要的 api

### observable

使用：

- observable(value)
- @observable classProperty = value

Observable 值可以是 JS 基本数据类型、引用类型、普通对象、类实例、数组和映射。 主要作用是指定该值的是被观察的、可修改的。其装饰器写法为 `@observable`。例如

```js
import { observable, computed } from "mobx";

// 方法1，直接使用
var NumStore = observable({
  num: 1,
  addNum: function () {
    this.num++;
  },
});

// 方法二，装饰器写法
class NumStore {
  @observable price = 0;
  @observable num = 1;

  @computed get total() {
    return this.price * this.num;
  }
}
```

### computed

如果任何影响计算值的值发生变化了，计算值将根据状态自动进行衍生。 计算值在大多数情况下可以被 MobX 优化的，因为它们被认为是纯函数。 例如，如果前一个计算中使用的数据没有更改，计算属性将不会重新运行。 如果某个其它计算属性或 reaction 未使用该计算属性，也不会重新运行。 在这种情况下，它将被暂停。

```js
import { observable, computed } from "mobx";

class NumStore {
  @observable price = 0;
  @observable num = 1;

  @computed get total() {
    return this.price * this.num;
  }
}
```

### autorun

autorun 可以用来监听值的变化，不要把 `computed` 和 `autorun` 搞混。它们都是响应式调用的表达式，但是，如果你想响应式的产生一个可以被其它 observer 使用的值，请使用 @computed，如果你不想产生一个新值，而想要达到一个效果，请使用 autorun。 举例来说，效果是像打印日志、发起网络请求等这样命令式的副作用。

```js
import axios from "axios";
import { observable, configure, action, runInAction, autorun } from "mobx";

configure({ enforceActions: "observed" });

export class Session {
  @observable num = 1;

  constructor() {
    autorun(() => {
      // 每次调用 addNum / subNum都会执行此函数
      console.log("auto log num:" + this.num);
    });
  }

  @action addNum = function () {
    console.log(this.num);
    this.num++;
  };

  @action subNum = () => {
    this.num--;
  };
}

export default new Session();
```

### action

用法:

- action(fn)
- action(name, fn)
- @action classMethod() {}
- @action(name) classMethod () {}
- @action boundClassMethod = (args) => { body }
- @action(name) boundClassMethod = (args) => { body }
- @action.bound classMethod() {}

action 主要是用来修改状态，也可以使用异步的方法

```js
import axios from "axios";
import { observable, configure, action, runInAction } from "mobx";

// 强制使用 action 来修改状态，否则会打印 waring
configure({ enforceActions: "observed" });

export class Session {
  @observable num = 1;
  @observable loading = false;

  @action addNum = function () {
    console.log(this.num);
    this.num++;
  };

  @action subNum = () => {
    this.num--;
  };

  @action directGetHundred = () => {
    this.loading = true;
    setTimeout(
      // 所有的修改状态都需要放在 action 中
      action("directAddHundred", () => {
        this.num += 100;
        this.loading = false;
      }),
      1000
    );
  };

  @action directGetTwoHundred = async () => {
    this.loading = true;
    await axios("/");
    // 调用其他异步操作
    // await axios("/");
    // runInAction 是 action 的语法糖，鼓励你不要到处写 action，而是在整个过程结束时尽可能多地对所有状态进行修改
    runInAction(() => {
      this.loading = false;
      this.num += 200;
    });
  };
}

export default new Session();
```

## flows

flows 的工作原理与 async / await 是一样的。只是使用 function \* 来代替 async，使用 yield 代替 await 。 使用 flow 的优点是它在语法上基本与 async / await 是相同的 (只是关键字不同)，并且不需要手动用 @action 来包装异步代码，这样代码更简洁。

flow 只能作为函数使用，不能作为装饰器使用。 flow 可以很好的与 MobX 开发者工具集成，所以很容易追踪 async 函数的过程。

```js
mobx.configure({ enforceActions: true });

class Store {
  @observable githubProjects = [];
  @observable state = "pending";

  fetchProjects = flow(function* () {
    // <- 注意*号，这是生成器函数！
    this.githubProjects = [];
    this.state = "pending";
    try {
      const projects = yield fetchGithubProjectsSomehow(); // 用 yield 代替 await
      const filteredProjects = somePreprocessing(projects);
      // 异步代码块会被自动包装成动作并修改状态
      this.state = "done";
      this.githubProjects = filteredProjects;
    } catch (error) {
      this.state = "error";
    }
  });
}
```

## 总结

之前一直使用 redux，看到了有赞前端技术团队的 [我为什么从 Redux 迁移到了 Mobx
](https://tech.youzan.com/mobx_vs_redux/) 文章，决定了解一下 mobx ，现在这里只记录 mobx 的简单使用，详细的还是需要查看[官方文档](https://cn.mobx.js.org/)。
