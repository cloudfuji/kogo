$ ->
  console.log("Loading messages lib")

  focused = true

  $(window).focus(() ->
    focused = true
    updateLastReadMessageId()
    document.title = " #{$.data(document, 'channelId')}").blur(() ->
      focused = false)

  isFocused = () ->
    focused

  isMessageDisplayed = (id) ->
    !($("#message_#{ id }").length == 0)

  updateTitle = () ->
    console.log("wbsite will win!")
    if !focused && unreadMessageCount() != 0
      console.log("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
      console.log("(#{ unreadMessageCount() }) #{$.data(document, 'channelId')}")
      document.title = "(#{ unreadMessageCount() }) #{$.data(document, 'channelId')}"

  updateLastReadMessageId = () ->
    console.log("focused:")
    console.log(focused)
    if focused
      $.data(document, 'lastReadMessageId', getLastDisplayedMessageId())
    else
      updateTitle()

  displayMessage = ($element) ->
    $element.appendTo(".messages")

  defaultMessage = (user, content) ->
    userString = ""
    userString = "<span class='message-author'>#{ user }:</span>" if user != 'kogo bot'
    $("<div class='message-holder'></span>#{ userString #}<span class='message-content'>#{ content #}</span></div>")

  lastReadMessageId = () ->
    parseInt($.data(document, 'lastReadMessageId'))

  setLastReadMessageId = (id) ->
    #console.log("#{ lastMessageId() } < #{ id }: (#{lastMessageId() < id})")
    if lastReadMessageId() < id
      $.data document, 'lastReadMessageId', id

  # This is wrong if the id's are not sequential (i.e. if there are
  # multiple chatrooms going simultaneously)
  unreadMessageCount = () ->
    ldm = parseInt(lastDisplayedMessageElement().attr('id').split('_').slice(1))
    lrm = lastReadMessageId()
    console.log(ldm)
    console.log(lrm)
    console.log(ldm - lrm)
    ldm - lrm

  lastMessageId = ->
    $.data document, 'lastMessageId'

  lastDisplayedMessageElement = () ->
    messages = $('.message-holder')
    $(messages[messages.length - 1])

  setLastMessageId = (id) ->
    #console.log("#{ lastMessageId() } < #{ id }: (#{lastMessageId() < id})")
    if lastMessageId() < id
      $('#lastMessageHolder').text(id)
      $.data document, 'lastMessageId', id

  getLastDisplayedMessageId = () ->
    #console.log(lastDisplayedMessageElement())
    parseInt(lastDisplayedMessageElement().attr('id').split("_").slice(1))

  interface =
    defaultMessage            : defaultMessage
    displayMessage            : displayMessage
    setLastMessageId          : setLastMessageId
    isMessageDisplayed        : isMessageDisplayed
    getLastDisplayedMessageId : getLastDisplayedMessageId
    updateLastReadMessageId   : updateLastReadMessageId
    isFocused                 : isFocused

  window.kogo.messages = interface

  console.log("finished!")
