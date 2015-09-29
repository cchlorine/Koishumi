var Koishumi;

Koishumi = (function(W, D) {
  var getArticle, getConfig, getList, hash, loadScript, matching, showList, time;
  hash = '';
  time = function(value) {
    var day, month;
    month = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    month = month[+value[1].replace(/^0/, '') - 1];
    day = value[2].replace(/^0/, '');
    return month + ' ' + day + ', ' + value[0];
  };
  loadScript = function(url) {
    var script;
    script = D.createElement('script');
    script.src = url;
    script.async = true;
    script.onload = function() {
      return this.remove();
    };
    return (D.getElementsByTagName('head')[0] || D.getElementsByTagName('body')[0]).appendChild(script);
  };
  getConfig = function(name, context, after, before) {
    var value;
    if (context && !config[context]) {
      return '';
    }
    value = (config[context] || config)[name];
    if (value) {
      return (before ? before : '') + value + (after ? after : '');
    } else {
      return '';
    }
  };
  getList = function() {
    return loadScript('https://api.github.com/repos/' + getConfig('repo', 'github') + getConfig('path', 'github') + '/contents/?' + getConfig('branch', 'github', '&', 'ref=') + 'callback=Koishumi.showList');
  };
  showList = function(data) {
    var article, i, path, posts;
    data = data.data;
    i = 0;
    posts = [];
    while ((article = data[i++])) {
      path = article.name.replace(/\.md$/, '').split('-');
      posts.push({
        url: '#/' + encodeURIComponent(path.join('/')),
        title: path.pop(),
        date: time(path)
      });
    }
    D.title = 'Home';
    return D.getElementById('main').innerHTML = template('posts-list', {
      posts: posts
    });
  };
  getArticle = function(path) {
    var request;
    path = path.replace(/\/$/, '').split('/');
    request = new XMLHttpRequest();
    request.open('GET', 'https://raw.githubusercontent.com/' + getConfig('repo', 'github') + '/' + getConfig('branch', 'github', '/') + getConfig('path', 'github') + encodeURIComponent(path.join('-') + '.md'));
    request.onload = function() {
      var data, name;
      if (request.status >= 200 && request.status < 400) {
        data = request.responseText;
        name = path.pop();
        D.title = name;
        D.getElementById('main').innerHTML = template('article', {
          title: name,
          date: time(path),
          url: location.href,
          comment: {
            type: getConfig('type', 'comment')
          },
          content: (new showdown.Converter).makeHtml(data)
        });
        switch (config.comment.type) {
          case 'disqus':
            return setTimeout(function() {
              if (W.DISQUS) {
                return DISQUS.reset({
                  reload: true,
                  config: function() {
                    this.page.identifier = title;
                    return this.page.url = location.href;
                  }
                });
              } else {
                return setTimeout(function() {
                  return loadScript('//' + getConfig('shortname', 'comment') + '.disqus.com/embed.js');
                });
              }
            }, 1000);
          case 'duoshuo':
            return setTimeout(function() {
              if (W.DUOSHUO) {
                return DUOSHUO.EmbedThread('.ds-thread');
              } else {
                W.duoshuoQuery = {
                  short_name: getConfig('shortname', 'comment')
                };
                return loadScript('//static.duoshuo.com/embed.js');
              }
            }, 1000);
        }
      }
    };
    return request.send();
  };
  matching = function() {
    if (!location.hash.substr(2)) {
      return location.hash = '#/home';
    }
    hash = decodeURIComponent(location.hash.substr(2));
    if (hash === 'home') {
      return getList();
    } else {
      return getArticle(hash);
    }
  };
  if (!getConfig('repo', 'github')) {
    return console.log('Cannot find any available repo. Complete config please.');
  }
  W.onhashchange = matching;
  matching();
  return {
    showList: showList
  };
})(this, document);
