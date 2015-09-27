var Koishumi;

Koishumi = (function(W) {
  var getArticle, getList, hash, matching, showList, time;
  hash = '';
  time = function(value) {
    var day, month;
    month = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    month = month[+value[1].replace(/^0/, '') - 1];
    day = value[2].replace(/^0/, '');
    return month + ' ' + day + ', ' + value[0];
  };
  getList = function() {
    var script;
    script = document.createElement('script');
    script.src = 'https://api.github.com/repos/' + github.repo + (github.path ? github.path : '') + '/contents/?' + (github.branch ? 'ref=' + github.branch + '&' : '') + 'callback=Koishumi.showList';
    script.onload = function() {
      return this.remove();
    };
    return document.body.appendChild(script);
  };
  showList = function(data) {
    var article, date, i, name, path, posts, url;
    data = data.data;
    i = 0;
    posts = [];
    while ((article = data[i++])) {
      path = article.name.replace(/\.md$/, '').split('-');
      date = time(path);
      name = path.length === 1 ? path : path.pop();
      url = path.join('/') + '/' + encodeURIComponent(name);
      posts.push({
        url: '#/' + url,
        title: name,
        date: date
      });
    }
    return document.getElementById('main').innerHTML = template('posts-list', {
      posts: posts
    });
  };
  getArticle = function(path) {
    var request;
    path = path.split('/');
    request = new XMLHttpRequest();
    request.open('GET', 'https://raw.githubusercontent.com/' + github.repo + '/' + (github.branch ? github.branch + '/' : '') + (github.path ? github.path : '') + encodeURIComponent(path.join('-') + '.md'));
    request.onload = function() {
      var data;
      if (request.status >= 200 && request.status < 400) {
        data = request.responseText;
        return document.getElementById('main').innerHTML = template('article', {
          title: path.pop(),
          date: time(path),
          content: (new showdown.Converter).makeHtml(data)
        });
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
  if (!github || !github.repo) {
    return console.log('Cannot find any available repo. Complete config please.');
  }
  W.onhashchange = matching;
  matching();
  return {
    showList: showList
  };
})(this);
