class BushidoBuildHooks < Bushido::EventObserver
  def build_success
    Channel.announce("/play perfect")
  end
end
