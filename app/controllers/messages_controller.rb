class MessagesController < ApplicationController
  # GET /messages
  # GET /messages.json
  def index
    @messages = Message.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @messages }
    end
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
    @message = Message.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @message }
    end
  end

  # GET /messages/new
  # GET /messages/new.json
  def new
    @message = Message.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @message }
    end
  end

  # GET /messages/1/edit
  def edit
    @message = Message.find(params[:id])

  end

  # POST /messages
  # POST /messages.json
  def create
    @message = Message.new(params[:message])

    respond_to do |format|
      if @message.save
        format.html { redirect_to @message, notice: 'Message was successfully created.' }
        format.json { render json: @message, status: :created, location: @message }
      else
        format.html { render action: "new" }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /messages/1
  # PUT /messages/1.json
  def update
    @message = Message.find(params[:id])

    respond_to do |format|
      if @message.update_attributes(params[:message])
        format.html { redirect_to @message, notice: 'Message was successfully sent.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end

    end
    max_id = User.maximum("id")
    min_id = User.minimum("id")
    id_range = max_id - min_id + 1
    begin
    random_id = min_id + rand(id_range).to_i
    logger.debug "---- random_id: #{ random_id }"
    logger.debug "---- User.find(random_id).blank?: #{ User.find_by_id(random_id).blank? }"
    end while random_id == @current_user.id || User.find_by_id(random_id).blank?
    @randomUser = User.find_by_id(random_id)
    logger.debug "---- users: #{ @randomUser.id }"
    
    @message.receiver_id = @randomUser.id
    @message.status = "sent"
    @message.save
    
    if @message.session.message.size <2
    @re_message = Message.new( :owner_id => @randomUser.id, :session_id => @message.session_id, :receiver_id => @message.owner_id)
    @re_message.save
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
    end
  end

end
