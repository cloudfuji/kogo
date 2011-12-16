chat_history =
  options:
    updateLocked           : false
    focused                : true
    intervalTime           : 3000
    autoScrollThreshold    : 0.80
    oldMessageLimit        : 50
    unreadMessageCount     : 0
    latestMessageDisplayed : 0
    commands               : []
    messageHolderTemplate  : $.template('messageHolderTemplate' , '<div class="message-holder ${ me }" id="message_${ message.id }"></div>'                  )
    messageMetaTemplate    : $.template('messageMetaTemplate'   , '<div class="message-meta"></div>'                                                         )
    messageAuthorTemplate  : $.template('messageAuthorTemplate' , '<span class="message-author">${ message.user } </span> '                                  )
    messageTimeTemplate    : $.template('messageTimeTemplate'   , '<span class="message-time">at ${ message.posted_at } </span> '                            )
    messageContentTemplate : $.template('messageContentTemplate', '<div class="message-content">${ message.content }</div></div>'                            )
    meTemplate             : $.template('meTemplate', '<div class="message-content"><strong>*** ${ message.user } ${ message.content }</strong></div></div>' )

  _create: ->
    # Adds sets the interval for the updateChannel() function
    # It's being set to the window object so that code on any
    # other part of the page can use that to stop updating the channel
    # Useful for testing it out during development
    if @channelId() != undefined
      chatHistoryUpdateInterval = setInterval($.proxy(@updateChannel, this), @options.intervalTime)
      @updateChannel()
      $(document).bind('#{ @namespace }.newMessage', $.proxy(@updateTitle, this))
      $(document).bind("#{ @namespace }.chatHistoryUpdate", @updateChannel);
      $(window).focus($.proxy(@setFocused, this)).blur($.proxy(@setUnfocused, this))
      @options.commands.push({ priority: 0, name: 'default', pattern: /^.*/, process: $.proxy(@defaultMessageTemplate, this) })
      @options.commands.push({ priority: 10, name: 'me', pattern: /^\/me/, process: $.proxy(@meTemplate, this) })

  # Returns the registered commands sorted by priority, highest first
  registeredCommands: ->
    @options.commands.sort((x, y) -> y.priority - x.priority)

  registerCommand: (command) ->
    @options.commands.push(command)

  setFocused: ->
    @options.unreadMessageCount = 0
    document.title = "#{ @channelId() }"
    @options.focused = true

  setUnfocused: ->
    @options.focused = false

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

  updateTitle: ->
    if !@options.focused && @options.unreadMessageCount > 0
      document.title = "(#{ @options.unreadMessageCount }) #{ @channelId() }"

  compareMessageIds: (x, y) ->
    x.id - y.id

  meTemplate: (message) ->
    me       = ''
    me       = 'me' if message.user == @currentUser()

    message.content = message.content.split("/me ")[1]

    $holder  = $.tmpl('messageHolderTemplate',  { message: message, me: me })
    $meta    = $.tmpl('messageMetaTemplate',    { message: message         })
    $time    = $.tmpl('messageTimeTemplate',    { message: message         })
    $content = $.tmpl('meTemplate',             { message: message         })
    $holder.append($meta.append($time)).append($content)

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
    # [priority, name, pattern, callback]
    for command in @registeredCommands()
      _content = message.content
      if _content.match(command.pattern)
        # Make a copy of the object so the command can't mutate it out
        # from under us too badly
        messageCopy = {}
        $.extend(messageCopy, message)
        $output = command.process(message).data('content', _content)
        return @addRawOutputToDisplay($output)

  addRawOutputToDisplay: ($output) ->
    $output.appendTo(@element)

  checkForPendingMessage: (message) ->
    found = false
    $('.message-holder').each((index, element) ->
      $element = $(element)
      _id = $element.attr('id').split("_")[1]
      if _id == "pending"
        metaContent = $element.data('content')
        if metaContent.rubyEscapeHtml() == message.content
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
            @options.unreadMessageCount += 1 if !@options.focused

    @updateLatestDisplayedMessage()
    # It would be nicer if this were simply attached to the #{
    # @namespace }.newMessage event
    @updateTitle()

    if triggerScroll
      @removeOldMessages()
      @scrollToLatestMessage()

    @options.updateLock = false

    if notifyNewMessage
      $(document).trigger("#{ @namespace }.newMessage")

$.widget "kogo.chat_history", chat_history
