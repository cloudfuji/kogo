(($, undefined_) ->

  audio =
    options: {
      enabled: true
    }

    _create: ->
      $ele = @element
      self = this
      $('#audio_toggle').click((event) -> #this should be teased ou
        event.preventDefault
        window.kogo.audio.toggle())

    _init: ->
      return

    destory: ->
      $.widget::apply this, arguments

    enable: ->
      _audioPlayer.volume = 1
      audioPlayer.volume = 1
      $('#audio_toggle').attr('src', '/assets/sound-on.png')

    disable: ->
      _audioPlayer.volume = 0
      audioPlayer.volume = 0
      $('#audio_toggle').attr('src', '/assets/sound-off.png')

    toggle: ->
      if enabled
        disable()
        enabled = false
      else
        enable()
        enabled = true

    setAudioUrl: (url) ->
      audioPlayer.setAttribute('src', url)

    play: ->
      if enabled
        audioPlayer.play()

    pause: ->
      audioPlayer.pause()

    ding: ->
      _audioPlayer.setAttribute('src', "http://#{ window.location.hostname }:#{ window.location.port }/sounds/ding.wav")
      _audioPlayer.play()

  $.widget "kogo.audio", audio

) jQuery
