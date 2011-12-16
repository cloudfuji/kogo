chatbox =
  options:
    intervalTime: 400
    queue: []
    sendLock: false

  channelId: ->
    $(document).data('channelId')

  currentUser: ->
    $(document).data('me')

  _create: ->
    $form = @element.find('form')
    $message_content =  @element.find('#message_content')
    $message_content.keypress $.proxy(@sendMessage, this)
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

  sendMessage: (event) ->
    if event.which == 13 and @element.data('$message_content').val().trim().replace("\n", "").length > 0
      if event.shiftKey == false
        data = @formToData()
        @queueMessage(data)
        $('.chat_history:first').chat_history('addPendingMessageToDisplay', data['message'])
        @element.data('$message_content').val("")
        @element.data('$message_content').focus()
        # TODO: Add in a newline at cursor position if the shift key
        # is held down
      event.preventDefault()
      event.stopPropagation()
      false

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
