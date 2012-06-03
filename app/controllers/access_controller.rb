class AccessController < ApplicationController
  #before_filter exeption - because you have to see the login page even without be logged in
  skip_before_filter :require_login, :only => [:login]
  
  def login
    unless request.post?

      @user = User.new
      respond_to do |format|
        format.html #login.html.erb
        format.mobile do
          render :action => 'login', :formats => 'html', :layout => 'application.mobile.erb'
        end
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
        redirect_to passiv_all_sessions_path

      else
        logger.debug "-- params['/access/login'][ :email].blank?:#{params[ '/access/login' ][ :email ].blank?}"
        logger.debug "-- session:#{session}"
        # if email and password == blank, create a new empty user - anonym user
        if params[ '/access/login' ][ :email ].blank? && params[ '/access/login' ][ :password_digest ].blank?
          #check if its first user - gets admin rights

          if User.all.blank?
            @user = User.new(:admin => 1)
            logger.debug "-- @user.id:#{@user.admin}"
            logger.debug "-- @user.id:#{@user.id}"
          else
            @user = User.new()
            logger.debug "---- created a new User"
            logger.debug "-- @user.id:#{@user.id}"
          end
          logger.debug @user.save
          logger.debug "-- @user.id:#{@user.id}"
          session[ :logged_user_id ] = @user.id
          logger.debug "-- users_path(@user)#{users_path(@user)}"
          redirect_to passiv_all_sessions_path

        else
          redirect_to access_login_path
        end

      end
    end
  end

  def logout
    #save nil to session id - clear sesion_id
    session[ :logged_user_id] = nil
    session[ :is_mobile] = nil
    redirect_to access_login_path
  end
end