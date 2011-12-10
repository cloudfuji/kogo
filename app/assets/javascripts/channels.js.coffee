# $(document).ready() equivalent
$ ->
  console.log("Loading the channels module")

  # update_channel()
  updateChannel = () ->
    console.log "updating..."
    channelId = $.data(document, 'channelId')
    console.log channelId
    lastMessageParam = "?last_message_id="+ $.data(document, 'lastMessageId') if $.data(document, 'lastMessageId') != undefined
    messagesUrl = "/channels/#{ channelId }/messages.json#{ lastMessageParam }"
    console.log messagesUrl
    jQuery.get(messagesUrl, window.kogo.processor.processMessage)



  # Adds sets the interval for the updateChannel() function
  # It's being set to the window object so that code on any
  # other part of the page can use that to stop updating the channel
  # Useful for testing it out during development
  window.channelUpdateInterval = setInterval(updateChannel, 3000)
  console.log "finished!"
