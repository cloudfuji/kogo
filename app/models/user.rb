class User < ActiveRecord::Base
  has_many :messages
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :bushido_authenticatable, :trackable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  def bushido_extra_attributes(extra_attributes)
    self.name = extra_attributes["first_name"].to_s + " " + extra_attributes["last_name"].to_s
    self.name = extra_attributes["email"].split("@").first if self.name.length == 1
  end
end
