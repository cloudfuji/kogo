attachments_list =
  options:
    intervalTime       : 60000
    attachments        : []
    $titleBar          : $('#file_list_title')
    attachmentTemplate : $.template('attachmentTemplate', '<li id="attachments_${attachment.id}" class="attachments_list_attachment"><span class="attachment-control"></span><a target="_blank" href="${attachment.url}">${attachment.file_file_name}</a></li>')

  _create: ->
    attachmentUpdateInterval = setInterval($.proxy(@retrieveAttachmentsFromServer, this), @options.intervalTime)
    @retrieveAttachmentsFromServer()

  attachmentCount: (channel) ->
    Object.keys(channel['attachments']).length

  channelId: ->
    $(document).data('channelId')

  retrieveAttachmentsFromServer: ->
    attachmentListUrl = "/channels/#{ @channelId() }/attachments.json"
    $.get(attachmentListUrl, $.proxy(@updateAttachments, this))

  updateAttachments:(attachments) ->
    for attachment in attachments
      @options.attachments.push(attachment.name)
    @updateDisplay(attachments)

  updateDisplay: (attachments) ->
    for attachment in attachments

      @addAttachmentToDisplay(attachment)
      @updateAttachmentControlStyle(attachment)

  handlePlayLinkClick: (event, url) ->
    $('.actions:first').audio('play', url)
    event.preventDefault()
    event.stopPropagation()
    return false

  addAttachmentToDisplay: (attachment) ->
    if !@isAttachmentDisplayed(attachment)
      _attachment                = {}
      _attachment.id             = attachment.id
      _attachment.name           = attachment.name
      _attachment.url            = attachment.url
      _attachment.file_file_name = attachment.file_file_name
      $content = $.tmpl(@options.attachmentTemplate, { attachment: _attachment })

      if attachment.url.match(/\.(mp3|mp4|m4a|mov|wav|aiff)/i)
        helper = (event) ->
          @handlePlayLinkClick(event, attachment.url)
        $control = $("<a 'audio-play' href='#'>[&gt;</a>")
        $control.click($.proxy(helper, this))
        $content.find('.attachment-control').append($control)

      $content.appendTo(@element)

  # TODO: this should add a 'play' button next to any music
  # attachments
  updateAttachmentControlStyle: (attachment) ->
    return true

  removeUserFromDisplay: (attachment_name) ->
    $("#attachment_#{attachment_name}").remove()

  attachmentsInDisplay: ->
    _attachments = []
    $('.attachments_list_attachment').each((index, element) ->
      _attachments.push(parseInt($(element).attr('id').split("attachments_")[1])))
    _attachments

  isAttachmentDisplayed: (attachment) ->
    @attachmentsInDisplay().indexOf(attachment.id) != -1

$.widget "kogo.attachments_list", attachments_list
