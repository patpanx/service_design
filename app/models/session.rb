class Session < ActiveRecord::Base
  attr_accessible :forwarding_time, :owner_id, :timeout
  
  belongs_to :user, :foreign_key => "owner_id"
end
