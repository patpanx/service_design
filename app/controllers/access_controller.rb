class AccessController < ApplicationController
  #before_filter exeption - because you have to see the login page even without be logged in
  skip_before_filter :check_login, :only => [:login]
  
  def login
    unless request.post?
      
      @user = User.new
      respond_to do |format|
        format.html
      end
    else
      #check if user exits in db
      @user = User.find_by_email_and_password(
          params[ '/access/login' ][ :email ],
          params[ '/access/login' ][ :password ] )
          
          #debuging
          logger.debug "-- @user:#{@user}"
          
          #if user is not blank save user.id in session an redirect to user-settings
          unless @user.blank?
            session[ :logged_user_id ] = @user.id
          redirect_to @user
          
          else
            logger.debug "-- params['/access/login'][ :email]:#{params[ '/access/login' ][ :email ]}"
            if params[ '/access/login' ][ :email ].blank? && params[ '/access/login' ][ :password ].blank?
            @user = User.new()
            @user.save
            session[ :logged_user_id ] = @user.id
            redirect_to @user 
            else
              redirect_to access_login_path
            end
      end
    end
  end

  def logout
    #save nil to session id - clear sesion_id
    session[ :logged_user_id] = nil
    redirect_to access_login_path
  end
end