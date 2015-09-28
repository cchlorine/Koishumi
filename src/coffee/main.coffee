Koishumi = ((W)->
  hash = ''

  time = (value)->
    month = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']

    month = month[+value[1].replace(/^0/, '') - 1]
    day = value[2].replace(/^0/, '')

    month + ' ' + day + ', ' + value[0]

  getList = ->
    script = document.createElement 'script'
    script.src = 'https://api.github.com/repos/' + github.repo + (if github.path then github.path else '') + '/contents/?' + (if github.branch then 'ref=' + github.branch + '&' else '') + 'callback=Koishumi.showList'
    script.onload = ->
      this.remove()

    document.body.appendChild script

  showList = (data)->
    data = data.data

    i = 0
    posts = []

    while(article = data[i++])
      path = article.name.replace(/\.md$/, '').split '-'
      date = time(path)

      name = if path.length == 1 then path else path.pop()
      url  = path.join('/') + '/' + encodeURIComponent name

      posts.push {
        url: '#/' + url,
        title: name,
        date: date
      }

    document.getElementById('main').innerHTML = template 'posts-list', {posts: posts}

  getArticle = (path)->
    path = path.split('/')

    request = new XMLHttpRequest()
    request.open 'GET', 'https://raw.githubusercontent.com/'  + github.repo + '/' + (if github.branch then github.branch + '/' else '')+ (if github.path then github.path else '') + encodeURIComponent path.join('-') + '.md'

    request.onload = ->
      if request.status >= 200 and request.status < 400
        data = request.responseText

        document.getElementById('main').innerHTML = template 'article', {
          title: path.pop(),
          date: time(path),
          content: (new showdown.Converter).makeHtml data
        }

    request.send()

  matching = ->
    return location.hash = '#/home' if !location.hash.substr(2)

    hash = decodeURIComponent(location.hash.substr(2))
    if hash == 'home' then getList() else getArticle(hash)

  return console.log 'Cannot find any available repo. Complete config please.' if !github or !github.repo

  W.onhashchange = matching
  matching()

  {
    showList: showList
  }
)(this)