---
title: 记一次React项目搭建
catalog: true
tags:
  - Reactjs
categories:
  - front-end
translate_title: remember-to-build-a-react-project
date: 2020-06-15 18:30:09
subtitle:
header-img:
---

## 阅读建议

> 先整体快速阅读一遍，再回头看其中的配置。

## What？

> 通过 npm、webpack、babel、typescript 等工具，自己搭建一次 React 的 typescript 项目。

## Why？

> 之前用过 next.js、ant-design-pro、create-react-app 等各种脚手架搭建过 react 项目，但是在使用过程中发现这些框架要么灵活性不足、要么打包后的文件过大等，所以决定手动搭建一次项目。

## How？

### 准备工具

- node > v10

### 所需依赖项

package.json 文件如下：

```json
{
  "name": "react-demo",
  "version": "1.0.0",
  "main": "index.js",
  "scripts": {
    "dev": "cross-env ENVIRONMENT_MODE=dev env-cmd node index.js",
    "start": "cross-env ENVIRONMENT_MODE=production env-cmd node index.js",
    "build": "webpack --config webpack.product.config.js",
    "build:dll": "webpack --config webpack.config.dll.js"
  },
  "author": "kavience",
  "license": "ISC",
  "dependencies": {
    // babel 包
    "@babel/core": "^7.10.2",
    "@babel/plugin-proposal-class-properties": "^7.10.1",
    "@babel/plugin-proposal-object-rest-spread": "^7.10.1",
    "@babel/preset-env": "^7.10.2",
    "@babel/preset-react": "^7.10.1",
    "@babel/preset-typescript": "^7.10.1",
    "babel-loader": "^8.1.0",
    "babel-plugin-import": "^1.13.0",
    // koa 相关的包，用于启动服务，代替 webpack-dev-server
    "koa": "^2.12.0",
    "koa-proxies": "^0.11.0",
    "koa-static": "^5.0.0",
    "koa2-connect-history-api-fallback": "^0.1.2",
    "koa-webpack": "^5.3.0",
    // react 相关
    "react": "^16.13.1",
    "react-dom": "^16.13.1",
    "redux": "^4.0.5",
    "redux-thunk": "^2.3.0",
    // typescript相关
    "typescript": "^3.9.5",
    "@types/react": "^16.9.35",
    "@types/react-dom": "^16.9.8",
    "@types/react-redux": "^7.1.9",
    "@types/react-router-dom": "^5.1.5",

    // webpack 相关
    "webpack": "^4.43.0",
    "webpack-cli": "^3.3.11",
    "webpack-merge": "^4.2.2",
    "webpack-bundle-analyzer": "^3.8.0",
    "clean-webpack-plugin": "^3.0.0",
    "copy-webpack-plugin": "^6.0.2",
    "css-loader": "^3.5.3",
    "file-loader": "^6.0.0",
    "html-webpack-plugin": "^4.3.0",
    "less": "^3.11.3",
    "less-loader": "^6.1.0",
    "less-vars-to-js": "^1.3.0",
    "mini-css-extract-plugin": "^0.9.0",
    "optimize-css-assets-webpack-plugin": "^5.0.3",
    "postcss-loader": "^3.0.0",
    "url-loader": "^4.1.0",
    "compression": "^1.7.4",
    "cross-env": "^7.0.2",
    "env-cmd": "^10.1.0",
    "terser-webpack-plugin": "^3.0.3",

    // prettierrc 格式化，直接引用 umijs
    "@umijs/fabric": "^2.1.0"
  }
}
```

以上这些包，直接网上搜这些就能明白其用处，在此就不赘述。

### 配置 babel

在根目录下新建 .babelrc 文件：

```json
{
  "presets": [
    "@babel/preset-env",
    "@babel/preset-typescript",
    "@babel/preset-react"
  ],
  "plugins": [
    "@babel/proposal-class-properties",
    "@babel/proposal-object-rest-spread",
    // 这里是配置 antd 按需加载
    [
      "import",
      {
        "libraryName": "antd",
        "style": true
      }
    ]
  ]
}
```

### 配置 tsconfig.json

```json
{
  "compilerOptions": {
    "outDir": "build/dist",
    "module": "esnext",
    "target": "esnext",
    "lib": ["esnext", "dom"],
    "sourceMap": true,
    "allowUnreachableCode": true,
    "allowUnusedLabels": true,
    "baseUrl": ".",
    "jsx": "preserve",
    "allowSyntheticDefaultImports": true,
    "moduleResolution": "node",
    "forceConsistentCasingInFileNames": false,
    "noImplicitReturns": true,
    "suppressImplicitAnyIndexErrors": true,
    "noUnusedLocals": true,
    "allowJs": true,
    "skipLibCheck": true,
    "experimentalDecorators": true,
    "strict": true,
    "paths": {
      // 这里是添加别名，用 @ 代替 src 目录
      "@/*": ["./src/*"]
    },
    "noEmit": true,
    "esModuleInterop": true,
    "resolveJsonModule": true,
    "isolatedModules": true
  },
  "exclude": [
    "node_modules",
    "build",
    "dist",
    "scripts",
    "acceptance-tests",
    "webpack",
    "jest",
    "src/setupTests.ts",
    "tslint:latest",
    "tslint-config-prettier"
  ]
}
```

