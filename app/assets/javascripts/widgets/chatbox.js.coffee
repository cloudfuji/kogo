chatbox =
 options: {
   intervalTime: 1000
 }

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
   channelId = $(document).data('channelId')
   if event.which == 13
     data = @formToData()
     target = "/channels/#{ channelId }/messages.json"
     $.post(target, data)
     @element.data('$message_content').val("")
     @element.data('$message_content').focus()
     event.preventDefault()
     event.stopPropagation()
     false

$.widget "kogo.chatbox", chatbox
