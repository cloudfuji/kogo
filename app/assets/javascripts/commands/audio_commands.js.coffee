audioCommands =
  options:
    playCommandPattern: /^\/play .+/
    stfuCommandPattern: /^\/stfu/
    stopCommandPattern: /^\/stop/

  playCommand: (message) ->
    console.log("message: ", message)
    url = message.content.split("/play ")[1]
    $('.audio_actions:first').audio('play', url)

$('.chat_history:first').chat_history('registerCommand', { priority: 20, name: 'play', pattern: audioCommands.playCommandPattern, cb: audioCommands.playCommand })
$('.chat_history:first').chat_history('registerCommand', { priority: 20, name: 'stfu', pattern: audioCommands.stfuCommandPattern, cb: audioCommands.pause       })
$('.chat_history:first').chat_history('registerCommand', { priority: 20, name: 'stop', pattern: audioCommands.stopCommandPattern, cb: audioCommands.pause       })

console.log("finished")
