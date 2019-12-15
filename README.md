## About
This is a personal blog, only record programming skills and knowledge.

## How to use
- First you need download.
```bash
git clone https://github.com/kavience/blog.git

```
- And then update your config in _config.yml and auto-build.sh.

- Run `hexo new xxx(post name)` to make a post.

- Finally run `./auto-build.sh` to build post and push it to github, or run `./auto-build.sh xxx(commit name)` to commit this change with the message.

## Bugs need to fixs, if you download my project, it's unnecessary
1. edit node_modules/hexo-toc/lib/filter.js as following:
```
$title.attr('id', id);
// $title.children('a').remove();
// $title.html( '<span id="' + id + '">' + $title.html() + '</span>' );
// $title.removeAttr('id');
```
this can fix the post anchors list.