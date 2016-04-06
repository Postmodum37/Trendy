class MessagesController < ApplicationController

  before_filter :authenticate_user!
  before_action :set_message, only: [ :show ]
  before_action :authorized_user, only: [ :show, :new, :create, :index, :sent ]

  def index
    @messages = current_user.recieved_messages.paginate(:page => params[:page], :per_page => 10).order(created_at: :desc)
  end

  def sent
    @messages = current_user.sent_messages.paginate(:page => params[:page], :per_page => 10).order(created_at: :desc)
  end

  def show
    @message.update(seen: true) if @message.recipient_id == current_user.id && @message.seen == false
  end

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)
    @message.user_id = current_user.id

    respond_to do |format|
      if @message.save
        format.html { redirect_to messages_path, notice: 'Message was successfully sent.' }
        format.json { render :show, status: :created, location: @message }
      else
        format.html { render :new }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.require(:message).permit(:message_heading, :message_text, :recipient_id)
    end

    def authorized_user
      # @message = current_user.sent_messages.find_by(id: params[:id])
      #redirect_to messages_path, notice: "Not authorized to edit this message" if @message.nil? || current_user.try(:admin?)
      redirect_to :messages_path unless user_signed_in? || current_user.admin?
    end
end
