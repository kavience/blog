#!/bin/bash

GIT_REPOSITORIES=("git@github.com:kavience/blog.git")

echo "git running ..."
git pull origin0 master
git add -A
git commit -m "make a new post"

for ((i=0;i<${#GIT_REPOSITORIES[*]};++i)) do
git remote remove origin${i}
git remote add origin${i} ${GIT_REPOSITORIES[i]}
git push origin${i} master
done

echo "git push done, ready deploy"

hexo clean
hexo generate
hexo deploy

echo "deploy done"
