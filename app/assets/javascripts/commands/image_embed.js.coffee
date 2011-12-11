$ ->
  console.log("Loading image_embed")

  image_pattern = /\.(jpg|jpeg|gif|png)/i

  imageEmbed = (params, raw) ->
    console.log("embedding an image:")
    $("<div><a href='#{ raw }' ><img class = 'image-embed' src='#{ raw }' /></a></div>")

  window.kogo.commands.register('image', image_pattern, imageEmbed)

  console.log("finished")