### 配置 webpack 基本配置

在根目录下新建 webpack.base.config.js：

```JavaScript
const webpack = require('webpack');
const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const { CleanWebpackPlugin } = require('clean-webpack-plugin');
const miniCssExtractPlugin = require('mini-css-extract-plugin');
const fs = require('fs');
const lessToJS = require('less-vars-to-js');
const FilterWarningsPlugin = require('webpack-filter-warnings-plugin');

// 这里是替换 ant-design 的less 样式变量，新建 variables.less
const themeVariables = lessToJS(fs.readFileSync(path.resolve(__dirname, './src/assets/less/variables.less'), 'utf8'));

module.exports = {
  entry: ['./src/index.tsx'],
  output: {
    filename: 'js/vendor.[hash].js',
    path: path.join(__dirname, '/dist'),
    publicPath: '/',
  },
  resolve: {
    // 配置别名
    alias: {
      '@': path.resolve(__dirname, 'src'),
    },
    extensions: ['.ts', '.tsx', '.js'],
  },
  module: {
    rules: [
      {
        test: /\.(ts|js)x?$/,
        use: {
          loader: 'babel-loader',
        },
        exclude: /node_modules/,
      },
      {
        test: /\.(png|jpg|gif|svg|jpeg)$/,
        use: [
          {
            loader: 'file-loader',
            options: {
              name: 'img/[name]_[hash:6].[ext]',
            },
          },
        ],
      },
      {
        test: /\.css$/,
        use: [
          {
            loader: miniCssExtractPlugin.loader,
          },
          'css-loader',
        ],
      },
      {
        test: /\.less$/,
        use: [
          {
            loader: miniCssExtractPlugin.loader,
          },
          'css-loader',
          {
            loader: 'less-loader',
            options: {
              lessOptions: {
                javascriptEnabled: true,
                modifyVars: themeVariables,
              },
            },
          },
        ],
      },
    ],
  },
  plugins: [
    // 如果没有按需加载，这句是为了忽略浏览器警告
    new FilterWarningsPlugin({
      exclude: /mini-css-extract-plugin[^]*Conflicting order between:/,
    }),
    // 配置 html
    new HtmlWebpackPlugin({
      template: './public/index.html',
      favicon: './public/assets/favicon.png',
    }),
    // 采用 css 就好了，不用 style-loader ，把 css 统一压缩放入 dist/css 文件夹即可
    new miniCssExtractPlugin({
      filename: 'css/[name].css',
    }),
    // 配置 dll，基本不会修改的包，采用 dll 的方式引入，
    new webpack.DllReferencePlugin({
      manifest: path.resolve(__dirname, 'dist', 'dll', 'manifest.json'),
    }),
    // 重新打包的时候，忽略这些文件
    new CleanWebpackPlugin({
      cleanOnceBeforeBuildPatterns: ['**/*', '!dll', '!dll/**'],
    }),
  ],
};

```

### 配置 webpack 开发环境

在根目录下新建 webpack.dev.config.js，直接合并，设置 mode ，打开 source-map 即可。

```JavaScript
const merge = require('webpack-merge');
const baseConfig = require('./webpack.base.config.js');

module.exports = merge(baseConfig, {
  mode: 'development',
  devtool: 'inline-source-map',
});
```

### 配置 webpack 生产环境

在根目录下新建 webpack.production.config.js：

```JavaScript
const merge = require('webpack-merge');
const baseConfig = require('./webpack.base.config.js');
const opimizeCss = require('optimize-css-assets-webpack-plugin');
const TerserPlugin = require('terser-webpack-plugin');
const BundleAnalyzerPlugin = require('webpack-bundle-analyzer').BundleAnalyzerPlugin;

module.exports = merge(baseConfig, {
  mode: 'production',
  optimization: {
    runtimeChunk: {
      name: 'manifest',
    },
    // 拆分打包后的 js 文件
    splitChunks: {
      cacheGroups: {
        default: {
          filename: 'common.js',
          chunks: 'initial',
          priority: -20,
        },
        vendors: {
          chunks: 'initial',
          test: /[\\/]node_modules[\\/]/,
          filename: 'vendor.js',
          priority: -10,
        },
        vendorsAsync: {
          chunks: 'async',
          test: /[\\/]node_modules[\\/]/,
          name: 'vendorsAsync',
          priority: 0,
        },
        antv: {
          chunks: 'async',
          test: /[\\/]node_modules[\\/]@antv[\\/]/,
          name: 'antv',
          priority: 10,
        },
        antd: {
          chunks: 'initial',
          test: /[\\/]node_modules[\\/]antd[\\/]/,
          filename: 'antd.js',
          priority: 20,
        },
        moment: {
          chunks: 'async',
          test: /[\\/]node_modules[\\/]moment[\\/]/,
          name: 'moment',
          priority: 30,
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
  // 打包后分析文件
  plugins: [new BundleAnalyzerPlugin()],
});

```

