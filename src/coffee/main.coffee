Koishumi = ((W)->
  hash = ''

  time = (value)->
    month = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']

    month = month[+value[1].replace(/^0/, '') - 1]
    day = value[2].replace(/^0/, '')

    month + ' ' + day + ', ' + value[0]

  loadScript = (url)->
    script = document.createElement 'script'

    script.src = url
    script.async = true

    script.onload = ->
      this.remove()

    (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild script

  getList = ->
    loadScript 'https://api.github.com/repos/' + config.github.repo + (if config.github.path then config.github.path else '') + '/contents/?' + (if config.github.branch then 'ref=' + config.github.branch + '&' else '') + 'callback=Koishumi.showList'

  showList = (data)->
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

    document.getElementById('main').innerHTML = template 'posts-list', {posts: posts}

  getArticle = (path)->
    path = path.replace(/\/$/, '').split '/'

    request = new XMLHttpRequest()
    request.open 'GET', 'https://raw.githubusercontent.com/'  + config.github.repo + '/' + (if config.github.branch then config.github.branch + '/' else '')+ (if config.github.path then config.github.path else '') + encodeURIComponent path.join('-') + '.md'

    request.onload = ->
      if request.status >= 200 and request.status < 400
        data = request.responseText

        document.getElementById('main').innerHTML = template 'article', {
            title: path.pop(),
            date: time(path),

            url: location.href,
            comment: {
              type: if config.comment.type then config.comment.type else ''
            },

            content: (new showdown.Converter).makeHtml data
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
                  loadScript '//' + config.comment.shortname + '.disqus.com/embed.js'
            , 1000

          when 'duoshuo'
            setTimeout ->
              if W.DUOSHUO then DUOSHUO.EmbedThread '.ds-thread'
              else
                W.duoshuoQuery = {short_name: config.comment.shortname}
                loadScript '//static.duoshuo.com/embed.js'
            , 1000

    request.send()

  matching = ->
    return location.hash = '#/home' if !location.hash.substr(2)

    hash = decodeURIComponent(location.hash.substr(2))
    if hash == 'home' then getList() else getArticle(hash)

  return console.log 'Cannot find any available repo. Complete config please.' if !config.github or !config.github.repo

  W.onhashchange = matching
  matching()

  {
    showList: showList
  }
)(this)