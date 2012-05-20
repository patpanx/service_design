class ApplicationController < ActionController::Base
  #check if user is logged in <- this is executed every time a controller is active
  before_filter :check_mobile

  protect_from_forgery

  #nunaccessible from outside the controllers
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
