class User < ActiveRecord::Base
  attr_accessible :email, :name, :password_digest, :admin
  
  
  has_many :messages
  has_many :sessions
  
  
  def is_admin?
    return(admin)
  end
  
end
