# Mail routes
::Cloudfuji::Mailroute.map do |m|

  m.route("mail.simple") do
    m.subject("hello")
  end

end

if Channel.table_exists?
  Channel.all.each(&:instantiate_mail_route!)
end
