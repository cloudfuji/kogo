$ ->
  console.log("Loading messages lib")

  focused = true

  $(window).focus(() ->
    focused = true
    updateLastReadMessageId()
    messageBox().focus()
    document.title = " #{$(document).data('channelId')}").blur(() ->
      focused = false)

  isFocused = () ->
    focused

  messageBox = () ->
    $('#message_content')

  isMessageDisplayed = (id) ->
    !($("#message_#{ id }").length == 0)

  updateTitle = () ->
    if !focused && unreadMessageCount() != 0
      document.title = "(#{ unreadMessageCount() }) #{$(document).data('channelId')}"

  updateLastReadMessageId = () ->
    if focused
      $(document).data('lastReadMessageId', getLastDisplayedMessageId())
    else
      updateTitle()

  displayMessage = ($element) ->
    currentScroll = $('body').scrollTop();
    $element.appendTo(".messages")
    $('body').scrollTop(100000) if ($(document).height() - currentScroll) < 1000

  defaultMessage = (user, content, posted_at) ->
    metaString = ""
    userString = "<span class='message-author'>#{ user }</span>"
    timeString = "<span class='message-time'>at #{ posted_at }</span>"

    if user != 'kogo bot'
      metaString = "<hr><div class='message-meta'>#{userString} #{timeString}</div>"
      metaString = "<div class='message-meta'>#{timeString}</div>" if user == $('.message-author').eq(-1).text().trim()

    $("<div class='message-holder'>#{ metaString #}<div class='message-content'>#{ content #}</div></div>")

  lastReadMessageId = () ->
    parseInt($(document).data('lastReadMessageId'))

  setLastReadMessageId = (id) ->
    #console.log("#{ lastMessageId() } < #{ id }: (#{lastMessageId() < id})")
    if lastReadMessageId() < id
      $(document).data 'lastReadMessageId', id

  # This is wrong if the id's are not sequential (i.e. if there are
  # multiple chatrooms going simultaneously)
  unreadMessageCount = () ->
    ldm = parseInt(lastDisplayedMessageElement().attr('id').split('_').slice(1))
    lrm = lastReadMessageId()
    # console.log(ldm)
    # console.log(lrm)
    # console.log(ldm - lrm)
    ldm - lrm

  lastMessageId = ->
    $(document).data 'lastMessageId'

  lastDisplayedMessageElement = () ->
    messages = $('.message-holder')
    $(messages[messages.length - 1])

  setLastMessageId = (id) ->
    #console.log("#{ lastMessageId() } < #{ id }: (#{lastMessageId() < id})")
    if lastMessageId() < id
      $('#lastMessageHolder').text(id)
      $(document).data 'lastMessageId', id

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
    messageBox                : messageBox

  window.kogo.messages = interface

  console.log("finished!")
