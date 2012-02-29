class MessageObserver < ActiveRecord::Observer
  observe :message

  def after_create(message)
    User.all.each do |user|
      if message.content.downcase.include?(user.name.downcase)
        print "Includes user name #{user.name}"
        if message.user_id != user.id # Don't notify the user if they typed their own name
          puts "Sending notification"
          user.notify(message.channel.name, "#{message.user.name}: #{message.content}", "chat")
        end
      end
    end
  end
end
