class SessionsController < ApplicationController
  #check if user is logged in <- this is executed every time a controller is active
  before_filter :require_login
  #check if user_agent is a mobile device <- this is executed every time a controller is active
  before_filter :check_mobile
  
  # GET /sessions
  # GET /sessions.json
  def index
    if is_admin?
      @sessions = Session.all
    else
      @sessions = current_user.sessions
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sessions }
      format.mobile do
        render :action => 'index', :formats => 'html', :layout => 'application.mobile.erb'
      end
    end
  end

  # GET /sessions/1
  # GET /sessions/1.json
  def show
    @session = Session.find(params[:id])
    if is_admin? || current_user.id == @session.owner_id
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @session }
        format.mobile do
          render :action => 'show', :formats => 'html', :layout => 'application.mobile.erb'
        end
      end
    else
     redirect_to sessions_path
    end
  end

  # GET /sessions/new
  # GET /sessions/new.json
  def new
    @session = Session.new(:owner_id=>current_user.id)
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @session }
      format.mobile do
        render :action => 'new', :formats => 'html', :layout => 'application.mobile.erb'
      end
    end
  end

  # GET /sessions/1/edit
  def edit
    @session = Session.find(params[:id])
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sessions }
      format.mobile do
        render :action => 'edit', :formats => 'html', :layout => 'application.mobile.erb'
      end
    end
  end

  # POST /sessions
  # POST /sessions.json
  def create
    @session = Session.new(params[:session])

    respond_to do |format|
      if @session.save
        format.html { redirect_to @session, notice: 'Session was successfully created.' }
        format.json { render json: @session, status: :created, location: @session }
        format.mobile { redirect_to @session, notice: 'Session was successfully created.' }
      else
        format.html { render action: "new" }
        format.json { render json: @session.errors, status: :unprocessable_entity }
        format.mobile do
          render :action => 'new', :formats => 'html', :layout => 'application.mobile.erb'
        end
      end
    end
  end

  # PUT /sessions/1
  # PUT /sessions/1.json
  def update
    @session = Session.find(params[:id])

    respond_to do |format|
      if @session.update_attributes(params[:session])
        format.html { redirect_to @session, notice: 'Session was successfully updated.' }
        format.json { head :no_content }
        format.mobile { redirect_to @session, notice: 'Session was successfully updated.' }
      else
        format.html { render action: "edit" }
        format.json { render json: @session.errors, status: :unprocessable_entity }
        format.mobile do
          render :action => 'edit', :formats => 'html', :layout => 'application.mobile.erb'
        end
      end
    end
  end

  # DELETE /sessions/1
  # DELETE /sessions/1.json
  def destroy
    @session = Session.find(params[:id])
    @session.destroy

    respond_to do |format|
      format.html { redirect_to sessions_url }
      format.json { head :no_content }
      format.mobile { redirect_to sessions_url }
    end
  end
  
end
