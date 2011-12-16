search =
  options:
    searchFormTemplate: $.template('searchFormTemplate', '<form class="search_form"><input class="search_term" name="search_term" type="text"></form>')
    widgetIconTemplate: $.template('widgetIconTemplate', '<a id="search_term_display" href="#">Search</a>')
    minimumSearchLength: 3
    displayed: false

  searchField: ->
    @searchForm().children('.search_term:first')

  searchForm: ->
    @element.children('.search_form:first')

  channelId: ->
    $(document).data('channelId')

  chatBox: ->
    $('#message_content')

  _handleLinkBehavior: (event) ->
    @toggleSearchDisplay()
    event.preventDefault()
    event.stopPropagation()

  _init: ->
    $icon = $.tmpl('widgetIconTemplate')
    $icon.bind('click', $.proxy(@_handleLinkBehavior, this))
    $search = $.tmpl('searchFormTemplate')
    $search.children('.search_term:first').hide()

    $icon.appendTo(@element)
    $search.appendTo(@element)

    $search.children('.search_term:first').keypress $.proxy(@launchSearch, this)
    $search.children('.search_term:first').blur $.proxy(@hideSearchDisplay, this)

  searchQueryUrl: (query) ->
    "/channels/#{ @channelId() }/search?query=#{ query }"

  launchSearch: (event) ->
    if event.which == 13
      event.preventDefault()
      event.stopPropagation()
      @hideSearchDisplay()
      query = @searchField().val()
      @searchField().val("")
      @chatBox().focus()
      window.open(@searchQueryUrl(query))

  toggleSearchDisplay: ->
    if @searchField().is(":visible")
      @hideSearchDisplay()
      @chatBox().focus()
    else
      @showSearchDisplay()

  hideSearchDisplay: ->
    @searchField().hide()

  showSearchDisplay: ->
    @searchField().show()
    @searchField().focus()


$.widget "kogo.search", search
