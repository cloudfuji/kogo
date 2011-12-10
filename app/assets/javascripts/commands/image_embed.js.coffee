$ ->
  console.log("Loading image_embed")

  image_pattern = /\.(jpg|gif|png|)/

  imageEmbed = (params, raw) ->
    $("<img src='#{raw}' />")

  window.kogo.commands.register('image', image_pattern, imageEmbed)

  console.log("finished")
