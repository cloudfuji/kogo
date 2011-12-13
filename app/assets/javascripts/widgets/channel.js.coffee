channel =
  options: {
    intervalTime: 1000
  }

  _create: ->
    # Adds sets the interval for the updateChannel() function
    # It's being set to the window object so that code on any
    # other part of the page can use that to stop updating the channel
    # Useful for testing it out during development
    if $(document).data('channelId') != undefined
      channelUpdateInterval = setInterval(@updateChannel, @intervalTime)

    $(document).bind(@namespace+'.updateChannel', @updateChannel);

  updateChannel: ->
    lastMessageParam = "?last_message_id="+ $.data(document, 'lastMessageId') if $.data(document, 'lastMessageId') != undefined
    messagesUrl = "/channels/#{ channelId() }/messages.json#{ lastMessageParam }"
    if not window.kogo.channel.updateLock
      window.kogo.channel.updateLock = true
      jQuery.get(messagesUrl, window.kogo.processor.processMessage)

$.widget "kogo.channel", channel
