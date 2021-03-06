---
title: kubectl常用命令记录
catalog: true
hidden: false
tags:
  - k8s
  - kubectl
categories:
  - dev-ops
translate_title: kubectl-common-command-record
subtitle: kubectl 常用命令记录，例如pod、日志、pvc、configmap、deployment、ingress、describe等操作。
date: 2021-06-01 16:45:00
keywords:
header_img:
---

## what
记录工作中一些常用的命令。

## why
使用的有点频繁，方便以后查找。

## how

创建 pod

```bash
sudo kubectl create -f <yaml文件> -n <命名空间>
```

删除 pod

```bash
sudo kubectl delete -f <yaml文件> -n <命名空间>
```

强制删除 pod

```bash
sudo kubectl delete pod <pod名字> -n eip-release --grace-period=0 --force
```

查看命名空间

```bash
sudo kubectl get namespace
```

查看命名空间下的 pods 且分组

```bash
sudo kubectl get pods -n <命名空间> |grep <关键字>
```

查看pod描述

```bash
sudo kubectl describe pod <pod 名字> -n <命名空间>
```

查看日志

```bash
sudo kubectl logs <pod名字> -n <命名空间> -c <container>
```

查看 ingress

```
sudo kubectl get ingress -A
```

进入pod

```bash
kubectl exec -ti <pod名字>  -n <命名空间>  -- sh
```

删除 pvc

```bash
sudo kubectl patch pvc <pvc名字> -p '{"metadata":{"finalizers":null}}'
```

删除 deployment

```bash
sudo kubectl delete deployment <deployment名字> -n <命名空间>
```

编辑configmap

```bash
sudo kubectl edit configmap sfa-wxwork-api-cm -n <命名空间>
```

## 总结

感觉容器化是一个趋势，尤其是针对项目将来需要 SaaS 独立部署，目前只记录一些简单命令，不够完善。


（完）