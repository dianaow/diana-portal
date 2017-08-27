class PersonalMessageBroadcastJob < ApplicationJob
 queue_as :default
 
  def perform(personal_message)
    author = personal_message.user
    receiver = personal_message.conversation.with(author)
 
    broadcast_to_author(author, personal_message)
    broadcast_to_receiver(receiver, personal_message)
  end
 
  private
 
  def broadcast_to_author(user, personal_message)
    ActionCable.server.broadcast(
      "conversations-#{user.id}",
      personal_message: render_personal_message(personal_message, user),
      conversation_id: personal_message.conversation_id
    )
  end
 
  def broadcast_to_receiver(user, personal_message)
    ActionCable.server.broadcast(
      "conversations-#{user.id}",
      window: render_window(personal_message.conversation, user),
      personal_message: render_personal_message(personal_message, user),
      conversation_id: personal_message.conversation_id
    )
  end
 
  def render_personal_message(personal_message, user)
    ApplicationController.render(
      partial: 'personal_messages/personal_message',
      locals: { personal_message: personal_message, user: user }
    )
  end
  
  def render_window(conversation, user)
    ApplicationController.render(
      partial: 'conversations/conversation',
      locals: { conversation: conversation, user: user }
    )
  end
  
end
