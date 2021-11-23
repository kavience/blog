---
title: 利用travis做CI和CD
translate_title: use-travis-for-ci-and-cd
subtitle: 利用travis做CI和CD
date: 2021-04-21 18:46:14
catalog: true
header_img:
tags:
  - CI-CD
categories:
  - tools
---

## CI/CD 简介
CI: Continuous Integration ( 持续集成 )

CD: Continuous Delivery ( 持续交付 ) / Continuous Deployment ( 持续部署 )

![ci-cd-flow](/img/blog_img/ci-cd-flow.png)

先看 Readhat 的解释：
>CI/CD 是一种通过在应用开发阶段引入自动化来频繁向客户交付应用的方法。CI/CD 的核心概念是持续集成、持续交付和持续部署。作为一个面向开发和运营团队的解决方案，CI/CD 主要针对在集成新代码时所引发的问题（亦称：“集成地狱”）。具体而言，CI/CD 可让持续自动化和持续监控贯穿于应用的整个生命周期（从集成和测试阶段，到交付和部署）。这些关联的事务通常被统称为“CI/CD 管道”，由开发和运维团队以敏捷方式协同支持。

再看维基百科的解释：

> 在软件工程中，CI/CD或CICD通常指的是持续集成和持续交付或持续部署的组合实践。CI/CD通过在应用程序的构建、测试和部署中实施自动化，在开发和运营团队之间架起了桥梁。

以下是个人观点：

持续集成的概念，类似开发者在合并新的代码到主干分支的时候，系统自动执行构建并执行测试，并将结果通知到开发者。

持续交付的概念，在代码集成且验证通过后，自动将验证的代码放入存储库，持续交付的目标是可以拥有一个随时部署的代码版本。

持续部署的概念，作为持续交付的延伸，可以自动将代码发布到生产环境。

## CI/CD 实战

基于以上概念的描述，我举 [masos-web](https://github.com/kavience/masos-web) 这个例子

现在 masos-web 有三个分支，分别是 `master`, `dev`, `feat-test` 。

### Git 工作流
基于 Git 工作流开发， `master` 作为稳定的主分支代码，保证可以随时部署到生产环境。 `dev` 分支作为开发分支，是 `master` 分支的延伸，与 `master` 分支不会且不应该存在冲突。 `feat-test` 是相关的开发功能分支，编写相应的代码， `feat-test` 与 `dev` 存在冲突是正常的，因为有多个功能分支同时基于 `dev` 分支开发，功能分支**禁止**直接合并到 `master` 分支。

### 持续集成

- 在 `feat-test` 分支上做了部分修改，然后合并到 `dev` 分支，通过 `review` 后，再执行合并。
- 将 `dev` 分支与 `master` 分支合并，触发自动构建、代码检查等。

### 持续交付
持续交付，可生产多个版本，保证项目有多个可用的版本，一旦新版本发生了不可预知的错误，可随时使用旧版本。

- 自动生成 tag，发布版本

### 持续部署
- 自动发布最新的版本到生产环境

除自动发布外，还可随时手动选择不同的版本发布。


## Travis 使用流程

- 注册登录
  
  到 [Travis](https://travis-ci.com/) 官网登录，安装指引注册、登录、授权。如下图：

  ![ci-cd-flow](/img/blog_img/travis1.png)

  ![ci-cd-flow](/img/blog_img/travis2.png)

- 申请 GitHub token 

  申请路径为： GitHub > settings > Developer settings > Personal access tokens > Generate new token

  申请后，会得到一个例如 ghp_mZuC0e0gGxxxxxxxxxxxxxxxxx 的一个 token。
  
- 加密 GitHub token
  使用 travis 加密这个 token。步骤为：
  - 使用 sudo gem install travis 安装 travis
  - 运行命令加密：
    ```bash   
    travis encrypt GITHUB_TOKEN=ghp_mZuC0e0gGxxxxxxxxxxxxxxxxx --com
    ```
  - 会有个确认仓库的提示，输入 yes 后回车，得到一个 `secure`

- 编写 .travis.yml 
在项目下新建一个文件 `.travis.yml` ， 内容如下：
  ```yml
  # 项目为 node 开发
  language: node_js
  # node 版本
  node_js:
  - 14
  # 任务队列 
  jobs: 
    # 安装依赖
    install:
      - yarn install
    # 执行一下自定义的脚本
    script:
      # 因为 conventional-changelog-cli 和 standard-version 不用写在 package.json ，而是采用全局安装的方式
      - yarn global add conventional-changelog-cli standard-version
      - yarn build
      - yarn release
      - yarn changelog
      - cp CHANGELOG.md build/CHANGELOG.md
      - mv build/ /tmp/build
    # 只有 master 分支触发构建
    branches:
      - master
    # 部署到 github pages
    deploy:
      provider: pages
      local_dir: /tmp/build
      skip_cleanup: true
      github_token: "$GITHUB_TOKEN"
      keep_history: true
      on:
        branch: master
    # 部署后发布 tags
    after_deploy:
      - git push --follow-tags origin master
  env:
    global:
      # <secure> 替换为上一步生成的 secure
      - secure: <secure>
  ```

  > 最新消息，travis 不再为开源项目免费提供使用。换成 GitHub action 吧。