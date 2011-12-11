# $(document).ready() equivalent
$ ->
  #console.log("Loading the channels module")

  window.kogo.users = $.data document, 'users'
  window.kogo.users ?= []

  window.kogo.channel ?= {}
  window.kogo.channel.updateLock = false

  channelId = () ->
    $.data(document, 'channelId')

  intervalTime = 1000

  # update_channel()
  updateChannel = () ->
    #console.log "updating..."
    #console.log channelId()
    lastMessageParam = "?last_message_id="+ $.data(document, 'lastMessageId') if $.data(document, 'lastMessageId') != undefined
    messagesUrl = "/channels/#{ channelId() }/messages.json#{ lastMessageParam }"
    #console.log messagesUrl
    #console.log("updateLocked? #{ window.kogo.channel.updateLock }")
    if not window.kogo.channel.updateLock
      #console.log("not locked, locking and updating")
      window.kogo.channel.updateLock = true
      jQuery.get(messagesUrl, window.kogo.processor.processMessage)

  updateUsers = (channel) ->
    #console.log(channel)
    users = []
    for user_id, time of channel['users']
      #console.log(user_id)
      #console.log(time)
      users.push(parseInt(user_id))
    #console.log(users)
    window.kogo.users = users

  retrieveUsers = () ->
    channelUrl = "/channels/#{ channelId() }.json"
    jQuery.get(channelUrl, updateUsers)

  # Adds sets the interval for the updateChannel() function
  # It's being set to the window object so that code on any
  # other part of the page can use that to stop updating the channel
  # Useful for testing it out during development
  if channelId() != undefined
    #console.log("Checking for new messages every #{ intervalTime }ms")
    window.channelUpdateInterval = setInterval(updateChannel, intervalTime)
    window.userUpdateInterval    = setInterval(retrieveUsers, 30000)
    retrieveUsers()

  #console.log "finished!"
