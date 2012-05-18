class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  def index
    @users = User.all
    #only show user list when user is admin
    if @actual_user.is_admin?
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @user }
        format.mobile do
          render :action => 'index', :formats => 'html', :layout => 'application.mobile.erb'
        end
      end
    else
      redirect_to user_path(@actual_user)
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    #checks if user is admin or if actual_user is the same as the profile that will be shown
    if @actual_user.is_admin? || @actual_user == @user
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @user }
        format.mobile do
          render :action => 'show', :formats => 'html', :layout => 'application.mobile.erb'
        end
      end
    else
      redirect_to user_path(@actual_user)
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
      format.mobile do
          render :action => 'new', :formats => 'html', :layout => 'application.mobile.erb'
        end
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
        format.mobile { redirect_to @user, notice: 'User was successfully created.' }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
        format.mobile do
          render :action => 'new', :formats => 'html', :layout => 'application.mobile.erb'
        end
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
        format.mobile { redirect_to @user, notice: 'User was successfully updated.' }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
        format.mobile do
          render :action => 'edit', :formats => 'html', :layout => 'application.mobile.erb'
        end
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
      format.mobile { redirect_to users_url }
    end
  end
end
