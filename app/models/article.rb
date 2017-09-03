class Article < ApplicationRecord
  enum status: { draft: 0, published: 1 }
  is_impressionable :counter_cache => true, :unique => true
  acts_as_votable
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :users, through: :comments
  has_many :impressions, as: :impressionable
end
