class BushidoChargeHooks < Bushido::EventObserver
  def charge_succeeded
    # The catch-all even will take care of outputting the human
    # readable form of this, we just play the gong sound here
    Channel.announce("/play gong")
  end
end
