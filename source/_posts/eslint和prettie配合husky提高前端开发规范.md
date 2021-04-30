---
title: eslint和prettie配合husky提高前端开发规范
catalog: true
hidden: false
tags:
  - eslint
categories:
  - front-end
translate_title: >-
  eslint-and-prettie-cooperate-with-husky-to-improve-frontend-development-specifications
date: 2021-04-26 18:54:50
subtitle:
header_img:
---

## what

使用 eslint 和 prettie 再配合 husky 提高前端开发规范。

## why

平时的开发中，开发规范必不可少，手动修改规范既不可靠，也非常繁琐，所以可以利用 eslint 和 prettie 自动修复以及规范化代码。

再配合 husky ，当开发者 commit 的时候，会自动校验，且尝试自动修复代码，一旦修复失败，则会放弃代码提交。

## how

安装以下几个依赖：

```json
// package.json
{
  // ...
  // 忽略其他代码
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1",
    "lint": "lint-staged"
  },
  "dependencies": {
    "eslint": "^7.25.0",
    "eslint-config-airbnb": "^18.2.1",
    "eslint-config-prettier": "^8.3.0",
    "eslint-import-resolver-alias": "^1.1.2",
    "eslint-plugin-import": "^2.22.1",
    "eslint-plugin-jsx-a11y": "^6.4.1",
    "eslint-plugin-prettier": "^3.4.0",
    "eslint-plugin-react": "^7.23.2",
    "husky": "^6.0.0",
    "lint-staged": "^10.5.4",
    "module-alias": "^2.2.2",
    "prettier": "^2.2.1"
  },
  "husky": {
    "hooks": {
      "pre-commit": "lint-staged"
    }
  },
  "lint-staged": {
    "**/*.js": [
      "eslint --fix",
      "git add"
    ]
  },
  "_moduleAliases": {
    "@root": ".",
    "@lib": "./lib"
  }
}
```

配置 **.eslintrc.js**

```js
module.exports = {
  // 使用 airbnb, prettier 推荐的规范
  extends: ['airbnb', 'plugin:prettier/recommended'],
  parserOptions: {
    // 使用 es6
    ecmaVersion: 6,
    sourceType: 'module',
  },
  // 自定义规则
  rules: {
    'arrow-body-style': 0,
    strict: 0,
    'no-console': 0,
    'func-names': 0,
    'space-before-function-paren': 0,
    'no-param-reassign': 0,
    'import/no-dynamic-require': 0,
    'global-require': 0,
    'consistent-return': 0,
  },
  // 配置别名
  settings: {
    'import/resolver': {
      alias: {
        map: [['@', '.']],
        extensions: ['.js'],
      },
    },
  },
};

```

配置好之后，安装 vscode 插件 eslint，这样可以在项目编译前检查错误，另外需要重启 vscode 使配置生效。

接下来配置 husky，安装依赖后运行以下命令：

```bash
# husky v6 版本是需要先安装的，会在项目下生成 .husky 目录
node_modules/.bin/husky install

# 添加 pre-commit 钩子
node_modules/.bin/husky set .husky/pre-commit "npm run lint"
```

到此为止，项目就配置完了，接下来可以测试一下，修改一个文件，然后 commit 的时候，就会自动运行 **npm run lint** 了。

> !注意如果 husky 没生效，一定要确认 git 是在 **node_modules/.bin/husky set .husky/pre-commit "npm run lint"** 之前初始化的。


## 总结

添加项目规范，可以保证项目的格式统一，养成良好的开发习惯。


（完）