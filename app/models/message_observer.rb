class MessageObserver < ActiveRecord::Observer
  observe :message

  def after_create(message)
    if message.content.downcase.include?("@all")
      message.channel.users.keys.collect do |user_id|
        User.find(id).notify(message.channel.name, "#{message.user.name}: #{message.content}", "chat")
      end
    else
      User.all.each do |user|
        if !user.name.blank? && message.content.downcase.include?(user.name.downcase) 
          print "Includes user name #{user.name}"
          if message.user_id != user.id # Don't notify the user if they typed their own name
            puts "Sending notification"
            user.notify(message.channel.name, "#{message.user.name}: #{message.content}", "chat")
          end
        end
      end
    end
  end
end
