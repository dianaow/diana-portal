class PersonalMessagesController < ApplicationController

    def create
      @conversation = Conversation.includes(:receiver).find(params[:conversation_id])
      @personal_message = @conversation.personal_messages.create(personal_message_params)
      respond_to do |format|
        format.js
      end
    end
    
    private
    
    def personal_message_params
      params.require(:personal_message).permit(:user_id, :body)
    end

end