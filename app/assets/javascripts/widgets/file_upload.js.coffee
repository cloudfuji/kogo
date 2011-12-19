templateString = '''
<form accept-charset="UTF-8" action="/channels/${channelId}/attachments.js" data-remote="true" html="{:multipart=&gt;true}" id="file_upload" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="✓">
  <input name="${csrfParam}" type="hidden" value="${csrfToken}"></div>
  <input id="channel_id_${channelId}" name="channel_id[${channelId}]" type="hidden">
  <input id="file" name="file" type="file">
  <input name="commit" type="submit" value="Upload">
</form>
'''

file_upload =
  options:
    fileUploadTemplate : $.template('attachmentTemplate',  templateString)

  channelId: ->
    $(document).data('channelId')

  csrfParam: ->
    $('meta[name=csrf-param]').attr('content')

  csrfToken: ->
    $('meta[name=csrf-token]').attr('content')

  _create: ->
    $.tmpl(@options.fileUploadTemplate, { channelId: @channelId(), csrfParam: @csrfParam(), csrfToken: @csrfToken() }).appendTo(@element)

$.widget "kogo.file_upload", file_upload
