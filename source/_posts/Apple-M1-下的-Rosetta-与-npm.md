---
layout: apple
title: Apple M1 下的 Rosetta 与 npm
translate_title: rosetta-and-npm-under-apple-m1
date: 2021-03-26 14:07:46
tags:
  - apple
categories:
  - tools
---

## what

新版的 Apple M1 是基于 arm 架构的，然而大部分的软件 和 npm 包都还没有适配 arm 架构，所以苹果公司就使用 Rosetta 来兼容 x86 架构的软件。

## why

第一次使用 x86 软件的时候，系统会自动提示安装 Rosetta ，安装后直接运行软件即可。

然而，今天遇到一个非常奇怪的问题，在安装依赖的时候我发现无法安装 `node-canvas` 这个包，经过一系列的排查，我发现问题出在这里：

```shell
...
npm ERR! node-pre-gyp http 404 status code downloading tarball https://github.com/Automattic/node-canvas/releases/download/v2.7.0/canvas-v2.7.0-node-v88-darwin-unknown-arm64.tar.gz
...
```

无法找到 `canvas-v2.7.0-node-v88-darwin-unknown-arm64.tar.gz` 这个包，顺着 node-canvas 的 releases 发现，根本就没有发布这个包，只有 `canvas-v2.7.0-node-v88-darwin-unknown-x64.tar.gz`，这个时候我突然意识到，当前是以 arm 架构运行的 terminal 和 npm，所以识别出来后，自动去寻找适合 arm 架构的包，然而并没有适配 arm 的包，所以就导致无法安装。

## how

我顺着使用 x86 架构的软件的思路，我觉得既然软件可以移植到 M1 上，npm 肯定也是可以的，一定有某种方法，而且肯定与 Rosetta 有关。终于，想到办法了。

1. 在应用程序中找到 terminal ，然后右键 `显示简介`，发现有个选项 `使用Rosetta打开`
2. 打开一个 terminal，然后卸载 node ，再重新安装一次。(我是使用 nvm 安装的 node)
3. 使用该版本的 node 安装依赖，发现成功了。


## 总结

简而言之就是安装依赖的时候，发现依赖不适用于 arm 架构的 M1，只能使用 x86 架构的依赖，所以需要借助于 Rosetta 去安装依赖。