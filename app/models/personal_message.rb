class PersonalMessage < ApplicationRecord
  belongs_to :conversation
  belongs_to :user
  validates :body, presence: true
  
  after_create_commit { PersonalMessageBroadcastJob.perform_later(self) }
  scope :unread, ->{where read_at: nil}
  
end
