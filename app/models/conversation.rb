class Conversation < ApplicationRecord
    
belongs_to :author, class_name: 'User'
belongs_to :receiver, class_name: 'User'
validates :author, uniqueness: {scope: :receiver}
validate :author_cannot_be_receiver

has_many :personal_messages, -> { order(created_at: :asc) }, dependent: :destroy
has_many :all_unread_messages, -> { where(read_at: nil) }, class_name: "PersonalMessage", foreign_key: "conversation_id"

#scopes
default_scope { order(updated_at: :desc) }

scope :participating, -> (user) do
  where("(conversations.author_id = ? OR conversations.receiver_id = ?)", user.id, user.id)
end

scope :by_unread, -> (user) do
  where("(conversations.author_id = ? OR conversations.receiver_id = ?)", user.id, user.id)
  .joins('RIGHT JOIN "personal_messages" ON "personal_messages"."conversation_id" = "conversations"."id"')
  .where.not(personal_messages: {user_id: user.id})
  .where(personal_messages: { read_at: nil})
  .reorder('personal_messages.read_at asc').uniq
end

def last_string
  personal_messages.last.body rescue nil
end

def with(current_user) #returns the other participant of a conversation
  author == current_user ? receiver : author
end

def participates?(user)
  author == user || receiver == user
end

def unread_messages_count current_user
  _w = with(current_user)
  all_unread_messages.where(user_id: _w.id).count
end

def read! current_user
  unread_messages(current_user).update(read_at: Time.now)
end

def unread_messages current_user
  _w = with(current_user)
  personal_messages.where(read_at: nil, user_id: _w.id)
end

scope :between, -> (author_id, receiver_id) do
  where(author_id: author_id, receiver_id: receiver_id).or(where(author_id: receiver_id, receiver_id: author_id)).limit(1)
end

def self.get(author_id, receiver_id)
  conversation = between(author_id, receiver_id).first
  return conversation if conversation.present?
  create(author_id: author_id, receiver_id: receiver_id)
end

def self.options_for_filter
	[
		['Unread', 'unread'],
		['All', 'read'],

	]
end

private
  def author_cannot_be_receiver
    if author == receiver
       errors[:base] = "Cannot send message to self"
    end
  end
end
