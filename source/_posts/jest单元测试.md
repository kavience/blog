---
title: Jest单元测试
catalog: true
tags:
  - JavaScript
  - jest
categories:
  - frontend
translate_title: jest-unit-testing
date: 2020-08-25 11:19:51
subtitle:
header_img:
---

## What

采用 Jest 对 react 项目进行单元测试。

## Why

曾使用 Mocha 对项目进行过单元测试，但是 Mocha 需要配合一系列工具包( sinon, enzyme, chai, nyc )等，加上 Mocha 对 typescript 支持不是特别友好。所以打算采用 Jest 进行单元测试，目前的测试工具 Mocha、Jest、Ava 区别大致如下：

| 框架  | 断言                       | 异步 | Mock            | 代码覆盖率         |
| ----- | -------------------------- | ---- | --------------- | ------------------ |
| Mocha | 不支持（Chai/power-asset） | 友好 | 不支持（Sinon） | 不支持（Istanbul） |
| Jest  | 默认支持                   | 友好 | 默认支持        | 支持               |
| Ava   | 默认支持                   | 友好 | 不支持（Sinon)  | 不支持（Istanbul)  |

## How

### 配置包与命令

安装所需依赖(采用的 typescript )

```bash
yarn add -D jest babel-jest jest-transform-stub ts-jest enzyme-to-json enzyme enzyme-adapter-react-16
```

配置命令

```js
...
"scripts": {
    "test": "cross-env jest",
    "test:with-coverage": "cross-env TEST_COVERAGE=true jest"
  },
...
```

### 配置 Jest

根目录下编辑 jest.config.js

```js
module.exports = {
  preset: "ts-jest", // 采用 ts 测试
  setupFiles: ["./jest.setup.js"],
  transform: {
    "^.+\\.[tj]s?$": "babel-jest",
    "^.+\\.[tj]sx?$": "babel-jest",
    "^.+\\.(css|styl|less|sass|scss|png|jpg|ttf|woff|woff2|svg)$":
      "jest-transform-stub",
  },
  moduleNameMapper: {
    "^@/(.*)$": "<rootDir>/src/$1", // 用 @ 映射当前 src 下的路径
    "^.+.(css|styl|less|sass|scss|png|jpg|ttf|woff|woff2|svg)$":
      "jest-transform-stub", // stub 掉 css|styl|less|sass|scss|png|jpg|ttf|woff|woff2|svg 的测试
    "\\.worker.entry.js": "<rootDir>/__mocks__/workerMock.js",
  },
  globals: {
    "ts-jest": {
      tsConfig: "./tsconfig.test.json", // 指定 ts 测试配置文件
    },
  },
  collectCoverage: process.env.TEST_COVERAGE ? true : false, // 是否需要查看测试覆盖率
  collectCoverageFrom: ["<rootDir>/src/**/*.{ts,tsx}", "!**/node_modules/**"],
  testPathIgnorePatterns: ["<rootDir>/dist/", "<rootDir>/node_modules/"],
  snapshotSerializers: ["enzyme-to-json/serializer"],
  transformIgnorePatterns: ["<rootDir>/dist/", "<rootDir>/node_modules/"],
  testURL: "http://localhost",
  clearMocks: true,
};
```

根目录下编辑 jest.setup.js

```js
// 该文件是运行单元测试前会执行一遍，可以 mock 掉一些报错的东西
const React = require("react");
if (typeof window !== "undefined") {
  global.window.resizeTo = (width, height) => {
    global.window.innerWidth = width || global.window.innerWidth;
    global.window.innerHeight = height || global.window.innerHeight;
    global.window.dispatchEvent(new Event("resize"));
  };
  global.window.scrollTo = () => {};
  if (!window.matchMedia) {
    Object.defineProperty(global.window, "matchMedia", {
      value: jest.fn((query) => ({
        matches: query.includes("max-width"),
        addListener: jest.fn(),
        removeListener: jest.fn(),
      })),
    });
  }

  const mockResponse = jest.fn();
  Object.defineProperty(window, "location", {
    value: {
      hash: {
        endsWith: mockResponse,
        includes: mockResponse,
      },
      assign: mockResponse,
    },
    writable: true,
  });
}

const Enzyme = require("enzyme");

const Adapter = require("enzyme-adapter-react-16");

Enzyme.configure({ adapter: new Adapter() });

Object.assign(Enzyme.ReactWrapper.prototype, {
  findObserver() {
    return this.find("ResizeObserver");
  },
  triggerResize() {
    const ob = this.findObserver();
    ob.instance().onResize([{ target: ob.getDOMNode() }]);
  },
});

console.log("Current React Version:", React.version);
```

至此 Jest 项目搭建就已经完成了, 比 Mocha 简单些。

### Jest 使用

编写测试文件

```ts
import React from "react";
import { App as TargetComponent } from "../App";
import { shallow } from "enzyme";

describe("src > APP", () => {
  const defaultProps = {
    updateTabs: jest.fn(), // 模拟 updateTabs 函数
    user: {},
  };

  // shallow 浅拷贝模拟 react 组件
  const render = (props: {} = {}) =>
    shallow(<TargetComponent {...defaultProps} {...props} />);

  // describe 一个方法
  describe("componentDidMount", () => {
    // 判断行为
    it("should direct return if no tab", () => {
      // 实例化组件
      const component = render({
        user: {
          permissionsMapping: {
            "/": null,
          },
        },
      });
      // 执行方法
      const result = component.instance().componentDidMount();
      // 执行断言
      expect(component.instance().props.updateTabs).toBeCalledWith("test");
      expect(result).toBeUndefined();
    });
  });
});
```

执行单元测试

```bash
yarn test
```

或者执行单个测试文件

```bash
# 采用 describe.only 方法不行，略坑
node_modules/.bin/jest src/components/BaseList/__test__/index.test.tsx
```

查看覆盖率

```bash
yarn test:with-coverage
```

在跟目录下 coverage 下会生成 html 文件，在浏览器打开查看覆盖率即可，可以在 Jest 配置中配置测试率要求，具体可以查看官网文档。

## 总结

个人感觉 Jest 比 Mocha 配置简单些，易上手，Mocha 需要配合 sinon 进行 stub，配合 Chai 断言效果才会更好，在使用上 Jest 和 Mocha 并无太大区别。

(完)
