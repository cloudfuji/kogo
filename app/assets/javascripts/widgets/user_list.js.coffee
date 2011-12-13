(($, undefined_) ->

  widget_obj =
    options: {
      intervalTime: 30000
    }

    _create: ->
      $ele = @element
      self = this

      window.userUpdateInterval = setInterval(self.retriveUsers, self.options.intervalTime)
      this.retriveUsers()

    _init: ->
      return

    destory: ->
      $.widget::apply this, arguments

    retrieveUsers: ->
      channelUrl = "/channels/#{ channelId() }.json"
      $.get(channelUrl, updateUsers)

    updateUsers:(channel) ->
      users = []
      for user_id, time of channel['users']
        users.push(parseInt(user_id))

  $.widget "kogo.user_list", widget_obj

) jQuery
