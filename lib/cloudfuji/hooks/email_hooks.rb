class CloudfujiEmailHooks < Cloudfuji::EventObserver
  def mail_simple
    puts "YAY!"
    puts params.inspect
  end

  def mail_new_message
    channel = Channel.find_by_name(params['channel_name'])
    user    = User.find_by_email(params['from_email'])
    user  ||= User.find_by_email(params['mail']['sender'])

    puts params.inspect
    
    if user
      if params['attachments'] and !params['attachments'].empty?
        params['attachments'].each do |email_attachment|
          attachment = Attachment.new
          attachment.user = user
          attachment.file = email_attachment
          attachment.channel = channel
          attachment.save
        end
      else
        message = channel.messages.new
        message.content = params['mail']['stripped-text']
        message.user = user
        message.save

        puts message.save
      end
    else
      # TODO: Send an email to the email explaining they aren't
      # authorized to mail this app/channel
    end

    return :halt
  end

  private
end
