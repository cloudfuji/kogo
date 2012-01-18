pasteCommand =
  options:
    pastePattern: /\n.*\n/i
    pasteTemplate: $.template('pasteTemplate', '<pre class="pastie"><a target="_blank" class="pastie-link" href="${ messagePath }">View pastie</a><br/>${ preview }</code></pre>')
    maxPreviewLength: 300
    maxPreviewLines:  4

  channelId: ->
    $(document).data('channelId')

  currentUser: ->
    $(document).data('me')

  defaultTemplate: (message, $content) ->
    me       = ''
    me       = 'me' if message.user == @currentUser()

    $holder  = $.tmpl('messageHolderTemplate',  { message: message, me: me })
    $meta    = $.tmpl('messageMetaTemplate',    { message: message         })

    $holder.append($meta).append($content)

  preview: (content) ->
    truncated_content = content.split("\n")[0..@options.maxPreviewLines].join("\n")
    truncated_content = truncated_content.substring(0, @options.maxPreviewLength).concat "..." if truncated_content.length > @options.maxPreviewLength

  pasteEmbed: (message) ->
    console.log message
    messagePath = "/channels/#{ @channelId() }/messages/#{ message.id }"
    # preview = message.content
    $content = $.tmpl('pasteTemplate', { messagePath: messagePath, preview: @preview(message.content) })
    @defaultTemplate(message, $content)

  _init: ->
    $('.chat_history:first').chat_history('registerCommand', { priority: 15, name: 'pasteEmbed', pattern: @options.pastePattern, process: $.proxy(@pasteEmbed, this) })

$(document).bind('kogo.loaded', $.proxy(pasteCommand._init, pasteCommand))
