class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :article
  has_many :notifications, as: :notifiable, dependent: :destroy
  validates :content, presence: true, length: { minimum: 5, maximimum: 1000 }
  
end
