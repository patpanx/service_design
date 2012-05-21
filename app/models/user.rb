class User < ActiveRecord::Base
  attr_accessible :email, :name, :password_digest, :admin
  has_secure_password
  #validates :email, format: /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, uniqueness: true
   
  has_many :messages
  has_many :sessions, :foreign_key => 'owner_id'
  has_many :positions
  
end
