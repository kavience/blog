---
title: web前端优化总结
catalog: true
tags:
  - JavaScript
  - 优化
categories:
  - frontend
translate_title: summary-of-web-frontend-optimization
date: 2020-08-04 10:04:24
subtitle:
header_img:
---

## What

针对 web 前端优化方案的总结, 主要技术栈为 React。

## Why

与以往 PHP, JSP 等服务端渲染不同, 现如今大多数 web 端采用 React, Vue, Angular 等客户端渲染方案。单页应用带来的好处是显而易见的, 前端开发人员可以专注于前端页面的交互, 后端人员专注于数据的处理, 分工明确。另一方面得益于 nodejs 的生态, 例如 npm 包管理, webpack, gulp 打包等, 前端开发人员可以避免重复造轮子, 开发也变得越来越迅速。然而单页应用也带来另一个问题, 随着引入的库越来越多, 项目也越来越臃肿, 页面加载速度奇慢无比, 本文主要讨论针对 webpack 手动搭建的 React 项目为例做优化。

## How

首先简单罗列一下 web 开发中可以优化的点有哪些:

- 引入 CDN 资源, 图片、视频等大文件资源也可以通过 oss 等其它方式引入;
- 图片、icon 等使用 SVG;
- 样式优化( style-loader, mini css );
- 代码优化(减少 re-render 次数);
- 文件开启 GZip 压缩( Nodejs, Nginx );
- 代码拆分( webpack DllPlugin, webpack splitChunks, React.lazy );
- 客户端缓存( Cache-Control )。

下面依次讲解。

### CDN 资源引入

