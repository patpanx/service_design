class Position < ActiveRecord::Base
  attr_accessible :accuracy, :altitude, :altitude_accuracy, :lat, :long, :timestamp, :user_id
  
  
  belongs_to :user
end
