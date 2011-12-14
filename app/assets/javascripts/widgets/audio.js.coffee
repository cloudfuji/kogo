audio =
  options: {
    enabled: true
    volume: 0
    toggle_element: $('#audio_toggle')
    private_channel: $('.audio_private')
    shared_channel: $('.audio_common')
    # localFileUrl: (fileName) ->
    #   return "http://#{ window.location.hostname }:#{ window.location.port }/sounds/#{ fileName }"
    # localSounds:
    #   "gobushido": @localFileUrl("hey.mp3")
    #   "claps"    : @localFileUrl("cheer.mp3")
    #   "kolaveri" : @localFileUrl("kolaveri.mp3")
    #   "ding"     : @localFileUrl("ding.mp3")
  }

  _create: ->
    @options.toggle_element.click($.proxy(this.toggle, this))

    $(document).bind("#{@namespace}.play", @play)
    $(document).bind("#{@namespace}.pause", @pause)

  enable: ->
    @setVolume 0
    @options.toggle_element.attr('src', '/assets/sound-on.png')

  disable: ->
    @setVolume 0
    @options.toggle_element.attr('src', '/assets/sound-off.png')

  setVolume: (volume) ->
    @element.volume = volume

  toggle: ->
    if @option('enabled')
      @disable()
      @option('enabled',false)
    else
      @enable()
      @option('enabled', true)

  setAudioUrl: (url) ->
    @element.setAttribute('src', url)

  play: (url) ->
    if url
      @setAudoUrl url
    if @enabled()
      @element.play()

  pause: ->
    @element.pause()

  ding: ->
    @setAttribute('src', "http://#{ window.location.hostname }:#{ window.location.port }/sounds/ding.wav")
    @play()

$.widget "kogo.audio", audio
