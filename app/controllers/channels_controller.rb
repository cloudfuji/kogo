class ChannelsController < ApplicationController

  before_filter :authenticate_user!
  
  # GET /channels
  # GET /channels.json
  def index
    @channels = Channel.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @channels }
    end
  end

  # GET /channels/1
  # GET /channels/1.json
  def show
    @channel  = Channel.includes(:attachments).find_by_name!(params[:id])

    @users = []

    @title = @channel.name
    @messages = @channel.messages.includes(:user).limit(50).order("created_at DESC").reverse
    @message = Message.new :channel_id => @channel.id
    @channels = Channel.all
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @channel }
    end
  end

  # GET /channels/new
  # GET /channels/new.json
  def new
    @channel = Channel.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @channel }
    end
  end

  # Very simple search query
  def search
    @channel = Channel.find_by_name(params[:id])
    @messages = []
    minimum_query_length = 3

    if params[:query] and params[:query].length >= minimum_query_length
      @messages = @channel.messages.where("content LIKE ?", "%#{params[:query]}%").limit(params[:limit] || 100).all
    end

    respond_to do |format|
      format.html {}
      format.json { render :json => @messages.to_json }
    end
  end


  # GET /channels/1/edit
  def edit
    @channel = Channel.find_by_name(params[:id])
  end

  # POST /channels
  # POST /channels.json
  def create
    @channel = Channel.new(params[:channel])

    respond_to do |format|
      if @channel.save
        format.html { redirect_to @channel, notice: 'Channel was successfully created.' }
        format.json { render json: @channel, status: :created, location: @channel }
      else
        format.html { render action: "new" }
        format.json { render json: @channel.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /channels/1
  # PUT /channels/1.json
  def update
    @channel = Channel.find_by_name(params[:id])

    respond_to do |format|
      if @channel.update_attributes(params[:channel])
        format.html { redirect_to @channel, notice: 'Channel was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @channel.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /channels/1
  # DELETE /channels/1.json
  def destroy
    @channel = Channel.find_by_name(params[:id])
    @channel.destroy

    respond_to do |format|
      format.html { redirect_to channels_url }
      format.json { head :ok }
    end
  end
end
