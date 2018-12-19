class MessagesController < ApplicationController
  def create
    respond_to do |format|
      format.json do
        message = Message.create!(message_params)
        render json: message.to_json
      end
    end
  end

  def index
    respond_to do |format|
      format.html
      format.json do
        render json: Message.order('created_at DESC').to_json
      end
    end
  end

  private

  def message_params
    params.require(:message).permit(:name, :content)
  end
end
