class User < ActiveRecord::Base
  has_many :messages
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :bushido_authenticatable, :trackable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation, :remember_me

  def self.kogo
    User.find(1)
  end

  def name
    return "#{self.first_name} #{self.last_name}" if self.first_name and self.last_name
    return self.email.split("@").first
  end

  def bushido_extra_attributes(extra_attributes)
    self.first_name = extra_attributes["first_name"].to_s
    self.last_name  = extra_attributes["last_name"].to_s
    self.email      = extra_attributes["email"]
  end
end
