class MessagesController < ApplicationController
  layout false
  
  before_filter :authenticate_user!

  # GET /messages
  # GET /messages.json
  def index
    channel = Channel.find_by_name(params[:channel_id])
    channel.touch_user(current_user)
    channel.update_users!
    
    if params[:last_message_id]
      @messages = channel.messages.includes(:user).where("id > ?", params[:last_message_id])
    elsif params[:history]
      # Probably a better way to do this. What I'm trying to do is
      # drop the hour/minute so each search starts from the beginning
      # of a given day
      tmp_time = Time.zone.parse(params[:from])
      @base_time = Time.zone.parse("#{tmp_time.year}-#{tmp_time.month}-#{tmp_time.day} 0:0:0 UTC")
      params[:until] ||= Time.zone.parse("#{tmp_time.year}-#{tmp_time.month}-#{tmp_time.day + 1} 0:0:0 UTC")

      @messages = channel.messages.includes(:user).where("created_at > ? and created_at < ?", params[:from], params[:until])
    else
      @messages = channel.messages.includes(:user).limit(50).order(:created_at).reverse_order
    end

    @message_data = []
    @messages.each do |message|
      @message_data.push({
          :id => message.id,
          :user => message.user.name,
          :content => message.escaped_content,
          :posted_at => message.created_at.strftime("%I:%M%p")
        })
    end
    
    respond_to do |format|
      format.html {}
      format.json { render :json => @message_data}
    end
  end

  # POST /messages
  # POST /messages.json
  def create
    @message = Message.new(params[:message])
    @message.user_id = current_user.id
    
    respond_to do |format|
      if @message.save
        format.json { render json: @message, status: :created}
      else
        format.json { render json: @message.errors, status: :unprocessable_entity }
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
      format.json { head :ok }
    end
  end
end
