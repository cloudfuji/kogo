chatbox =
 options: {
   intervalTime: 1000
 }

 _create: ->
   $ele = @element
   self = this
   $form = $ele.find 'form'
   $message_content =  $ele.find '#message_content'

   $message_content.keypress $.proxy(self.sendMessage, self)

   $ele.data('$form', $form)
   $ele.data('$message_channel_id', $ele.find('#message_channel_id'))
   $ele.data('$message_content', $ele.find('#message_content'))

 formToData: () ->
   data = {}
   data['message'] = {}
   data['message']['channel_id'] = @element.data('$message_channel_id').val()
   data['message']['content'] = @element.data('$message_content').val()
   data

 sendMessage: (event) ->
   self = this
   $ele = @element
   channelId = $(document).data('channelId')
   if event.which == 13
     data = self.formToData()
     target = "/channels/#{ channelId }/messages.json"
     $.post(target, data)
     $ele.data('$message_content').val("")
     $ele.data('$message_content').focus()
     event.preventDefault()
     event.stopPropagation()
     false

$.widget "kogo.chatbox", chatbox
