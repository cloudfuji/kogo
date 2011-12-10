class Channel < ActiveRecord::Base
  has_many :messages, :dependent => :destroy

  serialize :users, Hash

  def to_param
    name
  end

  def announce(message)
    self.messages.create(:content => message, :channel => self, :user => User.kogo)
  end

  def user_in_room?(user)
    not users[user.id].nil?
  end

  # None of this is multi-process safe with the serialization problems
  # of rails. Needs to be converted to a subtable for concurrent
  # processing
  def add_user(user)
    unless user_in_room?(user)
      users[user.id] = Time.now
      save

      announce("#{ user.name } has entered the channel")
    end
  end

  def remove_user(user)
    if user_in_room?(user)
      users.delete(user.id)
      save

      announce("#{ user.name } has left the channel")
    end
  end

  def touch_user(user)
    add_user(user) unless user_in_room?(user)
    users[user.id] = Time.now
    save
  end

  def update_users!
    users.keys.each do |user_id|
      remove_user(User.find(user_id)) if (users[user_id] < 2.minutes.ago)
    end
  end
end
