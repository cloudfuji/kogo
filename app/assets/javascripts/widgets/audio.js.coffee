audio =
  options:
    volume         : 0
    localSounds    : {}
    focused        : true
    toggleElement  : $('#audio_toggle')
    sharedChannel  : $('.audio_common')[0]
    privateChannel : $('.audio_private')[0]

  _create: ->
    @options.toggleElement.click($.proxy(this.toggle, this))

    $(document).bind("#{ @namespace }.play", @play)
    $(document).bind("#{ @namespace }.pause", @pause)
    $(document).bind('kogo.chat_history.newMessage', $.proxy(@ding, this))
    console.log("Binding focus event...")
    $(window).focus($.proxy(@setFocused, this)).blur($.proxy(@setUnfocused, this))

  setFocused: ->
    @options.focused = true
    console.log("Focused: ", @options.focused)

  setUnfocused: ->
    @options.focused = false
    console.log("Focused: ", @options.focused)

  _init: ->
    @options.enabled = true

    localSounds =
      "gobushido": @localFileUrl("hey.mp3")
      "claps"    : @localFileUrl("cheer.mp3")
      "kolaveri" : @localFileUrl("kolaveri.mp3")
      "ding"     : @localFileUrl("ding.mp3")

  enable: ->
    @setVolume 1
    @options.toggleElement.attr('src', '/assets/sound-on.png')

  disable: ->
    @setVolume 0
    @options.toggleElement.attr('src', '/assets/sound-off.png')

  setVolume: (volume) ->
    @options.sharedChannel.volume = volume
    @options.privateChannel.volume = volume

  toggle: ->
    if @options.enabled
      @options.enabled = false
      @disable()
    else
      @options.enabled = true
      @enable()

  setAudioUrl: (url) ->
    @options.sharedChannel.setAttribute('src', url)

  play: (url) ->
    @options.sharedChannel.setAudoUrl(url)
    @options.sharedChannel.play()

  pause: ->
    @options.sharedChannel.pause()

  localFileUrl: (fileName) ->
    return "http://#{ window.location.hostname }:#{ window.location.port }/sounds/#{ fileName }"

  ding: ->
    console.log(@options.focused)
    if !@options.focused
      @options.privateChannel.setAttribute('src', "http://#{ window.location.hostname }:#{ window.location.port }/sounds/ding.wav")
      @options.privateChannel.play()

$.widget "kogo.audio", audio
