class Message < ActiveRecord::Base
  attr_accessible :location_id, :media, :owner_id, :receiver_id, :session_id, :text, :timestamp, :status
  
  belongs_to :session
end
