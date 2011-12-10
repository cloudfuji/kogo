class Channel < ActiveRecord::Base
  has_many :messages, :dependent => :destroy

  def to_param
    name
  end
end
