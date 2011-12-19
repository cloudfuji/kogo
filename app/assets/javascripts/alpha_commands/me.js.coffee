$ ->
  console.log("Loading me")

  me = (params, raw, message) ->
    console.log("******************************************************************************************")
    console.log(params)
    console.log(raw)
    console.log(message)
    i = $(document).data('me')
    console.log(i)
    name = message['user']
    console.log(name)
    console.log("******************************************************************************************")
    action = raw.split(" ").slice(1).join(" ")
    $("<div><strong>*** #{ name } #{ action } ***</strong></div>")

  window.kogo.commands.register('me', /^\/me /, me)

  console.log("finished")
