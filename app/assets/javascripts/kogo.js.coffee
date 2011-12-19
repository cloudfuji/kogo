$ ->
  $('.chatbox:first').chatbox();
  $('.actions:first').audio();
  $('.users_list:first').users_list()
  $('.rooms_list:first').channels_list()
  $('.files_list:first').attachments_list()
  $('.file_upload_holder:first').file_upload()
  $('.chat_history:first').chat_history()
  $('#search_form').search()
  $('#search_form input:first').autobox()

  $(document).trigger("kogo.loaded")
