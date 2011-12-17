imageEmbedCommand =
  options:
    imageEmbedPattern: /^http.*\.(jpg|jpeg|gif|png)/i
    imageTemplate: $.template('imageTemplate', '<div><a target="_blank" href="${ imageUrl }"><img class="image-embed" src="${ imageUrl }" /></a></div>')

  currentUser: ->
    $(document).data('me')

  defaultTemplate: (message, $content) ->
    me       = ''
    me       = 'me' if message.user == @currentUser()

    $holder  = $.tmpl('messageHolderTemplate',  { message: message, me: me })
    $meta    = $.tmpl('messageMetaTemplate',    { message: message         })

    $holder.append($meta).append($content)

  imageEmbed: (message) ->
    $content = $.tmpl('imageTemplate', { imageUrl: message.content })
    @defaultTemplate(message, $content)

  _init: ->
    $('.chat_history:first').chat_history('registerCommand', { priority: 15, name: 'imageEmbed', pattern: @options.imageEmbedPattern, process: $.proxy(@imageEmbed, this) })

$(document).bind('kogo.loaded', $.proxy(imageEmbedCommand._init, imageEmbedCommand))
