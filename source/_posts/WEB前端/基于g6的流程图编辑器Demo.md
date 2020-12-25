---
title: 基于g6的流程图编辑器Demo
catalog: true
date: 2020-10-14 14:01:46
subtitle:
header-img:
tags:
  - g6
  - 流程图
catagories:
  - 前端开发
---

## ✨ 特点

- 拖拽式更新工作流程图
- 数据与图双向转换

## 📦 原理

### 拖拽

基于 `react-dnd` 和 `react-dnd-html5-backend` 创建拖拽节点与背景画布。

### 图

基于 `g6` 创建可视化图，根据 api 提供的 `registerBehavior` 注册行为，监听鼠标事件，基于 g6 提供的 `ToolBar`, `Menu`, `Minimap`, `Grid` 等插件，提供更多功能。

### 样式

基于 `antd` 提供的 UI 组件优化样式。

## 💡 预览

请查看 [在线 Demo ](https://kavience.github.io/work-flow-editor)

## 🔨 说明

项目仅供学习和参考，或许不适合直接用于项目中，[项目地址](https://github.com/kavience/work-flow-editor);
