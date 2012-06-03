class MessagesController < ApplicationController
  # GET /messages
  # GET /messages.json
  def index
    @messages = Message.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @messages }
      format.mobile do
        render :action => 'index', :formats => 'html', :layout => 'application.mobile.erb'
      end
    end
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
    @message = Message.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @message }
      format.mobile do
        render :action => 'show', :formats => 'html', :layout => 'application.mobile.erb'
      end
    end
  end

  # GET /messages/new
  # GET /messages/new.json
  def new
    @message = Message.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @message }
      format.mobile do
        render :action => 'new', :formats => 'html', :layout => 'application.mobile.erb'
      end
    end
  end

  # GET /messages/1/edit
  def edit
    @message = Message.find(params[:id])
    respond_to do |format|
      format.html do # index.html.erb
        render :action => 'edit', :formats => 'html', :layout => false
      end
      format.json { render json: @message }
      format.mobile do
        render :action => 'edit', :formats => 'html', :layout => false
      end
    end
  end

  # POST /messages
  # POST /messages.json
  def create
    @message = Message.new(params[:message])

    respond_to do |format|
      if @message.save
        format.html { redirect_to @message, notice: 'Message was successfully created.' }
        format.json { render json: @message, status: :created, location: @message }
        format.mobile { redirect_to @message, notice: 'Message was successfully created.' }
      else
        format.html { render action: "new" }
        format.json { render json: @message.errors, status: :unprocessable_entity }
        format.mobile do
          render :action => 'new', :formats => 'html', :layout => 'application.mobile.erb'
        end
      end
    end
  end

  # PUT /messages/1
  # PUT /messages/1.json
  def update
    @message = Message.find(params[:id])
    @receiver_id = @message.session.receiver_id
    @message_session = @message.session
    if @message.session.message.size <=1
      @message.status = "asked"
      @message_session.status = "asked"
      @message.receiver_id = @receiver_id 
    else
      @message.status = "answered"
      @message_session.status = "answered"
      @message.receiver_id = @message.session.owner_id
    end
    logger.debug "---- @message.session: #{ @message.session }"
    
    @message.save
    @message_session.save

    if @message.session.message.size <=1
      @re_message = Message.new( :owner_id => @receiver_id, :session_id => @message.session_id)
    @re_message.save
    end
    
   
    
    respond_to do |format|
      if @message.update_attributes(params[:message])
        render :file => false
      else
        render :file => false
      end
    end

  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message = Message.find(params[:id])
    @message.destroy

    respond_to do |format|
      format.html { redirect_to messages_url }
      format.json { head :no_content }
      format.mobile { redirect_to messages_url }
    end
  end

  def send_message
    message = Message.find(params[:id])
  end

  def show_active
    #@message = Message.find(params[:id])
    @active_messages = Message.find(:all, :conditions => {:owner_id => @current_user.id, :status => "new"}, :order => "updated_at DESC" )
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @message }
      format.mobile do
        render :action => 'show_active', :formats => 'html', :layout => 'application.mobile.erb'
      end
    end
  end

end
