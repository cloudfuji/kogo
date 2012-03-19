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
      "cheer"           : @localFileUrl("cheer.mp3")
      "ding"            : @localFileUrl("ding.wav")
      "female_dying"    : @localFileUrl("female_dying.wav")
      "female_laugh"    : @localFileUrl("female_laugh.wav")
      "fight"           : @localFileUrl("fight.wav")
      "final"           : @localFileUrl("final.wav")
      "gobushido"       : @localFileUrl("hey.mp3")
      "gong"            : @localFileUrl("gong.mp3")
      "hadouken"        : @localFileUrl("hadouken.wav")
      "hey"             : @localFileUrl("hey.mp3")
      "kolaveri"        : @localFileUrl("kolaveri.mp3")
      "lose"            : @localFileUrl("lose.wav")
      "male_dying"      : @localFileUrl("male_dying.wav")
      "male_laugh"      : @localFileUrl("male_laugh.wav")
      "perfect"         : @localFileUrl("perfect.wav")
      "round"           : @localFileUrl("round.wav")
      "shoryuken"       : @localFileUrl("shoryuken.wav")
      "sonicboom"       : @localFileUrl("sonicboom.wav")
      "tetsumaki"       : @localFileUrl("tetsumaki.wav")
      "win"             : @localFileUrl("win.wav")
      "yatta"           : @localFileUrl("yatta.wav")
      "you"             : @localFileUrl("you.wav")
      "you-win-perfect" : @localFileUrl("you_win_perfect.wav")
      "you-win-laugh"   : @localFileUrl("you_win_perfect_laugh.wav")
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
