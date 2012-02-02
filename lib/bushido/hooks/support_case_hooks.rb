class BushidoSupportCaseHooks < Bushido::EventObserver
  # Schema:
  # {
  # :category => :support_case,
  # :name     => :opened,
  # :data     => {
  #   :author => {
  #     :email      => String,
  #     :first_name => String,
  #     :last_name  => String,
  #   },
  #   :title  => String,
  #   :body   => String,
  #   :source => String
  # }

  def support_case_opened
    data   = params['data']
    author = data['author']
    email  = author['email']
    name   = " (#{author['first_name']} #{author['last_name']})" unless author.nil? || author['first_name'].blank?
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
