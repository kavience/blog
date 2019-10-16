#!/bin/bash

GIT_REPOSITORIES=("git@github.com:kavience/kavience.github.io.git" "git@gitee.com:kavience/blog.git")

git add -A
git commit -m "make a new post"

for ((i=0;i<${#GIT_REPOSITORIES[*]};++i)) do
# echo ${GIT_REPOSITORIES[i]}
remote=git remote -v
echo remote
# git remote add origin${i} ${GIT_REPOSITORIES[i]}
# git push origin${i} master
done
