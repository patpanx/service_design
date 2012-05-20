class ApplicationController < ActionController::Base
  #check if user is logged in <- this is executed every time a controller is active
  before_filter :check_mobile
  before_filter :check_login
  
  protect_from_forgery
  
  
  #nunaccessible from outside the controllers
  privat
  
 #chek_login method
  def check_login
    #save User in session to actual_user
    @actual_user = User.find_by_id( session[:logged_user_id])
    #if actual_user is blank redirect to login_page
    if @actual_user.blank?
      redirect_to access_login_path, :notice => 'please login'
    end
  end
   
  def user_signed_in?
    actual_user.present?
  end
  helper_method :user_signed_in? 
   
   
   def is_mobile?
     if session[ :is_mobile]
        return ( session[ :is_mobile ].to_i == 1 )
      else
        return ( request.user_agent.downcase =~ /iphone|android|mobile/ )
      end
   end
   helper_method :is_mobile
   
   def check_mobile
      session[ :is_mobile ] = params[ :mobile ] if params[ :mobile ]
      request.format = :mobile if is_mobile?
      logger.debug "---- user agent: #{request.user_agent}"
   end
   
end
