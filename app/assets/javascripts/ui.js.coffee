# $(document).ready() equivalent
$ ->
  console.log("Loading UI logic")

  $messageBox = $('#message_content')
  $form = $('#new_message')

  formToData = () ->
    data = {}
    data['message'] = {}
    data['message']['channel_id'] = $('#message_channel_id').val()
    data['message']['content'] = $('#message_content').val()
    data

  sendMessage = (event) ->
    if event.which == 13
      data = formToData()
      target = "/channels/1/messages.json"
      $.post(target, data)
      $messageBox.val("")
      $messageBox.focus()
      event.preventDefault
      event.stopPropagation

  $messageBox.keypress(sendMessage)


  console.log("finished")