这是最简单粗暴的, 打包后的资源文件, 如果不做任何优化, 大部分项目中压缩后的 vender.xxx.js 文件, 大概会有 5-8 M,在国内采用 CDN 加载, 时间大概 1 - 2 s 左右, 在次基础上, 还可以进行 GZip 压缩, 以 [阿里 oss](https://help.aliyun.com/knowledge_detail/39645.html) 为例子, 采用 GZip 压缩后的资源, 大小会差不多减少三分之二, 访问时间会在 1 秒左右, 如果对项目访问速度要求不高, 这完全足够了。

另外, 例如图片、视频、音频等大文件, 肯定是要采用 CDN 的, 可能还要引入流的概念, 这里就不累述了(关键我也不熟悉)。

### 图片、icon 等使用 SVG

SVG 的优势(来源谷歌):

- SVG 图像可通过文本编辑器来创建和修改；
- SVG 图像可被搜索、索引、脚本化或压缩；
- SVG 是可伸缩的；
- SVG 图像可在任何的分辨率下被高质量地打印；
- SVG 可在图像质量不下降的情况下被放大；

另外还有些个人认为的优势, SVG 可以做动画, 可以嵌入 HTML 文件, 减少 HTTP 请求。

### 样式优化( style-loader, mini css )

针对样式, 大部分项目中会使用 less,sass 或者 stylus, 通过 `less-loader`, `sass-loader` 等各种 loader, 最后基本有两种方案, 一是通过 `css-loader` 和 `style-loader` 把生成后的样式嵌入 HTML, 作为 style 标签引入, 另一种是通过 `css-loader` 和 `miniCssExtractPlugin` 生成压缩后的 css 引入。两种方式我觉得都没什么问题, 差不多, 但我更喜欢后者。嵌入到 HTML 可以减少 HTTP 请求, 但是压缩后的样式再经过 GZip 压缩其实也就几十毫秒左右。

### 代码优化(减少 re-render 次数)

代码优化根据项目采用的框架不同, 优化方案也不同, 但万变不离其宗, 主要是减少重渲染次数。

以 React 为例, 减少 `componentWillReceiveProps` , 使用 hooks 等, 注意 state 的值, 注意什么时候该用 props, 什么时候该用 state。props 和 state 的改变都会引起 re-render , 我的总结就是: 「 在组件中, 这个值会经常改变, 再`考虑`把这个值设为 state 。」 其实也不一定准确, 还是得看具体情况, 比如, `editable`, `visible` 等这类表示某些状态的, 大多数时候都作为 state, 但也有例外, 比如 `loading`, 业务不一样, 可能在会引入 `redux` 全局状态, 在发生 HTTP 请求的时候, 设置 `loading` 为 true, 组件可以从全局去拿这个状态值。

### 文件开启 GZip 压缩( Nodejs, Nginx 等 )

GZip 在上述方案中多次提到, 如果你不想使用 CDN, 就想部署在自己的服务器中, 开启 GZip 根据不同的 web 容器, 设置的方式也不一样, 但总体思路差不多。

先说 nodejs , 基于 nodejs 的 [GZip](https://nodejs.org/docs/latest-v12.x/api/zlib.html#zlib_class_zlib_gzip) , 根据不同的 nodejs 框架有不同的使用方案, 我使用的是 koa, 引入的是 `koa-compress`, 使用方式如下:

```js
...
const compress = require("koa-compress");
const Koa = require("koa");
const server = new Koa();
server.use(
  compress({
    threshold: 1024,
    gzip: {
      flush: require("zlib").Z_SYNC_FLUSH,
    },
    deflate: {
      flush: require("zlib").Z_SYNC_FLUSH,
    },
    br: false,
  })
);
...
```

Nginx, Apache 等 web 容器, 编辑 conf 文件即可, 以 Nginx 为例:

```bash
...
# 开启gzip
gzip on;
# 启用gzip压缩的最小文件, 小于设置值的文件将不会压缩
gzip_min_length 1k;
# gzip 压缩级别, 1-9, 数字越大压缩的越好, 也越占用CPU时间, 后面会有详细说明
gzip_comp_level 1;
# 进行压缩的文件类型。javascript有多种形式。其中的值可以在 mime.types 文件中找到。
gzip_types text/plain application/javascript application/x-javascript text/css application/xml text/javascript application/x-httpd-php image/jpeg image/gif image/png application/vnd.ms-fontobject font/ttf font/opentype font/x-woff image/svg+xml;
# 是否在http header中添加Vary: Accept-Encoding, 建议开启
gzip_vary on;
# 禁用IE 6 gzip
gzip_disable "MSIE [1-6]\.";
# 设置压缩所需要的缓冲区大小
gzip_buffers 32 4k;
# 设置gzip压缩针对的HTTP协议版本, 没做负载的可以不用
# gzip_http_version 1.0;
...
```

Apache 类似。

### 代码拆分( webpack DllPlugin, webpack splitChunks, React.lazy )

#### webpack DllPlugin

使用 `webpack.DllPlugin` , 可以把常用的且基本不变的库, 单独拆分出去, 且仅需 build 一次, 可以提升打包的速度。

```js
// webpack.dll.config.js
const webpack = require("webpack");
const path = require("path");
const CopyWebpackPlugin = require("copy-webpack-plugin");

module.exports = {
  entry: {
    react: ["react", "react-dom"],
  },
  mode: "production",
  output: {
    filename: "[name].dll.[hash:6].js",
    path: path.resolve(__dirname, "dist", "dll"),
    library: "[name]_dll",
  },
  plugins: [
    new webpack.DllPlugin({
      name: "[name]_dll",
      path: path.resolve(__dirname, "dist", "dll", "manifest.json"),
    }),
  ],
};
```

在项目中使用:

```js
// webpack.config.js
...
new webpack.DllReferencePlugin({
      manifest: path.resolve(__dirname, 'dist', 'dll', 'manifest.json'),
    }),
new CleanWebpackPlugin({
    cleanOnceBeforeBuildPatterns: ['**/*', '!dll', '!dll/**', '!pdfjs', '!pdfjs/**'],
}),
...
```

> 第一次使用 webpack.dll.config.js 文件会对第三方库打包, 打包完成后就不会再打包它了, 然后每次运行 webpack.config.js 文件的时候, 都会打包项目中本身的文件代码, 当需要使用第三方依赖的时候, 会使用 DllReferencePlugin 插件去读取第三方依赖库。所以说它的打包速度会得到一个很大的提升。

#### webpack splitChunks

通过 splitChunks, 会把这些库再单独拆分出去

```js
const merge = require("webpack-merge");
const baseConfig = require("./webpack.config.js");
const opimizeCss = require("optimize-css-assets-webpack-plugin");
const TerserPlugin = require("terser-webpack-plugin");
// 打包后文件大小分析
const BundleAnalyzerPlugin = require("webpack-bundle-analyzer")
  .BundleAnalyzerPlugin;

module.exports = merge(baseConfig, {
  mode: "production",
  optimization: {
    runtimeChunk: {
      name: "manifest",
    },
    splitChunks: {
      maxInitialRequests: 10,
      cacheGroups: {
        vendor: {
          priority: 1,
          name: "vendor",
          test: /node_modules/,
          chunks: "initial",
          minSize: 0,
          minChunks: 1,
        },
        moment: {
          name: "moment",
          priority: 5,
          test: /[\/]node_modules[\/]moment[\/]/,
          chunks: "initial",
          minSize: 100,
          minChunks: 1,
        },
        lodash: {
          name: "lodash",
          priority: 6,
          test: /[\/]node_modules[\/]lodash[\/]/,
          chunks: "initial",
          minSize: 100,
          minChunks: 1,
        },
        antd: {
          name: "antd",
          priority: 7,
          test: /[\/]node_modules[\/]antd[\/]es[\/]/,
          chunks: "initial",
          minSize: 100,
          minChunks: 1,
        },
      },
    },
    minimizer: [
      new opimizeCss(),
      new TerserPlugin({
        cache: true,
        parallel: true,
        sourceMap: true,
      }),
    ],
  },
  plugins: [new BundleAnalyzerPlugin()],
});
```

#### React.lazy

理论上你可以对你的任何代码使用懒加载, 但我觉得仅对页面级别使用懒加载足以, 通过路由懒加载界面:

```js
//
// 路由列表
export const routesMapping = {
  //
  // 首页
  "/": React.lazy(() => import("@/pages/welcome")),
  "/welcome": React.lazy(() => import("@/pages/welcome")),
};
```

```js
...
{
  map(routesMapping, (Component, key) => {
    return (
      get(permissionsMapping, key) && (
        <Route
          exact
          path={key}
        >
         <Component
            {...this.props}
        />
        </Route>
      )
    );
  });
}
...
```

至此, 生产环境下打包后, 你的 js 文件将会分散为多个。

### 客户端缓存( Cache-Control )

经过以上的各种优化, 界面的访问速度已经很快了, 还有一个针对本地缓存的方案, 这个与开启 GZip 压缩类似, 以 nodejs 为例:

```js
...
server.use(async (ctx, next) => {
  if (ctx.request.path.indexOf('/api') === -1) {
    ctx.set('Cache-Control', 'public');
  } else {
    ctx.set('Cache-Control', 'no-store, no-cache, must-revalidate');
  }
  ctx.set('max-age', 7200);
  await next();
});
...
```

对除了 api 请求以外的请求进行缓存, 除了第一次访问需要网络请求资源以外, 下一次刷新将直接从本地缓存获取资源。

## 总结

优化 web 体验, 基本上是围绕 `减少资源大小( 压缩, 拆分 )`, `减少HTTP请求( svg , 样式优化 )`, `避免重绘和重排( 优化代码 )`, `提高 HTTP 访问速度( CDN )`, 如果大家有更好的优化方式, 欢迎一起讨论。
