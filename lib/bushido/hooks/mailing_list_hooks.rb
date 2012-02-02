class BushidoMailingListHooks < Bushido::EventObserver
  def mailing_list_user_subscribed
    data = params['data']
    email = data['email']

    message = "New mailing list sign up: #{email}"

    Channel.announce(message)
  end
end
