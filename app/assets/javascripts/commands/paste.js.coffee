$ ->
  console.log("Loading pastie")

  pastie_pattern = /\n.*\n/

  pastieEmbed = (params, raw, message) ->
    channel_id = $.data(document, 'channelId')
    message_path = "/channels/#{channel_id}/messages/#{message['id']}"
    $("<pre class=\"pastie\"><a target=\"_blank\" class=\"pastie-link\" href=\"#{message_path}\">View pastie</a><br/>#{ raw }</code></pre>")

  window.kogo.commands.register('pastie', pastie_pattern, pastieEmbed)

  console.log("finished")