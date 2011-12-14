audio =
  options: {
    enabled: true
    toggle_element: $('#audio_toggle')
  }

  _create: ->
    $ele = @element
    self = this

    @option.toggle_element.click(@toggle) -> #this should be teased out


  enable: ->
    _audioPlayer.volume = 1
    audioPlayer.volume = 1
    @option.toggle_element.attr('src', '/assets/sound-on.png')

  disable: ->
    _audioPlayer.volume = 0
    audioPlayer.volume = 0
    @option.toggle_element.attr('src', '/assets/sound-off.png')

  toggle: ->
    if @option('enabled')
      @disable()
      @option('enabled',false)
    else
      @enable()
      @option('enabled', true)

  setAudioUrl: (url) ->
    @element.setAttribute('src', url)

  play: ->
    if @enabled()
      @element.play()

  pause: ->
    @element.pause()

  ding: ->
    _audioPlayer.setAttribute('src', "http://#{ window.location.hostname }:#{ window.location.port }/sounds/ding.wav")
    _audioPlayer.play()

$.widget "kogo.audio", audio
