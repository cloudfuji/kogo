(($, undefined_) ->

  channel =
    options: {
      intervalTime: 1000
    }

    _create: ->
      $ele = @element
      self = this
      false

    _init: ->
      return

    destory: ->
      $.widget::apply this, arguments

    # update_channel()
    updateChannel = () ->
      lastMessageParam = "?last_message_id="+ $.data(document, 'lastMessageId') if $.data(document, 'lastMessageId') != undefined
      messagesUrl = "/channels/#{ channelId() }/messages.json#{ lastMessageParam }"
      if not window.kogo.channel.updateLock
        window.kogo.channel.updateLock = true
        jQuery.get(messagesUrl, window.kogo.processor.processMessage)

    updateUsers = (channel) ->
      users = []
      for user_id, time of channel['users']
        users.push(parseInt(user_id))
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


  $.widget "kogo.channel", channel
  console.log 'whats channel', channel
) jQuery
