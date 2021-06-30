---
title: docker常用命令记录
catalog: true
hidden: false
tags:
  - k8s
  - kubectl
categories:
  - dev-ops
translate_title: kubectl-common-command-record
subtitle: docker常用命令记录, 例如查看镜像、打包、导出等操作
date: 2021-06-01 16:45:00
keywords:
header_img:
---

## what
记录工作中一些常用的命令。

## why
使用的有点频繁，方便以后查找。

## how

### docker 登录
没有 url 的话默认登录到 https://hub.docker.com/，可以使用 habor 自建容器仓库
```bash
docker login $url
```

### 创建镜像

在Dockerfile所在目录下，确保Dockerfile中语法无误的情况下；运行

```bash
docker build -t $image_name:$tag_name .
```
完成之后通过`docker images` 或者`docker image ls`检查是否创建成功


### 基于已有的镜像创建对应容器并通过bash交互：
```bash
docker run -it $image_name:$tag_name /bin/bash
```

完成之后通过 `docker ps -a` 检查镜像是否创建成功

### 删除已有容器：
```bash
docker rm $container_ID
```
### 删除已有镜像：
```bash
docker rmi $image_name:$tag_name
```
### 连接已有的容器：
```bash
docker exec -it $container_ID /bin/bash
```

如果容器未启动，则需用 `docker start $container_ID` 先启动该容器

### 导出镜像
导出镜像文件
```bash
docker save $container_ID > $name
```

### 拉取和上传镜像到仓库

上传
```bash
docker push [OPTIONS] NAME[:TAG]
```

拉取
```bash
docker pull [OPTIONS] NAME[:TAG|@DIGEST]
```

### 复制宿主机的文件到容器内：
前提是需在宿主机中执行
```bash
sudo docker cp $host_path $container_ID:container_path
```

## 总结

感觉容器化是一个趋势，尤其是针对项目将来需要 SaaS 独立部署，目前只记录一些简单命令，不够完善。

更多命令：[https://docs.docker.com/engine/reference/commandline/pull/](https://docs.docker.com/engine/reference/commandline/pull/)

（完）