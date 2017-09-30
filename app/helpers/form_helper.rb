module FormHelper
  def setup_conversation(conversation)
      conversation.personal_messages.build
      conversation
  end
end