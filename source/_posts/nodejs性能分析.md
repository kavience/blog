---
title: nodejs性能分析
catalog: true
hidden: false
tags:
  - JavaScript
categories:
  - frontend
date: 2021-10-22 11:59:28
translate_title: nodejs-performance-analysis
subtitle: 使用 nodejs 自带命令参数 prof 以及 chrome dev tool 和 ab 工具进行 nodejs 项目性能分析 
keywords: nodejs,性能,分析
header_img:
---

## what
使用 nodejs 自带命令参数 prof 以及 chrome dev tool 和 ab 工具进行 nodejs 项目性能分析。

## why
好久没写博客了，今天看到一个关于 nodejs 性能分析的视频，特此记录一下。

刚好工作中有用到 nodejs 写项目，也在尝试自己写一个基于 nodejs 的 restful 框架。


## how

### nodejs 自带的性能分析
首先 node 是自带性能分析的，使用以下命令
```
node --prof xxx.js
```
增加 `prof` 参数会在与应用程序的本地运行相同的目录中生成了一个刻度文件。形式为 isolate-0xnnnnnnnnnnnn-v8.log (其中 n 为数字)。

如果是一个 web 项目，可以使用 ab 工具进行压力测试，以增加更多分析数据。例如:
```
ab -c50 -t10 http://127.0.0.1:8080/xxxx
```

nodejs 会自动把进程信息存储在 isolate-0xnnnnnnnnnnnn-v8.log 内，该文件根本无法阅读，需要使用 nodejs 的刻度处理器，使用 `--prof-process` 参数。

```
node --prof-process isolate-0xnnnnnnnnnnnn-v8.log > analysis.txt
```

查看 analysis.txt 就可以看到更适合阅读的格式，

查看关于 `prof` 的[更多详解](https://nodejs.org/zh-cn/docs/guides/simple-profiling/)

### 使用 chrome 调试 nodejs 项目
自带的分析工具，还是不够直观，而且操作不够方便，nodejs 本身是基于 v8 引擎开发的，所以我们可以直接使用 chrome 的开发工具进行调试项目。
```
node --inspect-brk xxx.js
```

使用 `inspect-brk` 参数可以启动调试，启动后会开启一个 wobsocket 服务。
我们可以在 chrome 浏览器地址栏中输入 `chrome://inspect` 进入开发工具，可以发现 target 下有一个 `inspect` 按钮，点击就可以进入调试模式了。接下来就和前端调试一样了，可以在 dev-tool 中看到源码、记录快照以及打印结果。

查看关于 `inspect-brk` 的[更多详解](https://nodejs.org/zh-cn/docs/guides/debugging-getting-started/)

## 总结
本文只简单记录，不够完善，以后有空再来深入了解。


（完）