class MessagesController < ApplicationController
  def new
    @message = Message.new
  end

  def create
    return if params[:do_not_use].present?

    @message = Message.new(message_params)

    if @message.save
      redirect_to events_path, notice: 'Success! Message sent.'
    else
      render :new
    end
  end

  private

  def message_params
    params.require(:message).except(:do_not_use).permit(:name, :body, :email)
  end
end
