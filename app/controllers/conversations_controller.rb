class ConversationsController < ApplicationController

    def index
      @conversation_list = Conversation.participating(current_user)
    end

    def create
      if params["conversation_id"]
        @conversation = Conversation.find(params["conversation_id"])
      elsif 
        @conversation = Conversation.get(current_user.id, params["user_id"])
      end
      @conversation.read!(current_user) if @conversation
      respond_to do |format|
        format.js
      end
    end

    def list
      if params[:type] == 'unread'
        @conversation_list = Conversation.by_unread(current_user)
      else
        @conversation_list = Conversation.participating(current_user)
      end
        
      respond_to do |format|
        format.js
      end
    end
     
    def new
      respond_to do |format|
        format.js
      end
    end

end