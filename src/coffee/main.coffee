Koishumi = ((W, D) ->
  hash = ''

  converter = new showdown.Converter {
    omitExtraWLInCodeBlocks: true,
    parseImgDimensions: true,
    simplifiedAutoLink: true,
    literalMidWordUnderscores: true,
    tables: true,
    tasklists: true
  }

  time = (value) ->
    month = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']

    month = month[+value[1].replace(/^0/, '') - 1]
    day = value[2].replace(/^0/, '')

    month + ' ' + day + ', ' + value[0]

  loadScript = (url) ->
    script = D.createElement 'script'

    script.src = url
    script.async = true

    script.onload = ->
      this.remove()

    (D.getElementsByTagName('head')[0] || D.getElementsByTagName('body')[0]).appendChild script

  getConfig = (name, context, after, before) ->
    return '' if context and !config[context]

    value = (config[context] || config)[name]
    return if value then (if before then before else '') + value + (if after then after else '') else ''

  getList = ->
    loadScript 'https://api.github.com/repos/' + getConfig('repo', 'github') + getConfig('path', 'github') + '/contents/?' + getConfig('branch', 'github', '&', 'ref=') + 'callback=Koishumi.showList'

  showList = (data) ->
    data = data.data

    i = 0
    posts = []

    while(article = data[i++])
      path = article.name.replace(/\.md$/, '').split '-'

      posts.push {
        url: '#/' + encodeURIComponent(path.join '/'),

        title: path.pop(),
        date: time(path)
      }


    D.title = 'Home'
    D.getElementById('main').innerHTML = template 'posts-list', {posts: posts.reverse()}

  getArticle = (path) ->
    path = path.replace(/\/$/, '').split '/'

    request = new XMLHttpRequest()
    request.open 'GET', 'https://raw.githubusercontent.com/'  + getConfig('repo', 'github') + '/' + getConfig('branch', 'github', '/') + getConfig('path', 'github') + encodeURIComponent path.join('-') + '.md'

    request.onload = ->
      if request.status >= 200 and request.status < 400
        data = request.responseText
        name = path.pop()

        D.title = name
        D.getElementById('main').innerHTML = template 'article', {
            title: name,
            date: time(path),

            url: location.href,
            comment: {
              type: getConfig 'type', 'comment'
            },

            content: converter.makeHtml data
          }

        switch config.comment.type
          when 'disqus'
            setTimeout ->
              if W.DISQUS then DISQUS.reset {
                  reload: true,
                  config: ->
                    this.page.identifier = title;
                    this.page.url = location.href;
                }
              else
                setTimeout ->
                  loadScript '//' + getConfig('shortname', 'comment') + '.disqus.com/embed.js'
            , 1000

          when 'duoshuo'
            setTimeout ->
              if W.DUOSHUO then DUOSHUO.EmbedThread '.ds-thread'
              else
                W.duoshuoQuery = {short_name: getConfig('shortname', 'comment')}
                loadScript '//static.duoshuo.com/embed.js'
            , 1000

    request.send()

  matching = ->
    return location.hash = '#/home' if !location.hash.substr(2)

    hash = decodeURIComponent(location.hash.substr(2))
    if hash == 'home' then getList() else getArticle(hash)

  return console.log 'Cannot find any available repo. Complete config please.' if !getConfig('repo', 'github')

  W.onhashchange = matching
  matching()

  {
    showList: showList
  }
)(this, document)