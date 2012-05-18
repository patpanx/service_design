class ApplicationController < ActionController::Base
  #check if user is logged in <- this is executed every time a controller is active
  
  before_filter :check_login
  protect_from_forgery
  
  
  #nunaccessible from outside the controllers
  protected
  
 #chek_login method
   def check_login
     #save User in session to actual_user
     @actual_user = User.find_by_id( session[:logged_user_id])
     #if actual_user is blank redirect to login_page
     if @actual_user.blank?
       redirect_to access_login_path, :notice => 'please login'
     end
   end
   
   def is_mobile?
     
     
   end
   
   
end
