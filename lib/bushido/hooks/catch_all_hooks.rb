class BushidoCatchAllHooks < Bushido::EventObserver
  # The catch_all event should only be defined in a single observer,
  # and is called after checking all observers to see if they first
  # respond to the named event. Therefore, this is the last methods
  # that will be called for an unrecognized event.
  def catch_all
    Channel.announce(params['data']['human']) unless params['data']['human'].nil?
  end
end
