class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validates :name, presence: true
  acts_as_voter       
  has_many :articles, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :notifications, foreign_key: :recipient_id
  has_many :friendships
  has_many :received_friendships, class_name: "Friendship", foreign_key: "friend_id"
  has_many :active_friends, -> { where(friendships: { accepted: true}) }, through: :friendships, source: :friend
  has_many :received_friends, -> { where(friendships: { accepted: true}) }, through: :received_friendships, source: :user
  has_many :pending_friends, -> { where(friendships: { accepted: false}) }, through: :friendships, source: :friend
  has_many :requested_friendships, -> { where(friendships: { accepted: false}) }, through: :received_friendships, source: :user
  has_many :authored_conversations, class_name: 'Conversation', foreign_key: 'author_id'
  has_many :received_conversations, class_name: 'Conversation', foreign_key: 'received_id'
  has_many :personal_messages, dependent: :destroy
  
  scope :all_except, ->(user) { where.not(id: user) }
    
  def friends
    active_friends | received_friends
  end

  def pending
    pending_friends | requested_friendships
  end
  
  def follows?(new_friend)
    friendships.map(&:friend).include?(new_friend)
  end
  
  def self.search(search)
      where('name LIKE ?', "%#{search}%")
  end

  def feed
    following_ids = "SELECT friend_id FROM friendships
                     WHERE (user_id = :user_id AND accepted = 't')"
    Article.published.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
  end


end
