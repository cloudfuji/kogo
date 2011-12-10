# $(document).ready() equivalent
$ ->
  console.log("Loading audio lib")

  audioPlayer = $('audio')[0]
  console.log(audioPlayer)
  console.log($('audio')[0])

  setAudioUrl = (url) ->
    audioPlayer.setAttribute('src', url)

  play = ->
    audioPlayer.play()

  pause = ->
    audioPlayer.pause()

  interface =
    play: play
    pause: pause
    player: audioPlayer
    setAudioUrl: setAudioUrl

  window.kogo ?= {}
  window.kogo.audio = interface

  console.log("Finished loading audio lib")
