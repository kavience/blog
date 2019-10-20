## Notice
- This is a personal blog, only record programming skills and knowledge.


## Bugs
1. edit node_modules/hexo-toc/lib/filter.js as following:
```
$title.attr('id', id);
// $title.children('a').remove();
// $title.html( '<span id="' + id + '">' + $title.html() + '</span>' );
// $title.removeAttr('id');
```
this can fix the post anchors list.