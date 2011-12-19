require 'paperclip'

class Attachment < ActiveRecord::Base
  belongs_to :channel
  belongs_to :user
  belongs_to :message

  has_attached_file :file,
                    :storage        => :s3,
                    :s3_credentials => "config/s3.yml",
                    :url            => "/:attachment/:id/:style/:basename.:extension",
                    :path           => "#{ENV['S3_PREFIX']}/:attachment/:id/:style/:basename.:extension"

  attr_accessible :file

  def url
    file.to_s
  end
end
