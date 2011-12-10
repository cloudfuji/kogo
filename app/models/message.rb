require 'cgi'

class Message < ActiveRecord::Base
  belongs_to :channel
  belongs_to :user

  validates_presence_of :content

  def escaped_content
    CGI.escape_html(content)
  end
end
