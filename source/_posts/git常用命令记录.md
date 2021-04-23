---
title: git常用命令记录
catalog: true
top: true
hidden: false
tags:
  - git
categories:
  - tools
translate_title: git-common-command-record
date: 2021-04-23 10:17:23
subtitle:
header-img:
---

## what
一篇关于 Git 常用命令的记录文章。

## why

Git 在工作中成了必不可少的工具，个人比较喜欢使用 Git 命令，但是 Git 命令其实比较繁杂，有点难记，例如 `rebase`, `reset` 等，只要不用的时间久了，就会忘记。所以特此记录。

## how

### git clone

用法： `git clone [<options>] [--] <repo> [<dir>]`

作用： 克隆一个仓库到本地

常用：
- -b
  - 克隆指定分支： `git clone -b test git@github.com:kavience/blog.git`


### git status

用法： `git status [<options>] [--] <pathspec>...`

作用： 查看暂存区

常用：
- s
  - 简要显示暂存区

### git add

用法： `git add [<options>] [--] <pathspec>...`

作用： 添加修改（包括添加、删除、修改等操作）到暂存区

常用：
- A
  - 添加所有修改到暂存区，等同于 `git add .`


### git log

用法： `git log [<options>] [<revision-range>] [[--] <path>...]`

作用： 查看日志

常用：
- 统计个人代码量
  - `git log --author="username" --pretty=tformat: --numstat | awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "added lines: %s, removed lines: %s, total lines: %s\n", add, subs, loc }' -`
- 统计所有人增删行数
  - `git log --format='%aN' | sort -u | while read name; do echo -en "$name\t"; git log --author="$name" --pretty=tformat: --numstat | awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "added lines: %s, removed lines: %s, total lines: %s\n", add, subs, loc }' -; done`


### git commit

用法： `git commit [<options>] [--] <pathspec>...`

作用： 提交暂存区里面的修改，并生成一个唯一的 commit 号

常用：

### git push

用法： `git push [<options>] [<repository> [<refspec>...]]`

作用： 上传当前仓库的 commit 到远程仓库地址

常用：
- 上传一个远程仓库不存在的分支
  - `git push --set-upstream [origin] [branch]`
- 强制上传，会强制替换远程仓库（`慎用！！！`）
  - `git push -f [origin] [branch]` 
- 上传 tag 到仓库
  - `git push [origin] [tag name]`
  - `git push [origin] --tags` 上传所有 tag


### git fetch

用法：
```bash
git fetch [<options>] [<repository> [<refspec>...]]
   or: git fetch [<options>] <group>
   or: git fetch --multiple [<options>] [(<repository> | <group>)...]
   or: git fetch --all [<options>]
```

作用： 拉取远程分支

常用：
- 拉取指定远程分支
  - `git fetch [origin] [branch]`
- 拉取所有分支
  - `git fetch --all`


### git merge

用法：
```
git merge [<options>] [<commit>...]
   or: git merge --abort
   or: git merge --continue
```

作用： 合并分支

常用：
- 合并指定分支到当前分支
  - `git merge [target_branch]`
- 当有冲突的时候，继续合并（必须先解决冲突）
  - `git merge --continue`


### git pull

用法： `git pull [<options>] [<repository> [<refspec>...]]`

作用： 拉取远程分支并与本地分支合并

常用：
- 本地分支与远程分支合并
  - `git pull origin [origin_branch]:[local_branch]`
  - 如果本地分支与远程分支存在跟踪关系，可以直接使用  `git pull origin [branch]` ，建立跟踪关系可以使用 `git branch --set-upstream [local_branch] origin/[origin_branch]`


### git branch

用法： 
```
git branch [<options>] [-r | -a] [--merged | --no-merged]
   or: git branch [<options>] [-l] [-f] <branch-name> [<start-point>]
   or: git branch [<options>] [-r] (-d | -D) <branch-name>...
   or: git branch [<options>] (-m | -M) [<old-branch>] <new-branch>
   or: git branch [<options>] (-c | -C) [<old-branch>] <new-branch>
   or: git branch [<options>] [-r | -a] [--points-at]
   or: git branch [<options>] [-r | -a] [--format]
```

