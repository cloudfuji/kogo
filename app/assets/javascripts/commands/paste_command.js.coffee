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

    $holder  = $.tmpl('messageHolderTemplate', { message: message, me: me })
    $meta    = $.tmpl('messageMetaTemplate'  , { message: message         })
    $author  = $.tmpl('messageAuthorTemplate', { message: message         })
    $time    = $.tmpl('messageTimeTemplate'  , { message: message         })

    $holder.append($meta.append($author).append($time)).append($content)

  preview: (content) ->
    truncated_content = content

    if truncated_content.length > @options.maxPreviewLength
      truncated_content = truncated_content.substring(0, @options.maxPreviewLength)

    if truncated_content.split("\n").length > @options.maxPreviewLines
      truncated_content = truncated_content.split("\n").slice(0, @options.maxPreviewLines).join("\n")

    truncated_content = "#{truncated_content}..." if truncated_content.length != content.length
    return truncated_content


  messagePath: (message)->
    "/channels/#{ @channelId() }/messages/#{ message.id }"


  pasteEmbed: (message) ->
    $content = $.tmpl('pasteTemplate', { messagePath: @messagePath(message), preview: @preview(message.content) })
    @defaultTemplate(message, $content)


  afterSave: (message, $element)->
    $($element).find(".pastie-link").attr('href', @messagePath(message))


  _init: ->
    $('.chat_history:first').chat_history('registerCommand', { priority: 15, name: 'pasteEmbed', pattern: @options.pastePattern, process: $.proxy(@pasteEmbed, this), afterSave: $.proxy(@afterSave, this) })


$(document).bind('kogo.loaded', $.proxy(pasteCommand._init, pasteCommand))
