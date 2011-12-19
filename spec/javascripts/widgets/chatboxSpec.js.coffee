describe "chatbox", ->

  beforeEach ->
    loadFixtures('chatbox.html');
    $('#chatbox').chatbox()
    expect($('#chatbox')).toExist()
    expect(chatbox).toBeDefined()

  it "should render", ->
    expect($('#chatbox').data('chatbox')).toBeDefined()

  it "has a message input in the data cache", ->
    expect($('#chatbox').data('$message_content')).toBeDefined

  it "has a channel_id input in the data cache", ->
    expect($('#chatbox').data('$message_channel_id')).toBeDefined

  it "should collect the form data", ->
    data = $('#chatbox').data('chatbox').formToData()
    expect(data['message']['channel_id']).toEqual($('#message_channel_id').val())
    expect(data['message']['content']).toEqual($('#message_content').val())

  it "sends messages when user press enter on the input", ->
    event = jQuery.Event('keypress')
    event.which = 13
    event.keycode = 13
    event.key = 13

    spyOn($, 'post')
    spyOn($('#message_content'), 'keypress')
    $('#message_content').trigger(event)
    expect($.post).toHaveBeenCalled()
