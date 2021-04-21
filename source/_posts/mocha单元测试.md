---
title: mocha单元测试
catalog: true
tags:
  - mocha
  - 单元测试
categories:
  - front-end
translate_title: mocha-unit-test
date: 2019-12-15 14:26:11
subtitle:
header-img:
---

## 什么是单元测试?

单元测试( unit testing )，是指对软件中的最小可测试单元进行检查和验证。在前端领域来说，我们主要是针对 JavaScript 的类( class ) 或者方法( function ) 进行单元测试，以增强代码的可靠性和可维护性。下面介绍的是 mocha 单元测试框架。

## mocha 测试框架

mocha 是一个测试框架，可以通过 npm 全局安装在本地，或者是局部安装在项目中。

```bash
# 全局安装
npm i -g mocha
# 局部安装在 dev 环境下
npm i --save-dev mocha
```

在测试文件中，写入如下代码:

```javascript
function add(n, m) {
    return n + m;
}

describe("add", () => {
    it('should return 2', () => {
        const count = add(1, 1);
        if ( count !== 2) {
            throw new Error("1 + 1 应该等于2")；
        }
    });
});
```

运行 mocha

```bash
mocha
# 或
./node_modules/.bin/mocha
# 或指定文件
./node_modules/.bin/mocha --file ./src/__test__/*.test.js
```

mocha 命令常用参数

```
Options:

    -h, --help                  输出帮助信息
    -V, --version               输出mocha的版本号
    -A, --async-only            强制所有的测试用例必须使用callback或者返回一个promise的格式来确定异步的正确性
    -c, --colors                在报告中显示颜色
    -C, --no-colors             在报告中禁止显示颜色
    -g, --growl                 在桌面上显示测试报告的结果
    -O, --reporter-options <k=v,k2=v2,...>  设置报告的基本选项
    -R, --reporter <name>       指定测试报告的格式
    -S, --sort                  对测试文件进行排序
    -b, --bail                  在第一个测试没有通过的时候就停止执行后面所有的测试
    -d, --debug                 启用node的debugger功能
    -g, --grep <pattern>        用于搜索测试用例的名称，然后只执行匹配的测试用例
    -f, --fgrep <string>        只执行测试用例的名称中含有string的测试用例
    -gc, --expose-gc            展示垃圾回收的log内容
    -i, --invert                只运行不符合条件的测试用例，必须和--grep或--fgrep之一同时运行
    -r, --require <name>        require指定模块
    -s, --slow <ms>             指定slow的时间，单位是ms，默认是75ms
    -t, --timeout <ms>          指定超时时间，单位是ms，默认是200ms
    -u, --ui <name>             指定user-interface (bdd|tdd|exports)中的一种
    -w, --watch                 用来监视指定的测试脚本。只要测试脚本有变化，就会自动运行Mocha
    --check-leaks               检测全局变量造成的内存泄漏问题
    --full-trace                展示完整的错误栈信息
    --compilers <ext>:<module>,...  使用给定的模块来编译文件
    --debug-brk                 启用nodejs的debug模式
    --es_staging                启用全部staged特性
    --harmony<_classes,_generators,...>     all node --harmony* flags are available
    --preserve-symlinks                     告知模块加载器在解析和缓存模块的时候，保留模块本身的软链接信息
    --icu-data-dir                          include ICU data
    --inline-diffs              用内联的方式展示actual/expected之间的不同
    --inspect                   激活chrome浏览器的控制台
    --interfaces                展示所有可用的接口
    --no-deprecation            不展示warning信息
    --no-exit                   require a clean shutdown of the event loop: mocha will not call process.exit
    --no-timeouts               禁用超时功能
    --opts <path>               定义option文件路径
    --perf-basic-prof           启用linux的分析功能
    --prof                      打印出统计分析信息
    --recursive                 包含子目录中的测试用例
    --reporters                 展示所有可以使用的测试报告的名称
    --retries <times>           设置对于失败的测试用例的尝试的次数
    --throw-deprecation         无论任何时候使用过时的函数都抛出一个异常
    --trace                     追踪函数的调用过程
    --trace-deprecation         展示追踪错误栈
    --use_strict                强制使用严格模式
    --watch-extensions <ext>,... --watch监控的扩展
    --delay                     异步测试用例的延迟时间
    --extension                 指定测试文件后缀
    --file                      指定测试文件目录
    ...
```