作用： 查看、新建、删除、跟踪等操作分支

常用：
- 查看本地所有分支
  - `git branch`
  - `git branch -v` 带最后一次 commit
- 建立新分支
  - `git branch [branch_name]`
- 删除分支
  - `git branch -d [branch]`
  - `git branch -D [branch]` 强制删除，丢弃修改（慎用！！！）
- 本地分支和远程分支建立跟踪关系
  - `git branch --set-upstream [local_branch] origin/[origin_branch]`

### git checkout

用法：
```
git checkout [<options>] <branch>
   or: git checkout [<options>] [<branch>] -- <file>...
```

作用： 切换分支、 tag 、 commit ，或创建且切换到新分支

常用：
- 切换分支或指定 commit ，或者指定 tag
  - `git checkout [branch|commit|tag]`
- 创建新分支，且切换到该分支
  - `git checkout -b [branch]`


### git stash

用法： 
```
git stash list [<options>]
   or: git stash show [<options>] [<stash>]
   or: git stash drop [-q|--quiet] [<stash>]
   or: git stash ( pop | apply ) [--index] [-q|--quiet] [<stash>]
   or: git stash branch <branchname> [<stash>]
   or: git stash clear
   or: git stash [push [-p|--patch] [-k|--[no-]keep-index] [-q|--quiet]
          [-u|--include-untracked] [-a|--all] [-m|--message <message>]
          [--] [<pathspec>...]]
   or: git stash save [-p|--patch] [-k|--[no-]keep-index] [-q|--quiet]
          [-u|--include-untracked] [-a|--all] [<message>]
```

作用： 暂存和恢复进度

常用：
- 查看所有暂存的进度
  - `git stash list`
- 暂存当前修改
  - `git stash`
- 恢复进度
  - `git stash apply` 恢复最近的一次进度
  - `git stash apply [stash]` 恢复指定的进度
  - `git stash drop [stash]` 删除该进度
  - `git stash pop [stash]` 恢复指定的进度并删除该进度

### git rebase

用法： `git commit [<options>] [--] <pathspec>...`

作用： 合并多次 commit 、分支合并、保持一个简洁的 commit 信息

常用：
- 合并多次 commit
  - `git rebase -i HEAD~[n]` n 为 commit 次数
- 分支合并
  - `git rebase [branch]`  合并分支到当前分支，和 merge 不一样的是不会产生 commit 信息，确保当前分支是只有本人使用，否则可能会产生丢失别人的 commit 信息。


### git reset

用法： 
```
git reset [--mixed | --soft | --hard | --merge | --keep] [-q] [<commit>]
   or: git reset [-q] [<tree-ish>] [--] <paths>...
   or: git reset --patch [<tree-ish>] [--] [<paths>...]

    -q, --quiet           be quiet, only report errors
    --mixed               reset HEAD and index
    --soft                reset only HEAD
    --hard                reset HEAD, index and working tree
    --merge               reset HEAD, index and working tree
    --keep                reset HEAD but keep local changes
    --recurse-submodules[=<reset>]
                          control recursive updating of submodules
    -p, --patch           select hunks interactively
    -N, --intent-to-add   record only the fact that removed paths will be added later
```

作用： 回滚到某个 commit

常用：
- 软回滚，保留文件修改，硬回滚，丢失文件修改
  - `git reset --[soft|hard] HEAD` 最近一次，等同于 `git reset --[soft|hard] HEAD~0`
  - `git reset --[soft|hard] HEAD^` 上一次，等同于 `git reset --[soft|hard] HEAD~1`
  - `git reset --[soft|hard] HEAD^^` 上两次，等同于 `git reset --[soft|hard] HEAD~2`
  - `git reset --[soft|hard] HEAD^n^` 上n次，等同于 `git reset --[soft|hard] HEAD~n`

## 总结

这只是个人工作中总结常用的一些命令，并不全面，会持续更新。

（完）