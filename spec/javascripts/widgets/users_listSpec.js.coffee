describe "users_list", ->

  beforeEach ->
    loadFixtures('user_list.html');
    $('#user_list').users_list()

  it "has a default intervalTime", ->
    expect($('#user_list').data('users_list')).toBeDefined()
