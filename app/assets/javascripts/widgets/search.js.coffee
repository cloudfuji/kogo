search =
  options:
    minimumSearchLength: 3
    displayed: false

  chatBox: ->
    $('#message_content')

  _handleLinkBehavior: (event) ->
    @toggleSearchDisplay()
    event.preventDefault()
    event.stopPropagation()

  _init: ->
    $input = @element.find('.search_term:first')
    $input.keypress $.proxy(@launchSearch, this)

  searchQueryUrl: (query) ->
    "/channels/#{ @$(document).data('channelId')() }/search?query=#{ query }"

  launchSearch: (event) ->
    $input = @element.find('.search_term:first')
    if event.which == 13
      event.preventDefault()
      event.stopPropagation()
      query = $input.val()
      $input.val("")
      window.open(@searchQueryUrl(query))

$.widget "kogo.search", search
