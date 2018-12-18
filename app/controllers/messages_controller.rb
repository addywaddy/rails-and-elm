class MessagesController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.json do
        render json: Message.all.to_json
      end
    end
  end
end
