# $(document).ready() equivalent
$ ->
  #console.log("Loading the channels module")

  window.kogo.users = $(document).data 'users'
  window.kogo.users ?= []

  window.kogo.channel ?= {}
  window.kogo.channel.updateLock = false

  channelId = () ->
    $(document).data('channelId')

  intervalTime = 1000

  # update_channel()
  updateChannel = () ->
    #console.log "updating..."
    #console.log channelId()
    lastMessageParam = "?last_message_id="+ $(document).data('lastMessageId') if $(document).data('lastMessageId') != undefined
    messagesUrl = "/channels/#{ channelId() }/messages.json#{ lastMessageParam }"
    #console.log messagesUrl
    #console.log("updateLocked? #{ window.kogo.channel.updateLock }")
    if not window.kogo.channel.updateLock
      #console.log("not locked, locking and updating")
      window.kogo.channel.updateLock = true
      jQuery.get(messagesUrl, window.kogo.processor.processMessage)

  updateUsers = (channel) ->
    users = []
    for user in channel["users"]
      users.push user
    $(document).data("users", users)
    window.kogo.users = users

  updateElements = (event, key, users) ->
    updateUserList(users) if key == "users"

  updateUserList = (users) ->
    for user in users
      if $("#user_#{user.id}").length==0
        $("<div class='user' id='user_#{user.id}'>#{user.name}</div>").appendTo(".users")

  retrieveUsers = () ->
    channelUrl = "/channels/#{ channelId() }.json"
    jQuery.get(channelUrl, updateUsers)

  $(document).bind('changeData', updateElements)

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
  $('body').scrollTop(100000)
