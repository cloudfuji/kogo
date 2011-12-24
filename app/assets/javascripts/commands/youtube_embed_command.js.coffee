youtubeEmbedCommand =
  options:
    youtubeEmbedPattern: /^http(s)?:\/\/www.youtube.com\/watch/i
    youtubeIdPattern: /\Wv=([\w|\-]*)/
    youtubeTemplate: $.template('youtubeTemplate', '<div class="youtube-preview"><a target="_blank" class="youtube-preview-link" href="${ youtubeVideoUrl }"><img class="youtube-preview-image" src="${ youtubeImageUrl }" /></a></div>')

  currentUser: ->
    $(document).data('me')

  defaultTemplate: (message, $content) ->
    me       = ''
    me       = 'me' if message.user == @currentUser()

    $holder  = $.tmpl('messageHolderTemplate',  { message: message, me: me })
    $meta    = $.tmpl('messageMetaTemplate',    { message: message         })

    $holder.append($meta).append($content)

  youtubeEmbed: (message) ->
    id = message.content.match(@options.youtubeIdPattern)[1]
    youtubeImageUrl = "http://img.youtube.com/vi/#{ id }/0.jpg"
    $content = $.tmpl('youtubeTemplate', { youtubeVideoUrl: message.content, youtubeImageUrl: youtubeImageUrl })
    @defaultTemplate(message, $content)

  _init: ->
    $('.chat_history:first').chat_history('registerCommand', { priority: 15, name: 'youtubeEmbed', pattern: @options.youtubeEmbedPattern, process: $.proxy(@youtubeEmbed, this) })

$(document).bind('kogo.loaded', $.proxy(youtubeEmbedCommand._init, youtubeEmbedCommand))
