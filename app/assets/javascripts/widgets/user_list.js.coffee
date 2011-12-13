user_list =
  options: {
    intervalTime: 30000
  }

  _create: ->
    userUpdateInterval = setInterval(@retriveUsers, @options.intervalTime)
    @retriveUsers()

  retrieveUsers: ->
    channelUrl = "/channels/#{ channelId() }.json"
    $.get(channelUrl, updateUsers)

  updateUsers:(channel) ->
    users = []
    for user_id, time of channel['users']
      users.push(parseInt(user_id))

$.widget "kogo.user_list", user_list
