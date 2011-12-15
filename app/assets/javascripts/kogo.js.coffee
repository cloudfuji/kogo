$ ->
  $('.chatbox:first').chatbox();
  $('audio').audio();
  window.userList = $('.users_list:first').users_list()
  window.channelList = $('.rooms_list:first').channels_list()
  window.attachmentList = $('.files_list:first').attachments_list()
  window.fileUpload = $('.file_upload_holder:first').file_upload()
  window.chatHistory = $('.chat_history:first').chat_history()
