---
title: PSR-1基本规范
catalog: true
tags:
  - PSR规范
categories:
  - php
abbrlink: 28080
translate_title: psr1-basic-specification
date: 2020-07-08 14:31:52
subtitle:
header_img:
---

## 阅读建议

> 本文是根据 PSR 规范英文文档翻译而来，建议多次阅读以便熟悉这些规范，并在工作中用到这些规范。

## What?

> 一篇翻译而来的 PSR-1 规范

## Why?

> 通过翻译 PSR 规范，掌握 PHP 的开发规范

## How?

### 关键字

本文中的关键词 `"必须"`, `"禁止"`, `"必要"`, `"最好"`, `"最好不要"`, `"应该"`, `"不应该"`, `"建议"`, `"可以"`, `"可选"` 应按照 [RFC 2119](https://www.ietf.org/rfc/rfc2119.txt) 的规定进行解释。

### 概览

- PHP 文件`必须`使用 `<?php` 或者 `<?=` 标签开始

- PHP 文件`必须`使用不带 bom 的 UTF-8 编码

- PHP 文件`应该`要么只声明类、函数、变量等，要么引起副作用（例如生成输出，改变 .ini 配置文件等操作），但是`不应该`两者都做。

- 命名空间和类`必须`遵循自动加载规范 [PSR-0, PSR-4]

- PHP 类名`必须`以大驼峰规范命名，例如 `HomeClass`

- PHP 类文件中的常量`必须`使用下划线分隔且以大写形式声明，例如 `APP_KEY`

- 方法名`必须`以小驼峰规范命名，例如 `updateUser`

### 文件

### PHP 标签

PHP 便签`必须`使用 `<?php ?>` 或者 `<?= ?>` , `禁止`使用其它标签代替。

### 字符编码

PHP 代码`必须`使用不带 Bom 的 UTF-8 编码

### 副作用

PHP 文件`应该`要么只声明类、函数、变量等，要么引起副作用（例如生成输出，改变 .ini 配置文件等操作），但是`不应该`两者都做。

「副作用」(side effects) 一词的意思是，通过包含文件，但不直接声明类、函数、常量等而执行的逻辑操作。

「副作用」包含却不仅限于：

- 生成输出
- 直接的 require 或 include
- 连接外部服务
- 修改 ini 配置
- 抛出错误或异常
- 修改全局或静态变量
- 读或写文件等

以下是一个违反此规范的例子：

```php
<?php
// 副作用: 根本 ini 设置
ini_set('error_reporting', E_ALL);

// 副作用: 加载文件
include "file.php";

// 副作用: 生成输出
echo "<html>\n";

// 声明
function foo()
{
}
```

以下是一个符合此规范的例子：

```php
<?php
// 声明 foo 函数
function foo()
{
}

// 有条件的声明不产生副作用
if (! function_exists('bar')) {
    function bar()
    {
    }
}
```

### 命名空间和类名

命名空间和类`必须`遵循 PSR 自动加载规范：[PSR-0, PSR-4]。

根据规范，每个类都独立为一个文件，且命名空间至少有一个层次：顶级的组织名称（vendor name）。

类的命名`必须`遵循 StudlyCaps 大写开头的驼峰命名规范。

PHP 5.3 及以后版本的代码`必须`使用正式的命名空间。

例如：

```php
<?php
// PHP 5.3 以后版本:
namespace Vendor\Model;

class Foo
{
}
```

5.2.x 及之前的版本`应该`使用伪命名空间的写法，约定俗成使用顶级的组织名称（vendor name）如 Vendor\_ 为类前缀。

```php
<?php
// PHP 5.2.x 及更早版本:
class Vendor_Model_Foo
{
}
```

### 类常量、类属性、方法

此处的「类」指代所有的类、接口以及可复用代码块（traits）。

#### 常量

- PHP 类文件中的常量`必须`使用下划线分隔且以大写形式声明，例如:

```php
<?php
namespace Vendor\Model;

class Foo
{
    const VERSION = '1.0';
    const DATE_APPROVED = '2012-06-01';
}
```

#### 属性

类的属性命名`可以`遵循：

- 大写开头的驼峰式 (\$StudlyCaps)
- 小写开头的驼峰式 (\$camelCase)
- 下划线分隔式 (\$under_score)
- 本规范不做强制要求，但无论遵循哪种命名方式，都`应该`在一定的范围内保持一致。这个范围可以是整个团队、整个包、整个类或整个方法。

#### 方法

方法名`必须`为小驼峰命名
