$ ->
  console.log("Loading youtube_preview")

  youtube_base_video_url = "http://www.youtube.com/watch?v="
  youtube_base_image_url = "http://img.youtube.com/vi/"

  youtubePreview = (params, raw) ->
    id = raw.slice(youtube_base_video_url.length, raw.length)
    $("<div class='youtube-preview'><a target=\"_blank\" class='youtube-preview-link' href=\"#{ youtube_base_video_url }#{ id }\"><img class='youtube-preview-image' src='#{ youtube_base_image_url }#{ id }/0.jpg' /></a></div>")

  window.kogo.commands.register('youtube', /^http:\/\/www.youtube.com\/watch\?v=/, youtubePreview)

  console.log("finished")
