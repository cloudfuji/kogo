# $(document).ready() equivalent
$ ->
  console.log("Loading commands lib")


  # NOTES To add an action, add a key and a value to the below window.commands object.
  # The value should be a regular expression
  # Then define a window.perform_example method on the window object
  # where "example" is the name of the key listed in the commands object

  capitalize = (string) ->
    string.charAt(0).toUpperCase() + string.slice(1)

  # Where we store the commands
  window.kogo.commands ?= {}

  # Default command listing
  window.kogo.commands.list = {}

  window.kogo.commands.register = (command, pattern, fn) ->
    window.kogo.commands.list[command] = [pattern, fn]

  # Adds sets the interval for the updateChannel() function It's being
  # set to the window object so that code on any other part of the
  # page can use that to stop updating the channel Useful for testing
  # it out during development
  console.log(window.kogo.commands)
  console.log "Finished!"
