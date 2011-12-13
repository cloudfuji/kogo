# $(document).ready() equivalent
$ ->
  console.log("Loading UI logic")

  getMessageBox = window.kogo.messages.messageBox
  $form = $('#new_message')

  channelId = () ->
    $.data(document, 'channelId')

  formToData = () ->
    data = {}
    data['message'] = {}
    data['message']['channel_id'] = $('#message_channel_id').val()
    data['message']['content'] = $('#message_content').val()
    data

  sendMessage = (event) ->
    if event.which == 13
      console.log(event)
      event.preventDefault()
      if event.shiftKey == false
        data = formToData()
        target = "/channels/#{ channelId() }/messages.json"
        $.post(target, data)
        getMessageBox().val("")
        getMessageBox().focus()
      else
        getMessageBox().val(getMessageBox().val() + "\n")
      event.stopPropagation()

  getMessageBox().keydown(sendMessage)


  console.log("finished")
