imageEmbedCommand =
  options:
    imageEmbedPattern: /^http.*\.(jpg|jpeg|gif|png)/i
    imageTemplate: $.template('imageTemplate', '<div class="message-content"><a target="_blank" href="${ imageUrl }"><img class="image-embed" src="${ imageUrl }" height="200" width="200" /></a></div>')

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

  imageEmbed: (message) ->
    $content = $.tmpl('imageTemplate', { imageUrl: message.content })
    @defaultTemplate(message, $content)

  _init: ->
    $('.chat_history:first').chat_history('registerCommand', { priority: 15, name: 'imageEmbed', pattern: @options.imageEmbedPattern, process: $.proxy(@imageEmbed, this) })

$(document).bind('kogo.loaded', $.proxy(imageEmbedCommand._init, imageEmbedCommand))
