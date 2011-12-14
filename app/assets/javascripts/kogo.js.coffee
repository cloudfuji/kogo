$ ->
  console.log("Chatbox: ", $('.chatbox:first'));
  $('.chatbox:first').chatbox();

  console.log("UsersList: ", $('.users_list:first'));
  window.userList = $('.users_list:first').users_list()
