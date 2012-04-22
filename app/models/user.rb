class User < ActiveRecord::Base
  has_many :messages

  # Setup common, nice things to have on Cloudfuji, like User#notify.
  include Cloudfuji::UserHelper

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :cloudfuji_authenticatable, :trackable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :ido_id, :first_name, :last_name, :email, :password, :password_confirmation, :remember_me

  def self.kogo
    User.find(1)
  end

  def name
    return "#{self.first_name} #{self.last_name}" if self.first_name and self.last_name
    return self.email.split("@").first
  end

  def cloudfuji_extra_attributes(extra_attributes)
    self.first_name = extra_attributes["first_name"].to_s
    self.last_name  = extra_attributes["last_name"].to_s
    self.email      = extra_attributes["email"]
  end
end
