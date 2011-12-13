# $(document).ready() equivalent
$ ->
  console.log("Loading audio lib")

  _audioPlayer = $('audio')[0]
  audioPlayer = $('audio')[1]

  enabled = true

  enable = () ->
    _audioPlayer.volume = 1
    audioPlayer.volume = 1
    $('#audio_toggle').attr('src', '/assets/sound-on.png')

  disable = () ->
    _audioPlayer.volume = 0
    audioPlayer.volume = 0
    $('#audio_toggle').attr('src', '/assets/sound-off.png')

  toggle = () ->
    if enabled
      disable()
      enabled = false
    else
      enable()
      enabled = true

  console.log(audioPlayer)
  console.log($('audio')[0])

  setAudioUrl = (url) ->
    audioPlayer.setAttribute('src', url)

  play = ->
    if enabled
      audioPlayer.play()

  pause = ->
    audioPlayer.pause()

  ding = ->
    _audioPlayer.setAttribute('src', "http://#{ window.location.hostname }:#{ window.location.port }/sounds/ding.wav")
    _audioPlayer.play()

  interface =
    play        : play
    pause       : pause
    player      : audioPlayer
    setAudioUrl : setAudioUrl
    ding        : ding
    enabled     : enabled
    disable     : disable
    enable      : enable
    toggle      : toggle

  window.kogo ?= {}
  window.kogo.audio = interface

  console.log("Finished loading audio lib")
