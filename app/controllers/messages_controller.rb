class MessagesController < ApplicationController
  before_filter :authenticate_user!

  def create
    @conversation = Conversation.find(params[:conversation_id])
    if current_user.id == @conversation.sender_id
      @receiver = @conversation.recipient
    else
      @receiver = @conversation.sender
    end
    @message = @conversation.messages.build(:body => params[:message][:body].to_s)
    @message.user_id = current_user.id
    @message.save!

    @path = conversation_path(@conversation)
  end

  def update_status
    @conversation = Conversation.find(params[:conversation_id])
    @conversation.messages.where("is_read = ?",false).update_all(:is_read => true)
    @sender_id = current_user.id == @conversation.sender_id ? @conversation.recipient_id : @conversation.sender_id
  end

  private

  def message_params
    params.require(:message).permit(:body)
  end
end
