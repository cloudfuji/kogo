$ ->
  console.log("Loading image_embed")

  image_pattern = /\.(jpg|jpeg|gif|png)/

  imageEmbed = (params, raw) ->
    console.log("embedding an image:")
    $("<div><img class = 'image-embed' src='#{raw}' /></div>")

  window.kogo.commands.register('image', image_pattern, imageEmbed)

  console.log("finished")
