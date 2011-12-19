search =
  options:
    minimumSearchLength: 3
    displayed: false

  _init: ->
    $input = @element.find('.search_term:first')
    $input.keypress $.proxy(@launchSearch, this)

  channelId: ->
    $(document).data('channelId')

  searchQueryUrl: (query) ->
    "/channels/#{ @channelId() }/search?query=#{ query }"

  launchSearch: (event) ->
    $input = @element.find('.search_term:first')
    if event.which == 13
      event.preventDefault()
      event.stopPropagation()
      query = $input.val()
      $input.val("")
      window.open(@searchQueryUrl(query))

$.widget "kogo.search", search
