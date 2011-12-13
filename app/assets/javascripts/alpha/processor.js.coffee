# $(document).ready() equivalent
$ ->
  #console.log("Loading processor lib")


  # NOTES To add an action, add a key and a value to the below window.commands object.
  # The value should be a regular expression
  # Then define a window.perform_example method on the window object
  # where "example" is the name of the key listed in the commands object

  capitalize = (string) ->
    string.charAt(0).toUpperCase() + string.slice(1)

  perform = (fn, params, raw, message) ->
    fn(params, raw, message)

  extractCommand = (message) ->
    for command, details of window.kogo.commands.list
      pattern = details[0]
      fn      = details[1]

      #console.log("#{ message }.match(#{ pattern }) (#{ message.match(pattern) })")
      return fn if message.match(pattern)
    return false

  scrollToLastMessage = () ->
    $('html, body').animate({scrollTop: $("#page").offset().top}, 2000);

  unprocessedMessage = (message) ->
    !window.kogo.messages.isMessageDisplayed(message['id'])

  # processMessage(messages)
  processMessage = (messages) ->
    #console.log("Got messages")
    #console.log(messages)
    notifyNewMessage = false
    if messages.length > 0
      for message in messages
        if unprocessedMessage(message)
          content   = message["content"].trim()
          user      = message["user"]
          id        = message["id"]
          posted_at = message["posted_at"]
          command   = extractCommand(content)
          #console.log("Is message displayed?")
          #console.log(isMessageDisplayed(id))
          #console.log("command:")
          #console.log(command)
          params  = content.slice(command.length - 1, content.length)
          #console.log("params:")
          #console.log(params)
          $output = perform(command, params, content, message) if command
          #console.log("output:")
          #console.log($output)
          output_id = "message_#{ id }"
          $output ?= window.kogo.messages.defaultMessage(user, content, posted_at)
          $output.attr('id', output_id)
          #console.log(user)
          #console.log("#{ user } == #{ $.data(document, 'me') }: #{user == $.data(document, 'me')}")
          notifyNewMessage = true if user != $.data(document, 'me')
          $output.addClass('me') if user == $.data(document, 'me')
          #console.log("#{ user } == 'kogo bot': #{user == 'kogo bot'}")
          $output.addClass('announcement') if user == "kogo bot"
          $output.addClass('message-holder')
          window.kogo.messages.displayMessage($output) if not window.kogo.messages.isMessageDisplayed(id)
          $.data($("#{ output_id }", 'user', user))
      window.kogo.messages.setLastMessageId(window.kogo.messages.getLastDisplayedMessageId())
    # Unlock the updater
    #console.log("finished updating, unlocking")
    window.kogo.messages.updateLastReadMessageId()
    window.kogo.audio.ding() if notifyNewMessage && !window.kogo.messages.isFocused()
    window.kogo.channel.updateLock = false

  interface =
    processMessage: processMessage

  window.kogo ?= {}
  window.kogo.processor = interface


  # Adds sets the interval for the updateChannel() function It's being
  # set to the window object so that code on any other part of the
  # page can use that to stop updating the channel Useful for testing
  # it out during development
  #console.log "Finished!"
