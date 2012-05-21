class Session < ActiveRecord::Base
  attr_accessible :forwarding_time, :owner_id, :timeout
  
  belongs_to :owner, :class_name => "User"
  has_many :message
end
