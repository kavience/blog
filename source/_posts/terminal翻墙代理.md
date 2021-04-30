---
title: terminal翻墙代理
catalog: true
tags:
  - 翻墙
categories:
  - tools
abbrlink: 28167
translate_title: terminal-over-the-wall-proxy
date: 2020-07-21 10:06:58
subtitle:
header_img:
---

## What？

> 通过 [proxychains-ng](https://github.com/rofl0r/proxychains-ng) 实现 terminal 代理

## Why？

> 目前的代理功能，大部分底层都是基于 socks5、http 等，然后配合插件如 SwitchyOmega 等，实现在浏览器端代理，或者是全局代理，但问题是在 terminal 下仍然不走代理。即使通过 `export http_proxy=http://127.0.0.1:1081 https_proxy=http://127.0.0.1:1081` 发现还是不行。这几天终于忍受不了，我觉得一定有人跟我一样的想法，肯定有人已经着手在做这件事情。果然，偶然发现 [proxychains-ng](https://github.com/rofl0r/proxychains-ng) 这款开源软件，决定试一下。

## How？

经过昨天的实践，经过一顿操作后，发现不行，然后就果断关机下班了。今早到公司再打开 terminal 试下，发现昨天已经成功了。

### 关闭 Mac 的 SIP

重启 Mac，按住 Option 键进入启动盘选择模式，再按 `⌘ + R` 进入 Recovery 模式。实用工具( Utilities )-> 终端( Terminal )。输入命令 `csrutil disable` 运行。重启进入系统后，终端里输入 `csrutil status`，结果中如果有 `System Integrity Protection status:disabled`。则说明关闭成功。

### brew 安装 proxychains-ng

```bash
brew install proxychains-ng
```

### 配置代理

brew 安装后，proxychains-ng 的配置文件在 `/usr/local/etc/proxychains.conf` 下，在文件最后

```bash
......
# 找到 ProxyList
[ProxyList]
# 配置本地已经有的 socks5代理
socks5  127.0.0.1 1086
```

### 测试效果

运行命令

```bash
proxychains4 curl ipinfo.io
```

输出结果如下：

```bash
[proxychains] config file found: /usr/local/etc/proxychains.conf
[proxychains] preloading /usr/local/Cellar/proxychains-ng/4.14/lib/libproxychains4.dylib
[proxychains] DLL init: proxychains-ng 4.14
[proxychains] Strict chain  ...  127.0.0.1:1080  ...  ipinfo.io:80  ...  OK
{
  "ip": "103.121.211.104",
  "city": "Tokyo",
  "region": "Tokyo",
  "country": "JP",
  "loc": "35.6895,139.6917",
  "org": "AS4785 xTom",
  "postal": "151-0052",
  "timezone": "Asia/Tokyo",
  "readme": "https://ipinfo.io/missingauth"
}
```

### 增加别名

每次使用都需要输入 `proxychains4` ，显得太长了，增加别名在 .zshrc 下进行优化，

```bash
# 增加 alias
alias out='proxychains4'
```

### 结语

此后，每次在需要翻墙的情况下，只需要在命令前，加上 `out` 即可。

当然 proxychains-ng 还有更加丰富的功能，貌似可以实现任意软件的翻墙，但由于我不需要，也没有去研究这个，以后有需要再说吧。
