class Message < ActiveRecord::Base
  attr_accessible :location_id, :media, :owner_id, :receiver_id, :session_id, :text, :timestamp, :status
  
  has_attached_file :media, :styles => { :small => "300x300>" },
                  :url  => "/assets/messages/:id/:style/:basename.:extension",
                  :path => ":rails_root/public/assets/messages/:id/:style/:basename.:extension"

  validates_attachment_size :media, :less_than => 5.megabytes
  validates_attachment_content_type :media, :content_type => ['image/jpeg', 'image/png']

  belongs_to :session
end
