chatbox =
  options:
    intervalTime: 1000

  channelId: ->
    $(document).data('channelId')

  currentUser: ->
    $(document).data('me')

  _create: ->
    $form = @element.find('form')
    $message_content =  @element.find('#message_content')
    $message_content.keypress $.proxy(@sendMessage, this)

    @element.data('$form', $form)
    @element.data('$message_channel_id', @element.find('#message_channel_id'))
    @element.data('$message_content', @element.find('#message_content'))

  formToData: () ->
    data = {}
    data['message'] = {}
    data['message']['channel_id'] = @element.data('$message_channel_id').val()
    data['message']['content'] = @element.data('$message_content').val()
    data

  sendMessage: (event) ->
    if event.which == 13
      data = @formToData()
      target = "/channels/#{ @channelId() }/messages.json"
      $.post(target, data)
      $('.chat_history:first').chat_history('addPendingMessageToDisplay', data['message'])
      @element.data('$message_content').val("")
      @element.data('$message_content').focus()
      event.preventDefault()
      event.stopPropagation()
      false

$.widget "kogo.chatbox", chatbox
