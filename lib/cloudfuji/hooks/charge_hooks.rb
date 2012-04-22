class CloudfujiChargeHooks < Cloudfuji::EventObserver
  def charge_succeeded
    # The catch-all even will take care of outputting the human
    # readable form of this, we just play the gong sound here
    Channel.announce("/play gong")
    Channel.announce(params['data']['human']) unless params['data']['human'].nil?
  end
end