除了以上命令参数外，可以输入 `mocha -h` 查看更多命令参数。更多关于 mocha 的使用，请看[文档](https://mochajs.org/)。

## chai 断言库

为了更友好的显示测试结果，可以使用 chai 断言库:

```bash
# 安装 chai
npm i --save-dev chai
```

使用方法:

```javascript
// 这里是 es5 的使用方法，使用 ES6 在下面会讲到
var expect = require("chai").expect;

function add(n, m) {
  return n + m;
}

describe("add", () => {
  it("should return 2", () => {
    const count = add(1, 1);
    expect(count).to.eqls(2);
  });
});
```

更多关于 chai 的使用请看[文档](https://www.chaijs.com/)。

## 使用 ES6

如果我们要在测试文件中写 ES6 语法的话，需要通过 `@babel/register` 编译

```bash
# 安装 babel
npm i @babel/register
# 运行时添加 --require
./node_modules/.bin/mocha --require @babel/register --file ./src/__test__/*.js
```

这个时候测试文件就可以写 ES6 的语法了

```javascript
import { expect } from "chai";
import { add } from "./add";

describe("add", () => {
  it("should return 2", () => {
    const count = add(1, 1);
    expect(count).to.eqls(2);
  });
});
```

## 使用 sinon 进行截取和模拟函数

sinon 提供 stub 和 spy 等函数进行截取和模拟真实函数，以更简单的方式进行测试:

```javascript
import { expect } from "chai";
import { stub } from "sinon";
import calc from "./calc";

// describe 可以嵌套，通常一个测试只测试某一个文件，现在测试 calc 整个文件
describe("calc", () => {
  // 最好不要这样直接 stub 要测试的方法，不然还测试什么呢？
  decribe("add", () => {
    it("should return 2", () => {
      calcAddStub = stub(calc, "add").returns(2); // 仅仅为了举例
      expect(calcAddStub()).to.eqls(2);
    });
  });
  // 还可以通过 resolves 模拟异步操作
  decribe("calc time", () => {
    it("should return correct time", async () => {
      const calcTimeStub = stub(calc, "add").resolves(2); // 仅仅为了举例
      const count = await calcTimeStub();
      expect(count).to.eqls(2);
    });
  });
});
```

更多关于 sinon 的使用请看[文档](https://sinonjs.org/)。

## 使用 enzyme 浅拷贝 React 组件

如果要测试 React 组件，可以使用 enzyme 进行模拟

```javascript
import { expect } from "chai";
import { stub } from "sinon";
import { shallow } from "enzyme";
import App from "./App";

describe("App", () => {
  const defaultProps = {
    count: 1,
  };
  const render = (props) => shallow(<App {...props} {...defaultProps} />);

  decribe("add", () => {
    it("should return 2", () => {
      const component = render();
      const count = component.instance().add(1, 1);
      expect(count).to.eqls(2);
    });
  });
});
```

更多关于 enzyme 的使用请看[文档](https://airbnb.io/enzyme/)。

## 使用 Istanbul 查看测试覆盖率

一般项目都需要达到某一覆盖率以上，以确保代码的健壮性，可以使用 Istanbul (伊斯坦布尔) 包。

```bash
# 安装，Istanbul 包改名了，叫 nyc
npm i --save-dev nyc

# 运行
./node_modules/.bin/nyc ./node_modules/.bin/mocha --require @babel/register --file ./src/__test__/*.test.js

```

运行会重新跑一次测试，并且在当前目录生成 .coverage 目录，可以直接在浏览器打开并且查看覆盖率。

更多关于 enzyme 的使用请看[文档](https://istanbul.js.org/)。

## 结语

本篇文章只是简单介绍 js 的单元测试流程，使用的技术包括但不限于 mocha (测试框架), chai (断言库), sinon (截取和模拟函数), enzyme (测试 React 等库), Istanbul (查看覆盖率)。在实际应用中，还需要更多的实际操作，例如测试流程和规范，有的项目中需要测试 渲染的 dom 和 dom 中的属性是否正确，有的仅测试方法，当然还有其他的测试框架例如 jest 等，由于 ~~太懒~~ 篇幅有限，点到为止。

(done)
