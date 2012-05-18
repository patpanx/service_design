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
      @user = User.find_by_email_and_password_digest(
          params[ '/access/login' ][ :email ],
          params[ '/access/login' ][ :password_digest ] )

      #debuging
      logger.debug "-- @user:#{@user}"
      logger.debug "-- params['/access/login'][ :email]:#{params[ '/access/login' ][ :email ]}"
              logger.debug "-- params['/access/login'][ :password_digest]:#{params[ '/access/login' ][ :password_digest ]}"

      #if user is not blank save user.id in session an redirect to user-settings
      unless @user.blank?
        session[ :logged_user_id ] = @user.id
        redirect_to @user

      else
        logger.debug "-- params['/access/login'][ :email]:#{params[ '/access/login' ][ :email ]}"
        # if email and password == blank, create a new empty user - anonym user
        if params[ '/access/login' ][ :email ].blank? && params[ '/access/login' ][ :password_digest ].blank?
          #check if its first user - gets admin rights
          
          if User.all.blank?
            @user = User.new(:admin => 1)
          else
            @user = User.new()
          end
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