class Article < ApplicationRecord
  enum status: { draft: 0, published: 1 }
  extend FriendlyId
  friendly_id :title, use: :slugged
  is_impressionable :counter_cache => true, :unique => true
  acts_as_votable
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :users, through: :comments
  has_many :impressions, as: :impressionable
  has_many :article_categories
  has_many :categories, through: :article_categories
end
