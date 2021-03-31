#!/bin/bash

GIT_REPOSITORIES=("git@github.com:kavience/blog.git")

echo "git running ..."
git pull origin0 master
git add -A
if [ ! -n "$1" ] ;then
    git commit -m "make a new post"
else
    git commit -m "$1"
fi


for ((i=0;i<${#GIT_REPOSITORIES[*]};++i)) do
git remote remove origin${i}
git remote add origin${i} ${GIT_REPOSITORIES[i]}
git push origin${i} master
done

echo "git push done, ready deploy"

node_modules/hexo/bin/hexo clean
node_modules/hexo/bin/hexo generate
node_modules/hexo/bin/hexo deploy

echo "deploy done"