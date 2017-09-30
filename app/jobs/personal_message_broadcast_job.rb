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
      template: render_personal_message(personal_message, user, 'personal_messages/me'),
      conversation_id: personal_message.conversation_id,
      personal_message: personal_message,
      conversation_template: render_convo(personal_message, user)
    )
  end
 
  def broadcast_to_receiver(user, personal_message)
    ActionCable.server.broadcast(
      "conversations-#{user.id}",
      template: render_personal_message(personal_message, user, 'personal_messages/other'),
      conversation_id: personal_message.conversation_id,
      personal_message: personal_message,
      conversation_template: render_convo(personal_message, user)
    )
  end
 
  def render_personal_message(personal_message, user, partial)
    ApplicationController.render(
      partial: partial,
      locals: { personal_message: personal_message, user: user }
    )
  end

  def render_convo(message, user)
    ApplicationController.renderer.render(partial: 'conversations/member_convo', locals: { conversation: message.conversation, user:  message.conversation.with(user), logged_user: user}) 
  end
  
  
end
