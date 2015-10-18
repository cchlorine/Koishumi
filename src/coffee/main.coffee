Koishumi = ((window, document)->
  hash = ''

  converter = new showdown.Converter
    omitExtraWLInCodeBlocks: true
    parseImgDimensions: true
    simplifiedAutoLink: true
    literalMidWordUnderscores: true
    tables: true
    tasklists: true

  loadScript = (url, callback)->
    script = document.createElement 'script'

    script.src = url
    script.async = true

    script.onload = ->
      this.remove()
      callback()

    (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild script

  getConfig = (name, context, after, before) ->
    return '' if context and !config[context]

    value = (config[context] || config)[name]
    return if value then (if before then before else '') + value + (if after then after else '') else ''   

  path =
    month: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']

    time: (array)->
      year = array.shift()

      array[0] = this.month[array[0] - 1]
      array[1] = +array[1]

      array.join(' ') + ', ' + year

    decode: (path)->
      path = path.split '-', 4
      title = path.pop()

      title: title
      date: this.time path

      url: '#!/' + path.join('-') + '-' + encodeURIComponent title

  controller =
    home: ->
      loadScript 'https://api.github.com/repos/' + getConfig('repo', 'github') + getConfig('path', 'github') + '/contents/?' + getConfig('branch', 'github', '&', 'ref=') + 'callback=Koishumi.updateList', ->
        document.title = 'Home'

    article: (hash)->
      info = path.decode hash

      request = new XMLHttpRequest()
      request.open 'GET', 'https://raw.githubusercontent.com/'  + getConfig('repo', 'github') + '/' + getConfig('branch', 'github', '/') + getConfig('path', 'github') + hash + '.md'

      request.onload = ->
        if request.status >= 200 and request.status < 400
          data = request.responseText

          document.title = info.title
          document.getElementById('main').innerHTML = template 'article',
              url: location.href

              title: info.title
              date: info.date

              content: converter.makeHtml data
              comment:
                type: getConfig 'type', 'comment'

          controller.comment()

      request.send()
    
    comment: ->
      switch getConfig 'type', 'comment'
        when 'disqus'
          setTimeout ->
            window.disqus_identifier = document.title
            window.disqus_url = location.href

            if window.DISQUS then DISQUS.reset
              reload: true
            else loadScript '//' + getConfig('shortname', 'comment') + '.disqus.com/embed.js'
          , 1000

        when 'duoshuo'
          setTimeout ->
            if window.DUOSHUO
              DUOSHUO.EmbedThread '.ds-thread'
            else
              window.duoshuoQuery = short_name: getConfig('shortname', 'comment')
              loadScript '//static.duoshuo.com/embed.js'
          , 1000

  list =
    data: if data = JSON.parse localStorage.getItem 'koishumi' then data else localStorage.setItem('koishumi', '[]') || []

    cache: ->
      localStorage.setItem 'koishumi', JSON.stringify this.data

    update: (data)->
      list.show() if data.meta['X-RateLimit-Limit'] == 0

      length = i = data.data.length
      list.data = while article = data.data[--i]
        continue if '.md' != article.name.substr -3

        info = path.decode article.name.replace /\.md$/, ''

        id: length - i
        url: info.url

        title: info.title
        date: info.date

      list.cache()
      list.show()

    show: ->
      document.getElementById('main').innerHTML = template 'article-list', {posts: this.data}

  routing = ->
    hash = decodeURIComponent location.hash

    return location.hash = '#!/home' if hash.substr(0, 3) != '#!/' or !hash.substr 3

    if 'home' == hash.substr 3 then controller.home() else controller.article hash.substr 3

  return console.log 'Cannot find any available repo. Complete config please.' if !getConfig 'repo', 'github'

  window.onhashchange = routing
  routing()

  updateList: list.update
)(this, document)