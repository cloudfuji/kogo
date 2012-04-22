# $(document).ready() equivalent
$ ->
  console.log("Loading audio_commands")

  audio = window.kogo.audio

  localFileUrl = (fileName) ->
    return "http://#{ window.location.hostname }:#{ window.location.port }/sounds/#{ fileName }"

  localSounds =
    "gofuji"   : localFileUrl("hey.mp3")
    "claps"    : localFileUrl("cheer.mp3")
    "kolaveri" : localFileUrl("kolaveri.mp3")
    "ding"     : localFileUrl("ding.mp3")

  pause = () ->
    audio.pause()
    $("<div class='message'>stopping the muzak</div>")

  play = (url) ->
    console.log("playing #{ url }")
    audio.setAudioUrl(url)
    audio.play()
    $("<div class='message'>Playing~~ #{url}</div>")

  playCommand = (params, raw) ->
    console.log("params:")
    console.log(params)
    console.log("raw:")
    console.log(raw)
    params = raw.split(" ").slice(1).join(" ")
    for sound, url of localSounds
      return play(url) if params.trim().match(sound)
    if params.trim().match(/^http/)
      play(params.trim())

  $('#audio_toggle').click((event) ->
    event.preventDefault
    window.kogo.audio.toggle())

  window.kogo.commands.register('play', /^\/play .*/, playCommand)
  window.kogo.commands.register('stfu', /^\/stfu/, pause)
  window.kogo.commands.register('stop', /^\/stop/, pause)

  console.log("finished")
