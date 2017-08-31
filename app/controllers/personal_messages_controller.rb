class PersonalMessagesController < ApplicationController

    def mark_as_read 
      @personal_messages = PersonalMessage.where(recipient: current_user).unread 
      @personal_messages.update_all(read_at: Time.zone.now)
      render json: {success: true}
    end 
end
