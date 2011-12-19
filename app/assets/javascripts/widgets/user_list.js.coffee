users_list =
  options:
    intervalTime: 15000
    users: []
    $titleBar: $('users_title')
    userTemplate: $.template('userTemplate', "<div class='users_list_user' id='user_${id}'>${name}</div>")

  _create: ->
    userUpdateInterval = setInterval($.proxy(@retrieveUsersFromServer, this), @options.intervalTime)
    @retrieveUsersFromServer()

  channelId: ->
    $(document).data('channelId')

  retrieveUsersFromServer: ->
    channelUrl = "/channels/#{ @channelId() }.json"
    $.get(channelUrl, $.proxy(@updateUsers, this))

  updateUsers:(channel) ->
    users = []
    for user_id, time of channel['users']
      @options.users.push(parseInt(user_id))
    @updateDisplay(channel['users'])

  updateDisplay: (users)->
    for userId of users
      user               = {}
      user.id            = parseInt(userId)
      user.lastHeartBeat = users[userId][0]
      user.name          = users[userId][1]
      @addUserToDisplay(user)

    # Now remove users that are displayed but are not in this list. Is
    # it in the displayedList but not the updated userlist from the
    # last server call? If so, remove it from the display
    for displayedId in @usersInDisplay()
      index = users[displayedId]
      @removeUserFromDisplay(displayedId) if index == undefined

  addUserToDisplay: (user) ->
    if !@isUserDisplayed(user)
      $.tmpl(@options.userTemplate, { id: user.id, name: user.name }).data('name', user.name).data('user_id', user.id).appendTo(@element)

  removeUserFromDisplay: (user_id) ->
    $("#user_#{user_id}").remove()

  usersInDisplay: ->
    _users = []
    $('.users_list_user').each((index, element) ->
      _users.push(parseInt($(element).attr('id').split("_").slice(1))))
    _users

  isUserDisplayed: (user) ->
    @usersInDisplay().indexOf(user.id) != -1

$.widget "kogo.users_list", users_list
