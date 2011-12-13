# Mail routes
::Bushido::Mailroute.map do |m|

  m.route("mail.simple") do
    m.subject("hello")
  end

end

Channel.all.each(&:instantiate_mail_route!)
