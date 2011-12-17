chatbox =
  options:
    intervalTime: 400
    queue: []
    sendLock: false

  channelUsers: ->
    users = []
    $('.users_list_user').each((index, element) ->
      users.push($(element).text()))
    users

  channelId: ->
    $(document).data('channelId')

  currentUser: ->
    $(document).data('me')

  inputBox: ->
    @element.find('#message_content')

  _create: ->
    $form = @element.find('form')
    $message_content =  @element.find('#message_content')
    $message_content.keypress $.proxy(@processKeyPress, this)
    outgoingMessageQueueInterval = setInterval($.proxy(@processQueue, this), @options.intervalTime)

    @element.data('$form', $form)
    @element.data('$message_channel_id', @element.find('#message_channel_id'))
    @element.data('$message_content', @element.find('#message_content'))

  formToData: () ->
    data                          = {}
    data['message']               = {}
    data['message']['channel_id'] = @element.data('$message_channel_id').val()
    data['message']['content']    = @element.data('$message_content').val()
    data

  messageSubmitUrl: ->
    "/channels/#{ @channelId() }/messages.json"

  handleEnterKey: (event) ->
    if event.shiftKey == false
      if @element.data('$message_content').val().trim().replace("\n", "").length > 0
        data = @formToData()
        @queueMessage(data)
        $('.chat_history:first').chat_history('addPendingMessageToDisplay', data['message'])
        @element.data('$message_content').val("")
        @element.data('$message_content').focus()
        event.preventDefault()
        event.stopPropagation()
        false

  # TODO: This should be expanded to expand the name under the current
  # cursor position rather than just expanding potential names at the
  # end of the line
  expandName: ->
    names = @channelUsers()
    value = @inputBox().val()
    point = value.lastIndexOf("@")
    needle = value.substring(point + 1, value.length).trim()
    if needle.length > 0
      for name in names
        if name.toLowerCase().startsWith(needle)
          @inputBox().val("#{ value.substring(0, point) }#{name}")

  handleShortcutKey: (event) ->
    keys =
      e: 101
      s: 19
    if event.which == keys.s
      @expandName()
      event.preventDefault()
      event.stopPropagation()
      false


  processKeyPress: (event) ->
    keys =
      enter: 13
      tab: 9

    if event.ctrlKey == true
      return @handleShortcutKey(event)
    else if event.which == keys.enter
      return @handleEnterKey(event)

  # Ideally, this queue would be used globally for all GETs and PUTs,
  # with puts having a higher priority and being sent out sooner. This
  # way we guarantee we only hit the server with a single request at a
  # given time and treat it as a good citizen.
  queueMessage: (message) ->
    @options.queue.push(message)

  processQueue: ->
    if !@options.sendLock
      if @options.queue.length > 0
        @lockQueue()
        message = @options.queue.shift()
        $.post(@messageSubmitUrl(), message, $.proxy(@unlockQueue, this))

  lockQueue: ->
    @options.sendLock = true

  unlockQueue: ->
    # Reliable place to unshfit:
    #
    # Message was successfully sent, so now we can remove (unshift) it
    # from the queue in a safe way. This causes other problems however
    # - it's extremely easy to jam the queue so that the same message
    # retries forever, and the messages behind it never get sent
    # (although they're sent to the local chat window immediately)
    # @options.queue.shift()
    @options.sendLock = false

$.widget "kogo.chatbox", chatbox
