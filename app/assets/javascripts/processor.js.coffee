# $(document).ready() equivalent
$ ->
  console.log("Loading processor lib")


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

      console.log("#{ message }.match(#{ pattern }) (#{ message.match(pattern) })")
      return fn if message.match(pattern)
    return false

  isMessageDisplayed = (id) ->
    !($("#message_#{ id }").length == 0)

  displayMessage = ($element) ->
    $element.appendTo(".messages")

  defaultMessage = (user, content) ->
    userString = ""
    userString = "<span class='message-author'>#{ user }:</span>" if user != 'kogo bot'
    $("<div class='message-holder'></span>#{ userString #}<span class='message-content'>#{ content #}</span></div>")

  lastMessageId = ->
    $.data document, 'lastMessageId'

  lastDisplayedMessageElement = () ->
    messages = $('.message-holder')
    $(messages[messages.length - 1])

  setLastMessageId = (id) ->
    console.log("#{ lastMessageId() } < #{ id }: (#{lastMessageId() < id})")
    if lastMessageId() < id
      $('#lastMessageHolder').text(id)
      $.data document, 'lastMessageId', id

  getLastDisplayedMessageId = () ->
    console.log(lastDisplayedMessageElement())
    lastDisplayedMessageElement().attr('id').split("_").slice(1)

  scrollToLastMessage = () ->
    $('html, body').animate({scrollTop: $("#page").offset().top}, 2000);

  unprocessedMessage = (message) ->
    !isMessageDisplayed(message['id'])

  # processMessage(messages)
  processMessage = (messages) ->
    console.log("Got messages")
    console.log(messages)
    if messages.length > 0
      for message in messages
        if unprocessedMessage(message)
          content = message["content"].trim()
          user    = message["user"]
          id      = message["id"]
          command = extractCommand(content)
          console.log("Is message displayed?")
          console.log(isMessageDisplayed(id))
          console.log("command:")
          console.log(command)
          params  = content.slice(command.length - 1, content.length)
          console.log("params:")
          console.log(params)
          $output = perform(command, params, content, message) if command
          console.log("output:")
          console.log($output)
          output_id = "message_#{ id }"
          $output ?= defaultMessage(user, content)
          $output.attr('id', output_id)
          console.log(user)
          console.log("#{ user } == #{ $.data(document, 'me') }: #{user == $.data(document, 'me')}")
          $output.addClass('me') if user == $.data(document, 'me')
          console.log("#{ user } == 'kogo bot': #{user == 'kogo bot'}")
          $output.addClass('announcement') if user == "kogo bot"
          $output.addClass('message-holder')
          displayMessage($output) if not isMessageDisplayed(id)
          $.data($("#{ output_id }", 'user', user))
      setLastMessageId(getLastDisplayedMessageId())
    # Unlock the updater
    console.log("finished updating, unlocking")
    window.kogo.channel.updateLock = false

  interface =
    processMessage: processMessage

  window.kogo ?= {}
  window.kogo.processor = interface


  # Adds sets the interval for the updateChannel() function It's being
  # set to the window object so that code on any other part of the
  # page can use that to stop updating the channel Useful for testing
  # it out during development
  console.log "Finished!"
