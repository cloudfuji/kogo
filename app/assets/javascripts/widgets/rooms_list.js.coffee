channels_list =
  options:
    intervalTime    : 15000
    channels        : []
    $titleBar       : $('users_title')
    channelTemplate : $.template('channelTemplate', '<div id="channels_${channel.name}" class="channels_list_channel ${selected}"><a href="/channels/${channel.name}">${channel.name} (<span id="channel_${channel.name}_user_count">${channel.user_count}</span>)</a></div>')

  _create: ->
    userUpdateInterval = setInterval($.proxy(@retrieveChannelsFromServer, this), @options.intervalTime)
    @retrieveChannelsFromServer()

  userCount: (channel) ->
    Object.keys(channel['users']).length

  channelId: ->
    $(document).data('channelId')

  retrieveChannelsFromServer: ->
    channelListUrl = "/channels.json"
    $.get(channelListUrl, $.proxy(@updateChannels, this))

  updateChannels:(channels) ->
    for channel in channels
      @options.channels.push(channel.name)
    @updateDisplay(channels)

  updateDisplay: (channels)->
    for channel in channels
      @addChannelToDisplay(channel)
      @updateChannelUserCount(channel)

    # Now remove users that are displayed but are not in this list. Is
    # it in the displayedList but not the updated userlist from the
    # last server call? If so, remove it from the display
    for displayedName in @channelsInDisplay()
      index = channels.indexOf(displayedName)
      @removeChannelFromDisplay(displayedName) if index != -1

  addChannelToDisplay: (channel) ->
    if !@isChannelDisplayed(channel)
      _channel = {}
      _channel.name = channel.name
      # Object.keys() isn't supported on IE (or any non ES5-js env)
      _channel.user_count = @userCount(channel)
      $.tmpl(@options.channelTemplate, { channel: _channel }).data('name', channel.name).appendTo(@element)

  updateChannelUserCount: (channel) ->
    if @isChannelDisplayed(channel)
      $("#channel_#{ channel.name }_user_count").text(@userCount(channel))

  removeUserFromDisplay: (channel_name) ->
    $("#channel_#{channel_name}").remove()

  channelsInDisplay: ->
    _channels = []
    $('.channels_list_channel').each((index, element) ->
      _channels.push($(element).attr('id').split("channels_")[1]))
    _channels

  isChannelDisplayed: (channel) ->
    @channelsInDisplay().indexOf(channel.name) != -1

$.widget "kogo.channels_list", channels_list
