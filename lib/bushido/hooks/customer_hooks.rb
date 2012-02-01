class BushidoCustomerHooks < Bushido::EventObserver
  def customer_signed_up
    data = params['data']
    email = data['email']
    name = "#{data['first_name']} #{data['last_name']}"

    message = "New customer signed up! #{email}"
    message += name unless name.blank?

    Channel.announce(message)
  end
end
