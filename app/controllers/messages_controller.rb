class MessagesController < ApplicationController

  before_action :signed_in_user, only: [:index,:create, :destroy,:inbox,:outbox]
  before_action :set_message, only: [:show, :edit, :update, :destroy]


  # GET /messages
  # GET /messages.json
  def index
    @messages = current_user.all_messages
    # @messages=conversation(current_user,User.find(3))
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
     @user = User.find(params[:id])
     @messages=conversation(current_user,user)

  end

  # GET /messages/new
  def new
    @message = Message.new
  end

  # GET /messages/1/edit
  def edit
  end

  # POST /messages
  # POST /messages.json
  def create
     @message = Message.create!(
      :from_user_id => current_user.id,
      :to_user_id => message_params[:to_user_id],
      :content => message_params[:content])
     #if(@message.nil?)
     #flash.now[:failure] = "Invalid To user or Content  field !!!"
    # else
       flash.now[:success] = "message sent.."
   # end
    # PrivatePub.publish_to("/messages/new", message: @message)
   # @message = Message.new(message_params)   
    #  if @message.save
     #   flash[:success] = "message sent.."
     # end

  end


  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message.destroy
    redirect_to messages_url
  end

  def inbox
      @messages=current_user.my_messages
      render 'messages/inbox'
  end

  def outbox
      @messages=current_user.sent_messages
      render 'messages/outbox'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.require(:message).permit(:content, :from_user_id, :to_user_id)
    end
end
