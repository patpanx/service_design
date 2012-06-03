class SessionsController < ApplicationController
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
    if is_admin?
      @session = Session.find(params[:id])
    else
      @session = current_user.sessions.find(params[:id])
    end
    
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
    logger.debug "-- current_user.id:#{ @current_user.id }"
    
    max_id = User.maximum("id")
    min_id = User.minimum("id")
    id_range = max_id - min_id + 1
    begin
    random_id = min_id + rand(id_range).to_i
   # logger.debug "---- random_id: #{ random_id }"
   #logger.debug "---- User.find(random_id).blank?: #{ User.find_by_id(random_id).blank? }"
    end while random_id == @current_user.id || User.find_by_id(random_id).blank?
    @randomUser = User.find_by_id(random_id)
   # logger.debug "---- users: #{ @randomUser.id }"
    @session = Session.new(:owner_id => current_user.id, :receiver_id => @randomUser.id)
    @session.save
    @message = Message.new(:session_id => @session.id, :owner_id => current_user.id)
    @message.save
    
    redirect_to edit_message_path(@message)
  end

  # GET /sessions/1/edit
  def edit
    if is_admin?
      @session = Session.find(params[:id])
    else
      @session = current_user.sessions.find(params[:id])
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @session }
      format.mobile do
        render :action => 'edit', :formats => 'html', :layout => 'application.mobile.erb'
      end
    end
  end

  # POST /sessions
  # POST /sessions.json
  def create
    @session = current_user.sessions.new(params[:session])
    

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
    if is_admin?
      @session = Session.find(params[:id])
    else
      @session = current_user.sessions.find(params[:id])
    end

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
    if is_admin?
      @session = Session.find(params[:id])
    else
      @session = current_user.sessions.find(params[:id])
    end
    @session.destroy

    respond_to do |format|
      format.html { redirect_to sessions_url }
      format.json { head :no_content }
      format.mobile { redirect_to sessions_url }
    end
  end
  
  
  def active_receiver_asked    
    @active_receiver_asked = Session.find(:all, :conditions =>  { :receiver_id => @current_user.id, :status => 'asked'})
    #@active_owner_answered = Session.find(:all, :conditions =>  { :owner_id => @current_user.id, :status => 'answered'})
    #@active_owner_asked = Session.find(:all, :conditions =>  { :owner_id => @current_user.id, :status => 'asked'})
    #@complete_owner_complete = Session.find(:all, :conditions =>  { :owner_id => @current_user.id, :status => 'complete'})
    #@complete_answered_sessions = Session.find(:all, :conditions =>  { :receiver_id => @current_user.id, :status => 'complete'})

    respond_to do |format|
      format.html do
        render :action => 'active_receiver_asked', :formats => 'html', :layout => false
      end
      format.json { render json: @session }
      format.mobile do
        render :action => 'active_receiver_asked', :formats => 'html', :layout => false
      end
    end
  end
  
  def active_owner_answered
        
    #@active_receiver_asked = Session.find(:all, :conditions =>  { :receiver_id => @current_user.id, :status => 'asked'})
    @active_owner_answered = Session.find(:all, :conditions =>  { :owner_id => @current_user.id, :status => 'answered'})
    #@active_owner_asked = Session.find(:all, :conditions =>  { :owner_id => @current_user.id, :status => 'asked'})
    #@complete_owner_complete = Session.find(:all, :conditions =>  { :owner_id => @current_user.id, :status => 'complete'})
    #@complete_answered_sessions = Session.find(:all, :conditions =>  { :receiver_id => @current_user.id, :status => 'complete'})
    
    respond_to do |format|
      format.html do
        render :action => 'active_owner_answered', :formats => 'html', :layout => false
      end
      format.json { render json: @session }
      format.mobile do
        render :action => 'active_owner_answered', :formats => 'html', :layout => false
      end
    end
  end
    
  def active_owner_asked
    #@active_sessions = Session.find(:all, :conditions =>  [ 'owner_id = :current_user or receiver_id = :current_user and status = :status_new or status = :status_received', {:current_user => @current_user.id, :status_new => "new", :status_received => 'received'}] )  
    
    #@active_receiver_asked = Session.find(:all, :conditions =>  { :receiver_id => @current_user.id, :status => 'asked'})
    #@active_owner_answered = Session.find(:all, :conditions =>  { :owner_id => @current_user.id, :status => 'answered'})
    @active_owner_asked = Session.find(:all, :conditions =>  { :owner_id => @current_user.id, :status => 'asked'})
    #@complete_owner_complete = Session.find(:all, :conditions =>  { :owner_id => @current_user.id, :status => 'complete'})
    #@complete_answered_sessions = Session.find(:all, :conditions =>  { :receiver_id => @current_user.id, :status => 'complete'})

    respond_to do |format|
      format.html do
        render :action => 'active_owner_asked', :formats => 'html', :layout => false
      end
      format.json { render json: @session }
      format.mobile do
        render :action => 'active_owner_asked', :formats => 'html', :layout => false
      end
    end
  end
  
  def passiv_all
    #@active_sessions = Session.find(:all, :conditions =>  [ 'owner_id = :current_user or receiver_id = :current_user and status = :status_new or status = :status_received', {:current_user => @current_user.id, :status_new => "new", :status_received => 'received'}] )  
    
    #@active_receiver_asked = Session.find(:all, :conditions =>  { :receiver_id => @current_user.id, :status => 'asked'})
    #@active_owner_answered = Session.find(:all, :conditions =>  { :owner_id => @current_user.id, :status => 'answered'})
    @passiv_all = Session.find(:all, :conditions => ['owner_id = ? OR receiver_id = ?', @current_user.id, @current_user.id], :limit => 10,:order => "updated_at DESC" )
    #@complete_owner_complete = Session.find(:all, :conditions =>  { :owner_id => @current_user.id, :status => 'complete'})
    #@complete_answered_sessions = Session.find(:all, :conditions =>  { :receiver_id => @current_user.id, :status => 'complete'})

    respond_to do |format|
      format.html do
        render :action => 'passiv_all', :formats => 'html'
      end
      format.json { render json: @session }
      format.mobile do
        render :action => 'passiv_all', :formats => 'html', :layout => 'application.mobile.erb'
      end
    end
  end
    
    
  def active_sessions
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @session }
      format.mobile do
        render :action => 'active_sessions', :formats => 'html', :layout => 'application.mobile.erb'
      end
    end 
  end
  
  def show_active
    #@active_sessions = Session.find(:all, :conditions =>  [ 'owner_id = :current_user or receiver_id = :current_user and status = :status_new or status = :status_received', {:current_user => @current_user.id, :status_new => "new", :status_received => 'received'}] )  
    
    #@active_receiver_asked = Session.find(:all, :conditions =>  { :receiver_id => @current_user.id, :status => 'asked'})
    #@active_owner_answered = Session.find(:all, :conditions =>  { :owner_id => @current_user.id, :status => 'answered'})
    @active_owner_asked = Session.find(:all, :conditions =>  { :owner_id => @current_user.id, :status => 'asked'})
    #@complete_owner_complete = Session.find(:all, :conditions =>  { :owner_id => @current_user.id, :status => 'complete'})
    #@complete_answered_sessions = Session.find(:all, :conditions =>  { :receiver_id => @current_user.id, :status => 'complete'})

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @session }
      format.mobile do
        render :action => 'show_active', :formats => 'html', :layout => 'application.mobile.erb'
      end
    end
    end
  
end
