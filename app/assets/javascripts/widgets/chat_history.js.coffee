chat_history =
  options:
    updateLocked           : false
    intervalTime           : 3000
    autoScrollThreshold    : 0.95
    oldMessageLimit        : 50
    latestMessageDisplayed : 0
    messageHolderTemplate  : $.template('messageHolderTemplate' , '<div class="message-holder ${ me }" id="message_${ message.id }"></div>' )
    messageMetaTemplate    : $.template('messageMetaTemplate'   , '<div class="message-meta"></div>'                                        )
    messageAuthorTemplate  : $.template('messageAuthorTemplate' , '<span class="message-author">${ message.user } </span> '                 )
    messageTimeTemplate    : $.template('messageTimeTemplate'   , '<span class="message-time">at ${ message.posted_at } </span> '           )
    messageContentTemplate : $.template('messageContentTemplate', '<div class="message-content">${ message.content }</div></div>'           )

  _create: ->
    # Adds sets the interval for the updateChannel() function
    # It's being set to the window object so that code on any
    # other part of the page can use that to stop updating the channel
    # Useful for testing it out during development
    if @channelId() != undefined
      chatHistoryUpdateInterval = setInterval($.proxy(@updateChannel, this), @options.intervalTime)
      @updateChannel()

    $(document).bind(@namespace+'.chatHistoryUpdate', @updateChannel);

  channelId: ->
    $(document).data('channelId')

  currentUser: ->
    $(document).data('me')

  lastMessageId: ->
    $(document).data('lastMessageId')

  updateMessagesUrl: ->
    lastMessageParam = ""
    lastMessageParam = "?last_message_id=#{ @options.latestMessageDisplayed }" unless @options.latestMessageDisplayed == 0
    "/channels/#{ @channelId() }/messages.json#{ lastMessageParam }"

  updateChannel: ->
    if not @options.updateLock
      @options.updateLock = true
      jQuery.get(@updateMessagesUrl(), $.proxy(@processMessages, this))

  compareMessageIds: (x, y) ->
    x.id - y.id

  defaultMessageTemplate: (message) ->
    me       = ''
    me       = 'me' if message.user == @currentUser()
    $holder  = $.tmpl('messageHolderTemplate',  { message: message, me: me })
    $meta    = $.tmpl('messageMetaTemplate',    { message: message         })
    $author  = $.tmpl('messageAuthorTemplate',  { message: message         })
    $time    = $.tmpl('messageTimeTemplate',    { message: message         })
    $content = $.tmpl('messageContentTemplate', { message: message         })
    $holder.append($meta.append($author).append($time)).append($content)

  pastAutoScrollThreshold: ->
    currentPosition     = $('body').scrollTop();
    totalHeight         = $(document).height() - $(window).height()
    scrollPercentage    = (currentPosition) / (totalHeight)
    scrollPercentage > @options.autoScrollThreshold

  scrollToLatestMessage: ->
    $('body').scrollTop(100000)

  messagesInDisplay: ->
    _messages = []
    $('.message-holder').each((index, element) ->
      _id = parseInt($(element).attr('id').split("_")[1])
      _id = 0 if isNaN(_id)
      _messages.push(_id))
    _messages.sort()

  isMessageDisplayed: (message) ->
    @messagesInDisplay().indexOf(message.id) != -1

  updateLatestDisplayedMessage: ->
    messages = @messagesInDisplay()
    @options.latestMessageDisplayed = messages[messages.length - 1]

  removeOldMessages: ->
    messageIds  = @messagesInDisplay().sort()
    countToCull = (@options.oldMessageLimit - messageIds.length) * -1
    if countToCull > 0
      cullableMessageIds = messageIds.slice(0, countToCull)
      @removeMessages(cullableMessageIds)

  removeMessage: (messageId) ->
    $("#message_#{ messageId }").remove()

  removeMessages: (messageIds) ->
    for messageId in messageIds
      @removeMessage(messageId)

  addPendingMessageToDisplay: (message) ->
    _message           = {}
    _message.id        = "pending"
    _message.content   = message.content
    _message.posted_at = "just now"
    _message.user      = @currentUser()
    @addMessageToDisplay(_message)
    @scrollToLatestMessage() if @pastAutoScrollThreshold()

  addMessageToDisplay: (message) ->
    $output = @defaultMessageTemplate(message)
    @addRawOutputToDisplay($output)

  addRawOutputToDisplay: ($output) ->
    $output.appendTo(@element)

  checkForPendingMessage: (message) ->
    found = false
    $('.message-holder').each((index, element) ->
      $element = $(element)
      _id = $element.attr('id').split("_")[1]
      if _id == "pending"
        if $element.children('.message-content').text() == message.content
          $element.attr('id', "message_#{ message.id }")
          $element.children('.message-meta').children('.message-time').text("at #{ message.posted_at }")
          found = true)

    return found

  processMessages: (messages) ->
    notifyNewMessage = false
    triggerScroll = @pastAutoScrollThreshold()
    if messages.length > 0
      for message in messages.sort(@compareMessageIds)
        if !@isMessageDisplayed(message)
          _message           = {}
          _message.id        = message.id
          _message.content   = message.content
          _message.posted_at = message.posted_at
          _message.user      = message.user

          if !@checkForPendingMessage(message)
            @addMessageToDisplay(message)
            notifyNewMessage = true

    @updateLatestDisplayedMessage()

    if triggerScroll
      @removeOldMessages()
      @scrollToLatestMessage()

    @options.updateLock = false

    if notifyNewMessage
      $(document).trigger("#{ @namespace }.newMessage")

$.widget "kogo.chat_history", chat_history
