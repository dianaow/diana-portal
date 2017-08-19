class Article < ApplicationRecord
  is_impressionable :counter_cache => true, :unique => true
  acts_as_votable
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :users, through: :comments
end
