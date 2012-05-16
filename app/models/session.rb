class Session < ActiveRecord::Base
  attr_accessible :forwarding_time, :owner_id, :timeout
end
