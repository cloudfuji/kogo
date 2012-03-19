class BushidoBuildHooks < Bushido::EventObserver
  def build_success
    Channel.announce("/play perfect")
    Channel.announce(params['data']['human']) unless params['data']['human'].nil?
  end
end
