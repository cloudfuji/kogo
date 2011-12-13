(($, undefined_) ->

  widget_obj =
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

    _init: ->
      return true

    destory: ->
      $.widget::apply this, arguments

    formToData: () ->
      data = {}
      data['message'] = {}
      data['message']['channel_id'] = @element.data('$message_channel_id').val()
      data['message']['content'] = @element.data('$message_content').val()
      data

    sendMessage: (event) ->
      self = this
      console.log("sending message");
      if event.which == 13
        console.log("omg submit")
        data = self.formToData()
        target = "/channels/#{ channelId() }/messages.json"
        $.post(target, data)
        getMessageBox().val("")
        getMessageBox().focus()
        event.preventDefault
        event.stopPropagation

  $.widget "kogo.chatbox", widget_obj

) jQuery
