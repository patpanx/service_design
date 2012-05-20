class ApplicationController < ActionController::Base
  #check if user is logged in <- this is executed every time a controller is active
  #check if user_agent is a mobile device <- this is executed every time a controller is active
  before_filter :check_mobile

  #unaccessible from outside the controllers
  protect_from_forgery
  private

  #chek_login method
  def current_user
    if session[:logged_user_id]
      @current_user ||= User.find(session[:logged_user_id])
    end
  end

  def user_signed_in?
    current_user.present?
  end
  helper_method :user_signed_in?

  #user with admin-access
  def is_admin?
    return(current_user.admin)
  end
  helper_method :is_admin

  #check if user_agent is a mobile device
  def check_mobile
    session[ :is_mobile ] = params[ :mobile ] if params[ :mobile ]
    request.format = :mobile if is_mobile?
    logger.debug "---- user agent: #{request.user_agent}"
  end

  def is_mobile?
    if session[ :is_mobile]
      return ( session[ :is_mobile ].to_i == 1 )
    else
      return ( request.user_agent.downcase =~ /iphone|android|mobile/ )
    end
  end
  helper_method :is_mobile
  
end
