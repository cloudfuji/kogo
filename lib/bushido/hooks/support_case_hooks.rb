class BushidoSupportCaseHooks < Bushido::EventObserver
  # Schema:
  # event[:category] = :support_case
  # event[:name]     = :opened
  # event[:data]     = {
  #   :author => {
  #     :email      => params[:email],
  #     :first_name => user.first_name,
  #     :last_name  => user.last_name
  #   },
  #   :title  => params[:message],
  #   :body   => params[:message],
  #   :source => params[:source]
  # }

  def support_case_opened
    data   = params['data']
    email  = data['email']
    name   = " (#{data['first_name']} #{data['last_name']})" unless data['first_name'].blank?
    name ||= ""
    title  = data['title']
    source = data['source']

    message = "New support case opened: #{email}"
    message += name
    message += " [via #{source}]"
    message += " says, '#{title}'"

    Channel.announce(message)
  end
end
