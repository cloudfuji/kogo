$ ->
  console.log("Loading me")

  me = (params, raw) ->
    name = $.data(document, 'me')
    action = raw.split(" ").slice(1).join(" ")
    $("<div><strong>*** #{ name } #{ action } ***</strong></div>")

  window.kogo.commands.register('me', /^\/me /, me)

  console.log("finished")
