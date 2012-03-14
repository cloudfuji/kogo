audioCommands =
  options:
    playCommandPattern: /^\/play .+/
    stfuCommandPattern: /^\/stfu/
    stopCommandPattern: /^\/stop/
    playTemplate: $.template('playTemplate', '<div><strong><a class="audio-play">playing</a> <a target="_blank" href="${url}">${url}</a></strong></div>')
    stopTemplate: $.template('stopTemplate', '<div><strong>stopping the muzak ...</strong></div>')

  currentUser: ->
    $(document).data('me')

  defaultTemplate: (message, $content) ->
    me       = ''
    me       = 'me' if message.user == @currentUser()

    $holder  = $.tmpl('messageHolderTemplate',  { message: message, me: me })
    $meta    = $.tmpl('messageMetaTemplate',    { message: message         })

    $holder.append($meta).append($content)

  localFileUrl: (fileName) ->
    "http://#{ window.location.hostname }:#{ window.location.port }/sounds/#{ fileName }"

  localSounds: (name) ->
    sounds = {
      "gobushido": @localFileUrl("hey.mp3")
      "claps"    : @localFileUrl("cheer.mp3")
      "kolaveri" : @localFileUrl("kolaveri.mp3")
      "ding"     : @localFileUrl("ding.mp3")
      "gong"     : @localFileUrl("gong.mp3")
      }

    sounds[name]

  audioWidget: ->
    $('.actions:first')

  handlePlayLinkClick: (event, url) ->
    @audioWidget().audio('play', url)
    event.preventDefault()
    event.stopPropagation()
    return false

  playCommand: (message) ->
    soundName = message.content.split("/play ")[1]
    url = @localSounds(soundName)
    url ?= soundName
    @audioWidget().audio('play', url)
    $content = $.tmpl('playTemplate', { url: url })
    helper = (event) ->
      @handlePlayLinkClick(event, url)
    $content.find('.audio-play').click($.proxy(helper, this))
    @defaultTemplate(message, $content)

  pauseCommand: (message) ->
    @audioWidget().audio('pause')
    $content = $.tmpl('stopTemplate')
    @defaultTemplate(message, $content)

  _init: ->
    $('.chat_history:first').chat_history('registerCommand', { priority: 20, name: 'play', pattern: @options.playCommandPattern, process: $.proxy(@playCommand , this) })
    $('.chat_history:first').chat_history('registerCommand', { priority: 20, name: 'stfu', pattern: @options.stfuCommandPattern, process: $.proxy(@pauseCommand, this) })
    $('.chat_history:first').chat_history('registerCommand', { priority: 20, name: 'stop', pattern: @options.stopCommandPattern, process: $.proxy(@pauseCommand, this) })

$(document).bind('kogo.loaded', $.proxy(audioCommands._init, audioCommands))