### 配置 webpack dll 编译

```JavaScript
const webpack = require('webpack');
const path = require('path');
const CopyWebpackPlugin = require('copy-webpack-plugin');

module.exports = {
  entry: {
    // 把 react、react-dom 作为 dll 文件引入
    react: ['react', 'react-dom'],
  },
  mode: 'production',
  output: {
    filename: '[name].dll.[hash:6].js',
    path: path.resolve(__dirname, 'dist', 'dll'),
    library: '[name]_dll',
  },
  plugins: [
    new webpack.DllPlugin({
      name: '[name]_dll',
      path: path.resolve(__dirname, 'dist', 'dll', 'manifest.json'),
    }),
  ],
};
```

### 添加项目启动文件

```JavaScript
const cp = require('child_process');
const os = require('os');
const path = require('path');
const Koa = require('koa');
const static = require('koa-static');
const proxy = require('koa-proxies');
const config = require('./webpack.dev.config.js');
const koaWebpack = require('koa-webpack');
const { historyApiFallback } = require('koa2-connect-history-api-fallback');

// 从 process 中获取变量
const {
  HOST_URL = 'http://api.example.com',
  FORM_DESCRIPTION_URL = 'http://api-form.example.com/',
  APP_PORT = 3333,
  ENVIRONMENT_MODE = 'dev',
} = process.env;
const isDev = ENVIRONMENT_MODE === 'dev';
const server = new Koa();
// 打包后的文件的目录
const staticPath = './dist';

// 代理白名单
server.use(historyApiFallback({ whiteList: ['/api/*'] }));
// 指向静态文件
server.use(static(path.join(__dirname, staticPath)));
// proxy 代理
server.use(
  proxy('/api/form-descriptions(.*)', {
    target: FORM_DESCRIPTION_URL,
    changeOrigin: true,
    logs: true,
    secure: false,
  }),
);
server.use(
  proxy('/api/(.*)', {
    target: HOST_URL,
    changeOrigin: true,
    logs: true,
    secure: false,
  }),
);

// 获取本机地址
function getIPAdress() {
  const interfaces = os.networkInterfaces();
  for (const devName in interfaces) {
    const iface = interfaces[devName];
    for (let i = 0; i < iface.length; i++) {
      const alias = iface[i];
      if (alias.family === 'IPv4' && alias.address !== '127.0.0.1' && !alias.internal) {
        return alias.address;
      }
    }
  }
}

if (isDev) {
  const webpack = require('webpack');
  const compiler = webpack(config);
  // 支持热更新
  koaWebpack({
    configPath: path.join(__dirname, '.', 'webpack.dev.config.js'),
  }).then((middleware) => {
    server.use(middleware);
    server.listen(APP_PORT, () => {
      console.log(`apiHostUrl: ${HOST_URL}, formDescriptionUrl: ${FORM_DESCRIPTION_URL}`);
      console.log(`App running at: http://localhost:${APP_PORT}`);
      console.log(`- Local: http://localhost:${APP_PORT}`);
      console.log(`- Network: http://${getIPAdress()}:${APP_PORT}`);
      if (isDev) {
        switch (process.platform) {
          case 'darwin':
            cp.exec(`open http://localhost:${APP_PORT}`);
            break;
          case 'win32':
            cp.exec(`start http://localhost:${APP_PORT}`);
            break;
          default:
            cp.exec(`open http://localhost:${APP_PORT}`);
        }
      }
    });
  });
} else {
  server.listen(APP_PORT, () => {
    console.log(`apiHostUrl: ${HOST_URL}, formDescriptionUrl: ${FORM_DESCRIPTION_URL}`);
    console.log(`App running at: http://localhost:${APP_PORT}`);
    console.log(`- Local: http://localhost:${APP_PORT}`);
    console.log(`- Network: http://${getIPAdress()}:${APP_PORT}`);
  });
}
```

### 编辑 .env 文件

.env 文件主要是为了通过配置文件的方式配置变量。

```bash
# 端口
APP_PORT=3333

# api 接口地址
HOST_URL="http://api.example.com"

# 表单配置
FORM_DESCRIPTION_URL="http://api-form.example.com"

```

### 启动命令

再回到 script 命令：

```json
{
  "scripts": {
    // 开发模式
    "dev": "cross-env ENVIRONMENT_MODE=dev env-cmd node index.js",
    // 生产模式
    "start": "cross-env ENVIRONMENT_MODE=production env-cmd node index.js",
    // 打包文件
    "build": "webpack --config webpack.product.config.js",
    // 打包 dll 文件
    "build:dll": "webpack --config webpack.config.dll.js"
  }
}
```

(完)
