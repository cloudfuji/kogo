linkCommand =
  options:
    linkPattern: /http/i
    linkTemplate: $.template('linkTemplate', '<div class="message-content">${ content }</div>')

  channelId: ->
    $(document).data('channelId')

  currentUser: ->
    $(document).data('me')

  defaultTemplate: (message, $content) ->
    me       = ''
    me       = 'me' if message.user == @currentUser()

    $holder  = $.tmpl('messageHolderTemplate', { message: message, me: me    })
    $meta    = $.tmpl('messageMetaTemplate'  , { message: message            })
    $author  = $.tmpl('messageAuthorTemplate', { message: message            })
    $time    = $.tmpl('messageTimeTemplate'  , { message: message            })

    $holder.append($meta.append($author).append($time)).append($content)

  linkEmbed: (message) ->
    content = message.content.replace(/(http\S*)/g, '<a target="_blank" href="$1">$1</a>')
    $content = $.tmpl('linkTemplate', { content: content })
    $content = $("<div class='message-content'>#{ content }</div>")
    @defaultTemplate(message, $content)

  _init: ->
    # Low priority since this should be the lat default before falling back
    $('.chat_history:first').chat_history('registerCommand', { priority: 5, name: 'linkEmbed', pattern: @options.linkPattern, process: $.proxy(@linkEmbed, this) })

$(document).bind('kogo.loaded', $.proxy(linkCommand._init, linkCommand))
