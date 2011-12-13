class AttachmentsController < ApplicationController

  before_filter :authenticate_user!
  
  # GET /attachments
  # GET /attachments.json
  def index
  end

  # GET /attachments/1
  # GET /attachments/1.json
  def show
  end

  # GET /attachments/new
  # GET /attachments/new.json
  def new
  end

  # GET /attachments/1/edit
  def edit
  end

  # POST /attachments
  # POST /attachments.json
  def create
    @channel    = Channel.find_by_name(params[:channel_id])
    @attachment = Attachment.new(params[:attachment])

    # {"file"=>#<ActionDispatch::Http::UploadedFile:0x00000005bc3158 @original_filename="investor_faq.org", @content_type="application/octet-stream",
    #   @headers="Content-Disposition: form-data; name=\"file\"; filename=\"investor_faq.org\"\r\nContent-Type: application/octet-stream\r\n",      @tempfile=#<File:/tmp/RackMultipart20111212-24212-4znzta>>
    #   "commit"=>"Upload",
    #   "utf8"=>"✓",
    #   "authenticity_token"=>"SrS7bnPQ76RQJLWOx58bm1uyDsQq5f4FObPLl9Zh+Ao=",
    #   "remotipart_submitted"=>"true",
    #   "X-Requested-With"=>"IFrame",
    #   "X-Http-Accept"=>"text/javascript, application/javascript, application/ecmascript, application/x-ecmascript, */*; q=0.01",
    #   "channel_id"=>"Shiro"
    # }

    @attachment.user = current_user
    @attachment.channel = Channel.find_by_name(params[:channel_id])
    @attachment.file = params[:file]

    respond_to do |format|
      if @attachment.save
        format.html { }
        format.js
        format.json { render json: @attachment, status: :created }
      else
        format.html { render action: "new" }
        format.js
        format.json { render json: @attachment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /attachments/1
  # PUT /attachments/1.json
  def update
    @attachment = Attachment.find_by_name(params[:id])

    respond_to do |format|
      if @attachment.update_attributes(params[:attachment])
        format.html { redirect_to @attachment, notice: 'Attachment was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @attachment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /attachments/1
  # DELETE /attachments/1.json
  def destroy
    @attachment = Attachment.find_by_name(params[:id])
    @attachment.destroy

    respond_to do |format|
      format.html { redirect_to attachments_url }
      format.json { head :ok }
    end
  end
end
