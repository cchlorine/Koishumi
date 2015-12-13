Koishumi
===
Koishumi is a blogging platform based [Github API](https://developer.github.com/v3/).

## What's Koishumi?
Quite a few static blogging platforms need building files.
But in Koishumi, you don't need to build any file. There is just one thing you should do, that is to push markdown files to your repo, and you'll find your blog is ready.

## How to use it?
1. Fork this repo to your account.
2. Change settings and titles.
3. Upload files.
4. Enjoy!

## How to set up Comments?
Koishumi supports two kinds of comment hosting service, one is [Disqus](https://disqus.com/) and the other is [DuoShuo](http://duoshuo.com/).
To use it, just change the setting in `index.html`.

Like this,
```
var config = {
  ...
  comment: {
    type: 'disqus',
    shortname: 'koishumi'
  }
}
```
Change `koishumi` to your site's shortname!

## Bugs and feature reporting
Search for existing and closed issues, if it's not addressed yet, [open a new issue](https://github.com/Kunr/Koishumi/issues/new).

## LICENSE
This software is free to use under [the Apache 2.0](https://github.com/Kunr/Koishumi/blob/master/LICENSE).
