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
    puts params.inspect

    data   = params['data']
    author = data['author']
    email  = author['email']
    name   = " (#{author['first_name']} #{author['last_name']})" unless author.nil? || author['first_name'].blank?
    name ||= ""

    puts data.inspect
    puts "Author: #{author.inspect} (nil? #{author.nil?})"
    puts "\tauthor['first_name']: #{author['first_name']} (blank? #{author['first_name'].blank?})"
    puts "\tname: #{name}"

    title  = data['title']
    source = data['source']

    puts "title: #{title}"
    puts "source: #{source}"

    message = "New support case opened: #{email}"
    message += name
    message += " [via #{source}]"
    message += " says, '#{title}'"
    message += ". See more at #{data['url']}" unless data['url'].nil?

    puts "message: #{message}"

    Channel.announce(message)
  end
end
