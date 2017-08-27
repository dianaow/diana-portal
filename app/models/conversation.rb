class Conversation < ApplicationRecord
    
belongs_to :author, class_name: 'User'
belongs_to :receiver, class_name: 'User'
validates :author, uniqueness: {scope: :receiver}
has_many :personal_messages, -> { order(created_at: :asc) }, dependent: :destroy

scope :participating, -> (user) do
  where("(conversations.author_id = ? OR conversations.receiver_id = ?)", user.id, user.id)
end

def with(current_user)
  author == current_user ? receiver : author
end

def participates?(user)
  author == user || receiver == user
end

scope :between, -> (author_id, receiver_id) do
  where(author_id: author_id, receiver_id: receiver_id).or(where(author_id: receiver_id, receiver_id: author_id)).limit(1)
end

def self.get(author_id, receiver_id)
  conversation = between(author_id, receiver_id).first
  return conversation if conversation.present?
  create(author_id: author_id, receiver_id: receiver_id)
end

end
